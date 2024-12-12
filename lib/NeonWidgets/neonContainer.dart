import 'package:flutter/material.dart';

class NeonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double glowRadius;
  final Color neonColor;
  final BorderRadius borderRadius;
  final Widget? child;

  const NeonContainer({
    Key? key,
    this.width,
    this.height,
    this.glowRadius = 20.0,
    this.neonColor = Colors.cyanAccent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      width: width, // Optional: If null, Container will size itself based on its parent or child.
      height: height, // Optional: If null, Container will size itself based on its parent or child.
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Background color
        borderRadius: borderRadius,
        boxShadow: [
          // Outer Neon Glow
          BoxShadow(
            color: neonColor.withOpacity(0.4), // Slightly more transparent for subtle effect
            blurRadius: glowRadius ,
            spreadRadius: glowRadius * 0.1, // Slight outward spread
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: neonColor.withOpacity(0.2), // Subtle inner fade
            blurRadius: glowRadius,
            spreadRadius: 0, // Minimal spread to avoid inner glow dominance
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: neonColor.withOpacity(0.7), // Border color for the neon effect
          width: 2,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: child, // Add the child widget here if provided
      ),
    );
  }
}
