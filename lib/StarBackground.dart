import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// Star Model
class Star {
  Offset position; // Position of the star on the canvas
  double size; // Radius of the star
  Color color; // Color of the star
  double opacity; // Current opacity of the star
  double pulseRate; // Rate at which the star's opacity changes
  bool isIncreasing; // Direction of opacity change
  final double minOpacity; // Minimum opacity value
  final double maxOpacity; // Maximum opacity value
  bool shouldFadeOut; // Indicates if the star should start fading out

  Star({
    required this.position,
    required this.size,
    required this.color,
    this.opacity = 1.0,
    required this.pulseRate,
    this.isIncreasing = true,
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
    this.shouldFadeOut = false, // Initialize as false
  });
}

// ShootingStar Model
class ShootingStar {
  Offset startPosition; // Starting point of the shooting star
  Offset endPosition; // Ending point of the shooting star
  Offset currentPosition; // Current position as it moves
  double speed; // Speed at which the shooting star moves
  double opacity; // Current opacity for fading effect
  bool isFadingIn; // Indicates if the shooting star is fading in
  bool isFadingOut; // Indicates if the shooting star is fading out

  ShootingStar({
    required this.startPosition,
    required this.endPosition,
    required this.speed,
    this.opacity = 0.0, // Start fully transparent
    this.isFadingIn = true,
    this.isFadingOut = false,
  }) : currentPosition = startPosition;
}

// Custom Painter for Pulsing Stars and Shooting Stars
class PulsingStarsPainter extends CustomPainter {
  final List<Star> stars;
  final List<ShootingStar> shootingStars; // Added shootingStars list

  PulsingStarsPainter(this.stars, this.shootingStars); // Modified constructor

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Draw pulsing stars
    for (var star in stars) {
      paint.color = star.color.withOpacity(star.opacity);
      canvas.drawCircle(star.position, star.size, paint);
    }

    // Draw shooting stars
    final Paint shootingStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.8) // Customize color as needed
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (var shootingStar in shootingStars) {
      shootingStarPaint.color =
          shootingStarPaint.color.withOpacity(shootingStar.opacity);
      canvas.drawLine(shootingStar.startPosition, shootingStar.currentPosition,
          shootingStarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PulsingStarsPainter oldDelegate) {
    // Repaint whenever the stars or shootingStars list changes
    return true;
  }
}

// PulsingStarsBackground Widget
class PulsingStarsBackground extends StatefulWidget {
  final int maxStars; // Maximum number of stars on the screen
  final Duration spawnDuration; // How often a new star is spawned
  final Duration spawnShootingStarDuration; // How often a new shooting star is spawned
  final Duration updateDuration; // How often the stars are updated

