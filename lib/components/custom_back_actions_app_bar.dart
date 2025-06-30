import 'package:flutter/material.dart';

class CustomBackActionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const CustomBackActionsAppBar({
    super.key,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: onBack ?? () => Navigator.pop(context),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: onMore ?? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('More tapped!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
            thickness: 2,
            indent: 16,    // <-- indent from left
            endIndent: 16, // <-- indent from right
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
