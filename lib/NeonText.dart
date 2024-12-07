import 'package:flutter/material.dart';

class NeonText extends StatefulWidget {
  final String text;
  final double fontSize;
  final TextStyle? textStyle;
  final Color neonColor;
  final double glowRadius;
  final double blurRadius;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool animate; // Whether to animate the glow

  const NeonText({
    Key? key,
    required this.text,
    this.fontSize = 15.0,
    this.textStyle,
    this.neonColor = Colors.cyanAccent,
    this.glowRadius = 20.0,
    this.blurRadius = 10.0,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
    this.animate = false,
  }) : super(key: key);

  @override
  _NeonTextState createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isHovered = false; // For web/desktop hover effect

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..repeat(reverse: true);

      _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _animationController.dispose();
    }
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = widget.textStyle ??
        TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.neonColor,
          shadows: [
            Shadow(
              blurRadius: widget.blurRadius,
              color: widget.neonColor.withOpacity(0.8),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius,
              color: widget.neonColor.withOpacity(0.6),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius * 1.5,
              color: widget.neonColor.withOpacity(0.4),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius * 2,
              color: widget.neonColor.withOpacity(0.2),
              offset: const Offset(0, 0),
            ),
          ],
        );

    Widget textWidget = Text(
      widget.text,
      textAlign: widget.textAlign,
      style: baseStyle,
    );

    if (widget.animate) {
      textWidget = AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: textWidget,
      );
    }

    // Wrap with MouseRegion for hover detection
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: _isHovered
            ? baseStyle.copyWith(
          shadows: [
            Shadow(
              blurRadius: widget.blurRadius + 5,
              color: widget.neonColor.withOpacity(1.0),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius + 10,
              color: widget.neonColor.withOpacity(0.8),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius * 1.5 + 10,
              color: widget.neonColor.withOpacity(0.6),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: widget.glowRadius * 2 + 10,
              color: widget.neonColor.withOpacity(0.4),
              offset: const Offset(0, 0),
            ),
          ],
        )
            : baseStyle,
        child: textWidget,
      ),
    );
  }
}
