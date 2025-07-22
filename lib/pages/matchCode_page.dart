import 'package:flutter/material.dart';

class MatchCodePage extends StatefulWidget {
  const MatchCodePage({Key? key}) : super(key: key);

  @override
  State<MatchCodePage> createState() => _MatchCodePageState();
}

class _MatchCodePageState extends State<MatchCodePage> {
  int selectedIndex = 0; // 0 for Home, 1 for Account

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top header with quit button
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B6B), // Coral red color
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle quit action
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Quit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation tabs
          Container(
            width: double.infinity,
            color: const Color(0xFF3A3D56), // Dark blue-gray color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Home tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: selectedIndex == 0 ? Colors.white : Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: selectedIndex == 0 ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: selectedIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Active indicator
                        Container(
                          height: 3,
                          width: 40,
                          decoration: BoxDecoration(
                            color: selectedIndex == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Account tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: selectedIndex == 1 ? Colors.white : Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Account',
                          style: TextStyle(
                            color: selectedIndex == 1 ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: selectedIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Active indicator
                        Container(
                          height: 3,
                          width: 40,
                          decoration: BoxDecoration(
                            color: selectedIndex == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[50],
              child: selectedIndex == 0 ? _buildHomeContent() : _buildAccountContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Content',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A3D56),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to the Match Code page! This is the home section.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountContent() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A3D56),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Manage your account settings and preferences here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}