import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late Widget currentPage;

  final List<Widget> pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("Account Page")),
  ];

  @override
  void initState() {
    super.initState();
    currentPage = pages[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) {
          setState(() {
            currentIndex = index;
            currentPage = pages[index];
          });
        },
      ),
    );
  }
}
