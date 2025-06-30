import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2B2C42), // Dark background
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(
                icon: Icons.home,
                label: "Home",
                isSelected: selectedIndex == 0,
                onTap: () => onItemTapped(0),
              ),
              navItem(
                icon: Icons.account_circle_outlined,
                label: "Account",
                isSelected: selectedIndex == 1,
                onTap: () => onItemTapped(1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // White bar
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFD4FF4F) : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD4FF4F) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
