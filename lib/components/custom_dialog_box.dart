import 'package:flutter/material.dart';
import 'package:flayer/components/primary_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onConfirm;
  final String confirmText;

  const CustomDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onConfirm,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        constraints: const BoxConstraints(
          // ✅ limit max height so scrolling works properly
          maxHeight: 500,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ Good
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.red, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Dynamic fields
              ...fields,

              const SizedBox(height: 30),

              /// Confirm button
              PrimaryButton(
                label: confirmText,
                onPressed: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
