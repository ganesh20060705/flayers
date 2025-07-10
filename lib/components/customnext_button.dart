import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomNextButton({
    super.key,
    required this.onPressed,
    this.label = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC9FF26), // updated color ✅
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
