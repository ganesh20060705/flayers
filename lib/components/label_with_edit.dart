import 'package:flutter/material.dart';

class LabelWithEdit extends StatelessWidget {
  final String label;
  final VoidCallback? onEdit;

  const LabelWithEdit({
    super.key,
    required this.label,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onEdit ?? () {},
          child: const Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 4),
              Text('Edit'),
            ],
          ),
        ),
      ],
    );
  }
}
