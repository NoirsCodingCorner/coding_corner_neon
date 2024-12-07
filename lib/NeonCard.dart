import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeonCard extends StatelessWidget {
  final List<Widget> children;
  final Color neonColor;

  const NeonCard({
    Key? key,
    required this.children,
    required this.neonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double blurRadius = 16.0;
    const double borderRadius = 8.0;
    const double borderWidth = 2.0;
    const EdgeInsets padding = EdgeInsets.all(8.0);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: neonColor,
          width: borderWidth,
        ),
        boxShadow: [
          // Outer neon glow
          BoxShadow(
            color: neonColor.withOpacity(0.8),
            blurRadius: blurRadius,
            spreadRadius: 1.0,
            offset: Offset.zero,
          ),
          // Inner dark shadow
          BoxShadow(
            color: Colors.black.withOpacity(1),
            blurRadius: blurRadius,
            spreadRadius: 1.0,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrink to fit children
        children: children,
      ),
    );
  }
}
