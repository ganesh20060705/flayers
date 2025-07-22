import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll([
      const HomeContent(),
      const Center(child: Text("Account Page")),
    ]);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

// ✅ Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
  children: [
    Image.asset(
      'assets/app_icon.png',
      width: 24,
      height: 24,
    ),
    const SizedBox(width: 8),
    const Text(
      "Flayers",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  ],
),

      actions: [
  Padding(
    padding: const EdgeInsets.only(right: 16),
    child: GestureDetector(
      onTap: () {
        // Optional: handle tap on notification icon
      },
      child: Image.asset(
        'assets/notification.png',
        width: 45,
        height: 45,
      ),
    ),
  ),
],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 1,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

// ✅ HomeContent Widget
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildCard(
            title: "Start a New Match",
            description:
                "Create and score a new cricket match. Share the match code with others so they can follow along.",
            color: const Color(0xFF0096FF),
            buttonText: "Start Match",
            buttonColor: const Color(0xFFD4FF4F),
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          buildCard(
            title: "Join Existing Match",
            description:
                "Enter a match code shared by a scorer to view the live match.",
            color: Colors.orange,
            buttonText: "Join Match",
            buttonColor: Colors.black,
            showTextField: true,
          ),
          const SizedBox(height: 16),
          buildCard(
            title: "Match History",
            description:
                "All Match History and recently played match list in one place",
            color: const Color(0xFF42C2A8),
            buttonText: "View History",
            buttonColor: const Color(0xFF222222),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String description,
    required Color color,
    required String buttonText,
    required Color buttonColor,
    Color textColor = Colors.white,
    bool showTextField = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              )),
          const SizedBox(height: 16),
          if (showTextField)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "ENTER MATCH CODE",
                  border: InputBorder.none,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: Colors.black, width: showTextField ? 1.5 : 0),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: showTextField ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
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
          Icon(icon,
              color: isSelected ? const Color(0xFFD4FF4F) : Colors.white),
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

