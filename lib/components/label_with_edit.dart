import 'package:flutter/material.dart';

class LabelWithEdit extends StatelessWidget {
  final String label;
  final VoidCallback? onEdit;
  final TextStyle? labelStyle; // ✅ new

  const LabelWithEdit({
    super.key,
    required this.label,
    this.onEdit,
    this.labelStyle, // ✅ new
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
        GestureDetector(
          onTap: onEdit ?? () {},
          child: const Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 4),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
