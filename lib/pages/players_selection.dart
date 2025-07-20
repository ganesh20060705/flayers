import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/pages/account_page.dart';

class PlayersSelection extends StatefulWidget {
  const PlayersSelection({super.key});

  @override
  State<PlayersSelection> createState() => _PlayersSelectionState();
}

class _PlayersSelectionState extends State<PlayersSelection> {
  int currentIndex = 0;

  String? selectedStriker;
  String? selectedNonStriker;
  String? selectedBowler;

  final List<String> batsmen = ['Player A', 'Player B', 'Player C'];
  final List<String> bowlers = ['Player X', 'Player Y', 'Player Z'];

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [buildPlayerSelectionContent(), const AccountScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget buildPlayerSelectionContent() {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: screenHeight * 0.02,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      kBottomNavigationBarHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      const Center(
                        child: Text(
                          'Select Players',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: const [
                          Text(
                            'Batting Team : ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Team 1',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Striker (On Strike)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown(
                        value: selectedStriker,
                        hint: 'Select Batsman',
                        items: batsmen,
                        onChanged: (value) {
                          setState(() {
                            selectedStriker = value;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Non-Striker',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown(
                        value: selectedNonStriker,
                        hint: 'Select Batsman',
                        items: batsmen,
                        onChanged: (value) {
                          setState(() {
                            selectedNonStriker = value;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: const [
                          Text(
                            'Bowling Team : ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Team 2',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown(
                        value: selectedBowler,
                        hint: 'Select Bowler',
                        items: bowlers,
                        onChanged: (value) {
                          setState(() {
                            selectedBowler = value;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: CustomNextButton(
                          onPressed: () {
                            // handle start match action
                          },
                          label: 'Start Match',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
