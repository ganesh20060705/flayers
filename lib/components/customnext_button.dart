import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final TextStyle? textStyle;
  final Color? color;

  const CustomNextButton({
    super.key,
    required this.onPressed,
    this.label = 'Next',
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ✅ fills parent (394 if parent is 394)
      height: 58, // ✅ matches Figma spec
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFC9FF26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: textStyle ??
              const TextStyle(
                fontFamily: 'Poppins', // ✅ Ensure Poppins is enforced
                fontSize: 20.67,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
