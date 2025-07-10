import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/customnext_button.dart';

class PlayersSelection extends StatefulWidget {
  const PlayersSelection({super.key});

  @override
  State<PlayersSelection> createState() => _PlayersSelectionState();
}

class _PlayersSelectionState extends State<PlayersSelection> {
  String? selectedStriker;
  String? selectedNonStriker;
  String? selectedBowler;

  final List<String> batsmen = ['Player A', 'Player B', 'Player C'];
  final List<String> bowlers = ['Player X', 'Player Y', 'Player Z'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: Stack(
        children: [
          /// ✅ Fullscreen background
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background.png',
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
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        const Text(
                          'Batting Team : Team 1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        const Text(
                          'Striker (On Strike)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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

                        const Text(
                          'Bowling Team : Team 2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (int index) {},
      ),
    );
  }
}