  const PulsingStarsBackground({
    Key? key,
    this.maxStars = 100,
    this.spawnDuration = const Duration(milliseconds: 500),
    this.updateDuration = const Duration(milliseconds: 50),
    this.spawnShootingStarDuration = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  _PulsingStarsBackgroundState createState() =>
      _PulsingStarsBackgroundState();
}

class _PulsingStarsBackgroundState extends State<PulsingStarsBackground> {
  final List<Star> _stars = [];
  final List<ShootingStar> _shootingStars = []; // Added list for shooting stars
  late Timer _spawnTimer;
  late Timer _updateTimer;
  late Timer _shootingStarTimer; // Added timer for shooting stars
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Start spawning stars
    _spawnTimer = Timer.periodic(widget.spawnDuration, (timer) {
      if (_stars.length < widget.maxStars) {
        _addStar();
      }
    });

    // Start spawning shooting stars at defined intervals
    _shootingStarTimer =
        Timer.periodic(widget.spawnShootingStarDuration, (timer) {
          _spawnShootingStar();
        });

    // Start updating stars and shooting stars
    _updateTimer = Timer.periodic(widget.updateDuration, (timer) {
      _updateStars();
      _updateShootingStars(); // Update shooting stars
    });
  }

  @override
  void dispose() {
    _spawnTimer.cancel();
    _updateTimer.cancel();
    _shootingStarTimer.cancel(); // Cancel shooting star timer
    super.dispose();
  }

  void _addStar() {
    final Size size = MediaQuery.of(context).size;
    final double x = _random.nextDouble() * size.width;
    final double y = _random.nextDouble() * size.height;
    final double starSize = _random.nextDouble() * 2 + 1; // Size between 1 and 3
    final Color starColor =
    Colors.white.withOpacity(0.8); // Slight transparency
    final double pulseRate =
        _random.nextDouble() * 0.02 + 0.005; // Pulse rate between 0.005 and 0.025
    final double minOpacity = 0.5;
    final double maxOpacity = 1.0;

    setState(() {
      _stars.add(Star(
        position: Offset(x, y),
        size: starSize,
        color: starColor,
        opacity:
        minOpacity + _random.nextDouble() * (maxOpacity - minOpacity),
        pulseRate: pulseRate,
        isIncreasing: _random.nextBool(),
        minOpacity: minOpacity,
        maxOpacity: maxOpacity,
        shouldFadeOut: false, // Initialize as false
      ));
    });
  }

  void _spawnShootingStar() {
    final Size size = MediaQuery.of(context).size;

    // Define edges
    List<String> edges = ['top', 'bottom', 'left', 'right'];

    // Randomly select a start edge
    String startEdge = edges[_random.nextInt(edges.length)];

    // Remove the selected start edge to avoid shooting back to the same edge
    List<String> possibleEndEdges = List.from(edges)..remove(startEdge);

    // Randomly select an end edge from the remaining edges
    String endEdge = possibleEndEdges[_random.nextInt(possibleEndEdges.length)];

    // Function to generate a position just outside the selected edge
    Offset getPosition(String edge) {
      switch (edge) {
        case 'top':
          return Offset(_random.nextDouble() * size.width, -10); // Slightly above the top edge
        case 'bottom':
          return Offset(_random.nextDouble() * size.width, size.height + 10); // Slightly below the bottom edge
        case 'left':
          return Offset(-10, _random.nextDouble() * size.height); // Slightly to the left of the left edge
        case 'right':
          return Offset(size.width + 10, _random.nextDouble() * size.height); // Slightly to the right of the right edge
        default:
          return Offset(0, 0);
      }
    }

    // Generate start and end positions
    Offset startPosition = getPosition(startEdge);
    Offset endPosition = getPosition(endEdge);

    double speed = _random.nextDouble() * 5 + 5; // Speed between 5 and 10 pixels per update

    setState(() {
      _shootingStars.add(ShootingStar(
        startPosition: startPosition,
        endPosition: endPosition,
        speed: speed,
        opacity: 0.0, // Start fully transparent for fade-in
        isFadingIn: true, // New property to track fade-in phase
        isFadingOut: false, // New property to track fade-out phase
      ));
    });
  }

  void _updateStars() {
    setState(() {
      for (var star in _stars) {
        if (!star.shouldFadeOut) {
          // Random chance to start fading out
          if (_random.nextDouble() < 0.001) { // Adjust probability as needed
            star.shouldFadeOut = true;
          }
        }

        if (star.shouldFadeOut) {
          // Fade out the star
          star.opacity -= 0.01; // Adjust fade-out speed as needed
          if (star.opacity <= 0.0) {
            star.opacity = 0.0;
            // Optionally, remove the star from the list
            // _stars.remove(star);
          }
        } else {
          // Continue pulsing
          if (star.isIncreasing) {
            star.opacity += star.pulseRate;
            if (star.opacity >= star.maxOpacity) {
              star.opacity = star.maxOpacity;
              star.isIncreasing = false;
            }
          } else {
            star.opacity -= star.pulseRate;
            if (star.opacity <= star.minOpacity) {
              star.opacity = star.minOpacity;
              star.isIncreasing = true;
            }
          }
        }
      }

      // Remove stars that have fully faded out
      _stars.removeWhere((star) => star.opacity <= 0.0);
    });
  }

  void _updateShootingStars() {
    setState(() {
      for (int i = _shootingStars.length - 1; i >= 0; i--) {
        ShootingStar shootingStar = _shootingStars[i];

        // Calculate direction vector
        double dx = shootingStar.endPosition.dx - shootingStar.startPosition.dx;
        double dy = shootingStar.endPosition.dy - shootingStar.startPosition.dy;
        double distance = sqrt(dx * dx + dy * dy);
        double directionX = dx / distance;
        double directionY = dy / distance;

        // Update current position
        Offset newPosition = shootingStar.currentPosition +
            Offset(directionX * shootingStar.speed, directionY * shootingStar.speed);
        shootingStar.currentPosition = newPosition;

        // Calculate how far the shooting star has traveled
        double traveledDistance = (shootingStar.currentPosition - shootingStar.startPosition).distance;

        // Check if the shooting star has traveled more than half the distance
        if (!shootingStar.isFadingOut && traveledDistance >= distance / 2) {
          shootingStar.isFadingOut = true; // Start fading out
        }

        // Handle fade-in
        if (shootingStar.isFadingIn) {
          shootingStar.opacity += 0.02; // Adjust fade-in speed as needed
          if (shootingStar.opacity >= 1.0) {
            shootingStar.opacity = 1.0;
            shootingStar.isFadingIn = false;
            // Removed: shootingStar.isFadingOut = true; // Fading out is now handled by position
          }
        }

        // Handle fade-out
        if (shootingStar.isFadingOut) {
          shootingStar.opacity -= 0.02; // Adjust fade-out speed as needed
          if (shootingStar.opacity <= 0.0) {
            shootingStar.opacity = 0.0;
            _shootingStars.removeAt(i);
            continue; // Skip further checks for this shooting star
          }
        }

        // Remove shooting star if it has reached or passed the end position
        if ((directionX > 0 && shootingStar.currentPosition.dx >= shootingStar.endPosition.dx) ||
            (directionX < 0 && shootingStar.currentPosition.dx <= shootingStar.endPosition.dx) ||
            (directionY > 0 && shootingStar.currentPosition.dy >= shootingStar.endPosition.dy) ||
            (directionY < 0 && shootingStar.currentPosition.dy <= shootingStar.endPosition.dy)) {
          _shootingStars.removeAt(i);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PulsingStarsPainter(_stars, _shootingStars), // Pass shootingStars to the painter
      size: Size.infinite,
    );
  }
}
