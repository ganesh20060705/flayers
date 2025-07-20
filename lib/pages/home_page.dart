import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/pages/account_page.dart';

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
    pages.addAll([const HomeContent(), const AccountScreen()]);
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          Image.asset('assets/images/app_icon.png', width: 24, height: 24),
          const SizedBox(width: 8),
          const Text(
            "Flayers",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/images/notification.png',
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
          child: Container(height: 1, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCard(
            context: context,
            title: "Start a New Match",
            description:
                "Create and score a new cricket match. Share the match code with others so they can follow along.",
            color: const Color(0xFF0096FF),
            buttonText: "Start Match",
            buttonColor: const Color(0xFFE1FF49),
            textColor: Colors.white,
            buttonTextColor: Colors.black,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildCard(
            context: context,
            title: "Join Existing Match",
            description:
                "Enter a match code shared by a scorer to view the live match.",
            color: const Color(0xFFFF6600),
            buttonText: "Join Match",
            buttonColor: Colors.black,
            textColor: Colors.white,
            buttonTextColor: Colors.white,
            showTextField: true,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildCard(
            context: context,
            title: "Match History",
            description:
                "All Match History and recently played match list in one place.",
            color: const Color(0xFF23CE6B),
            buttonText: "View History",
            buttonColor: const Color(0xFF272D2D),
            textColor: Colors.white,
            buttonTextColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required String title,
    required String description,
    required Color color,
    required String buttonText,
    required Color buttonColor,
    Color textColor = Colors.white,
    Color? buttonTextColor,
    bool showTextField = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: textColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
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
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "ENTER MATCH CODE",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          const SizedBox(height: 8),
          CustomNextButton(
            onPressed: () {
              if (buttonText == "Start Match") {
                Navigator.pushNamed(context, '/new_match_details');
              } else {
                // Add your other actions here
              }
            },
            label: buttonText,
            color: buttonColor,
            textStyle: TextStyle(
              fontSize: 14,
              color: buttonTextColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
