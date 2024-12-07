import 'package:flutter/material.dart';
import 'dart:math';

class NeonButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color neonColor;
  final VoidCallback onPressed;
  final double glowRadius;

  const NeonButton({
    Key? key,
    required this.icon,
    this.size = 60.0,
    this.neonColor = Colors.cyanAccent,
    required this.onPressed,
    this.glowRadius = 20.0,
  }) : super(key: key);

  @override
  _NeonButtonState createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Handle press down
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
      // Do not stop the animationController to keep pulsating
    });
  }

  // Handle press up
  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  // Handle press cancel
  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        // Combine pulsating scale with pressed scale
        scale: (_isPressed ? 0.9 : 1.0),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular shape
            color: Colors.black.withOpacity(0.2), // Semi-transparent background
            boxShadow: [
              // Outer Glow
              BoxShadow(
                color: widget.neonColor.withOpacity(0.3),
                blurRadius: widget.glowRadius * 2,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.neonColor,
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
