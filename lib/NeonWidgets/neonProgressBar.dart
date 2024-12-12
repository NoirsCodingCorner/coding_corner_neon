import 'package:flutter/material.dart';

class NeonProgressBar extends StatelessWidget {
  final double progress; // Progress value between 0 and 1
  final double height;
  final double padding;
  final Color neonColor;
  final int? segments; // Number of segments

  const NeonProgressBar({
    Key? key,
    required this.progress,
    this.height = 20.0,
    this.padding = 4.0,
    this.neonColor = Colors.cyanAccent,
    this.segments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth; // Parent's available width

        // Calculate width for each segment if segments are provided
        final double totalSpacing = segments != null ? (segments! - 1) * 4 : 0; // Total spacing between segments
        final double segmentWidth = segments != null ? (maxWidth - totalSpacing) / segments! : 0;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black, // Background track color
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: neonColor, // Solid neon outline color
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: neonColor.withOpacity(0.5), // Glow color
                blurRadius: 10, // Glow spread
                spreadRadius: 4, // Glow intensity
                offset: Offset(0, 0), // Centered glow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: segments == null
                ? AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: progress.clamp(0.0, 1.0) * maxWidth, // Continuous width
              height: height,
              decoration: BoxDecoration(
                color: neonColor, // Solid neon color
                borderRadius: BorderRadius.circular(height / 2),
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(segments!, (index) {
                  // Determine if the segment should be filled based on progress
                  final num segmentProgress = (progress * segments!).clamp(0, segments!);
                  final bool isActive = index < segmentProgress;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: segmentWidth, // Adjusted to avoid overflow
                    height: height,
                    margin: index < segments! - 1
                        ? const EdgeInsets.only(right: 4) // Spacing between segments
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: isActive ? neonColor : neonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
