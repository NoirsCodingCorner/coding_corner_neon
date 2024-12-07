import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedGradientText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final Duration duration;
  final int shades;

  const AnimatedGradientText({
    Key? key,
    required this.text,
    required this.style,
    required this.colors,
    this.duration = const Duration(seconds: 5),
    this.shades = 32,
  }) : super(key: key);

  @override
  _AnimatedGradientTextState createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Color> interpolatedColors;
  late final double randomOffset; // Store random offset

  @override
  void initState() {
    super.initState();
    randomOffset = Random().nextDouble() * 2 - 1; // Random value between -1 and 1
    interpolatedColors =
        _generateInterpolatedColors(widget.colors, widget.shades);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  // Generates a list of colors by interpolating between the provided colors using RGB blending
  List<Color> _generateInterpolatedColors(
      List<Color> baseColors, int steps) {
    List<Color> result = [];
    int totalTransitions = baseColors.length;

    // Calculate the number of steps for each color transition
    int stepsPerTransition = steps ~/ totalTransitions;

    // Loop through each pair of base colors
    for (int i = 0; i < baseColors.length; i++) {
      Color start = baseColors[i];
      Color end = baseColors[(i + 1) % baseColors.length];

      // Extract RGB values for start and end colors
      int startR = start.red, startG = start.green, startB = start.blue;
      int endR = end.red, endG = end.green, endB = end.blue;

      // Interpolate between start and end colors
      for (int step = 0; step < stepsPerTransition; step++) {
        double t = step / stepsPerTransition;

        // Calculate intermediate RGB values
        int r = (startR + ((endR - startR) * t)).round();
        int g = (startG + ((endG - startG) * t)).round();
        int b = (startB + ((endB - startB) * t)).round();

        // Create interpolated color and add to the result list
        result.add(Color.fromARGB(255, r, g, b));
      }
    }

    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate the current color based on the animation controller's value
          // This will be used for the glow effect
          int currentShade =
              (_controller.value * interpolatedColors.length).floor() %
                  interpolatedColors.length;
          Color currentGlowColor =
          interpolatedColors[currentShade].withOpacity(0.7);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow Layer using TextField
              TextField(
                controller: TextEditingController(text: widget.text),
                readOnly: true, // Make it non-editable
                enableInteractiveSelection:
                false, // Disable text selection
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove borders
                  isDense: true, // Reduce vertical padding
                  contentPadding:
                  EdgeInsets.zero, // Remove default padding
                ),
                style: widget.style.copyWith(
                  color: Colors.white, // Base color (will be masked by ShaderMask)
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: currentGlowColor,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 30.0,
                      color: currentGlowColor.withOpacity(0.5),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                // Disable cursor
                cursorWidth: 0,
                showCursor: false,
                // Disable focus
                focusNode: AlwaysDisabledFocusNode(),
              ),
              // Gradient Text Layer using ShaderMask and TextField
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    transform: const GradientRotation(pi / 4),
                    colors: interpolatedColors,
                    begin: Alignment(
                        -1.0 + 2 * (_controller.value + randomOffset), 0),
                    end: Alignment(
                        1.0 + 2 * (_controller.value + randomOffset), 0),
                    tileMode: TileMode.repeated,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: TextField(
                  controller: TextEditingController(text: widget.text),
                  readOnly: true, // Make it non-editable
                  enableInteractiveSelection:
                  false, // Disable text selection
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Remove borders
                    isDense: true, // Reduce vertical padding
                    contentPadding:
                    EdgeInsets.zero, // Remove default padding
                  ),
                  style: widget.style.copyWith(
                    color: Colors.white, // Base color (will be masked by ShaderMask)
                  ),
                  // Disable cursor
                  cursorWidth: 0,
                  showCursor: false,
                  // Disable focus
                  focusNode: AlwaysDisabledFocusNode(),
                ),
              ),
            ],
          );
        },
        child: const SizedBox.shrink(), // Placeholder child
      ),
    );
  }
}

// Custom FocusNode to disable focus on TextField
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
