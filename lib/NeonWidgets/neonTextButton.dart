import 'package:flutter/material.dart';

class NeonTextButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final TextStyle? textStyle;
  final Color neonColor;
  final VoidCallback onPressed;
  final double glowRadius;
  final double padding;

  const NeonTextButton({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.textStyle,
    this.neonColor = Colors.cyanAccent,
    required this.onPressed,
    this.glowRadius = 20.0,
    this.padding = 16.0,
  }) : super(key: key);

  @override
  _NeonTextButtonState createState() => _NeonTextButtonState();
}

class _NeonTextButtonState extends State<NeonTextButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // If you want to add pulsating animation, you can initialize an AnimationController here.
  }

  @override
  void dispose() {
    // Dispose of the AnimationController if you add one.
    super.dispose();
  }

  // Handle press down
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
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
        // Apply a scale transformation when pressed
        scale: (_isPressed ? 0.95 : 1.0),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: widget.padding, vertical: widget.padding / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            color: Colors.black.withOpacity(0.2), // Semi-transparent background
            boxShadow: [
              // Outer Glow
              // Inner Glow (optional)
              BoxShadow(
                color: widget.neonColor.withOpacity(0.2),
                blurRadius: widget.glowRadius / 2,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: widget.textStyle ??
                TextStyle(
                  color: widget.neonColor,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: widget.glowRadius / 2,
                      color: widget.neonColor.withOpacity(0.7),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
