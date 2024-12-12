import 'package:flutter/material.dart';

class NeonSlider extends StatefulWidget {
  final double value; // Current value of the slider
  final double height;
  final double padding;
  final Color neonColor;
  final int? segments; // Number of segments
  final ValueChanged<double> onChanged;

  const NeonSlider({
    Key? key,
    required this.value,
    this.height = 20.0,
    this.padding = 4.0,
    this.neonColor = Colors.cyanAccent,
    this.segments,
    required this.onChanged,
  }) : super(key: key);

  @override
  _NeonSliderState createState() => _NeonSliderState();
}

class _NeonSliderState extends State<NeonSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _updateValueFromSegment(int segmentIndex) {
    final double segmentValue = segmentIndex / ((widget.segments ?? 1) - 1);
    setState(() {
      _value = segmentValue;
      widget.onChanged(_value); // Notify parent of the value change
    });
  }

  void _onTapOrDragUpdate(Offset position, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double localX = position.dx;
    final double maxWidth = renderBox.size.width;
    final int totalSegments = widget.segments ?? 1;
    final int clickedSegment = (localX / (maxWidth / totalSegments))
        .floor()
        .clamp(0, totalSegments - 1);

    _updateValueFromSegment(clickedSegment);
  }

  @override
  Widget build(BuildContext context) {
    final int totalSegments = widget.segments ?? 1;

    return GestureDetector(
      onTapDown: (details) => _onTapOrDragUpdate(details.localPosition, context),
      onHorizontalDragUpdate: (details) => _onTapOrDragUpdate(
        details.localPosition,
        context,
      ),
      child: Container(
        height: widget.height,
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          color: Colors.black, // Background track color
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(
            color: widget.neonColor, // Solid neon outline color
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.neonColor.withOpacity(0.5), // Glow color
              blurRadius: 10, // Glow spread
              spreadRadius: 4, // Glow intensity
              offset: Offset(0, 0), // Centered glow
            ),
          ],
        ),
        child: Row(
          children: List.generate(totalSegments, (index) {
            final bool isActive = index <= (_value * (totalSegments - 1)).round();
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: widget.height - widget.padding * 2,
                  decoration: BoxDecoration(
                    color: isActive
                        ? widget.neonColor
                        : widget.neonColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
