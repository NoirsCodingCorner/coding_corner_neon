import 'package:flutter/material.dart';
import 'package:neon/neon.dart'; // Ensure you have this package in your pubspec.yaml

class NeonTextField extends StatefulWidget {
  final String hintText;
  final Color neonColor;
  final double blurRadius;
  final ValueNotifier<String> textValue;

  const NeonTextField({
    Key? key,
    this.hintText = "Enter text...",
    this.neonColor = Colors.cyan,
    this.blurRadius = 16.0,
    required this.textValue,
  }) : super(key: key);

  @override
  State<NeonTextField> createState() => _NeonTextFieldState();
}

class _NeonTextFieldState extends State<NeonTextField> {
  late final TextEditingController _controller;
  late final VoidCallback _controllerListener;
  late final VoidCallback _valueNotifierListener;
  bool _isUpdating = false; // Flag to prevent circular updates

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current value of the ValueNotifier
    _controller = TextEditingController(text: widget.textValue.value);

    // Listener for the controller to update the ValueNotifier
    _controllerListener = () {
      if (!_isUpdating) {
        _isUpdating = true;
        widget.textValue.value = _controller.text;
        _isUpdating = false;
      }
    };

    // Listener for the ValueNotifier to update the controller
    _valueNotifierListener = () {
      if (!_isUpdating && _controller.text != widget.textValue.value) {
        _isUpdating = true;
        _controller.text = widget.textValue.value;
        // Move cursor to the end after programmatic update
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        _isUpdating = false;
      }
    };

    // Add listeners
    _controller.addListener(_controllerListener);
    widget.textValue.addListener(_valueNotifierListener);
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _controller.removeListener(_controllerListener);
    widget.textValue.removeListener(_valueNotifierListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Neon border effect
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: widget.blurRadius,
                color: widget.neonColor,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: widget.neonColor, // Solid neon color
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: widget.blurRadius,
                  color: Colors.black,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: widget.neonColor, // Neon text color
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    blurRadius: widget.blurRadius,
                    color: widget.neonColor.withOpacity(0.6),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: widget.neonColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: widget.blurRadius,
                      color: widget.neonColor.withOpacity(0.6),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                filled: true,
                fillColor: Colors.transparent, // Transparent background
                border: InputBorder.none, // Remove default Flutter border
              ),
            ),
          ),
        ),
      ],
    );
  }
}
