import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/customnext_button.dart';

class TossDetails extends StatefulWidget {
  const TossDetails({super.key});

  @override
  State<TossDetails> createState() => _TossDetailsState();
}

class _TossDetailsState extends State<TossDetails> {
  String? selectedTossWinner = 'Team A';
  String? selectedChooseTo = 'Bat';

  final List<String> teams = ['Team A', 'Team B'];
  final List<String> chooseTo = ['Bat', 'Bowl'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        const Center(
                          child: Text(
                            'TOSS DETAILS',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        const Text(
                          'Toss Winner',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomDropdown(
                          value: selectedTossWinner,
                          items: teams,
                          onChanged: (value) {
                            setState(() {
                              selectedTossWinner = value;
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        const Text(
                          'Choose To',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomDropdown(
                          value: selectedChooseTo,
                          hint: 'Select',
                          items: chooseTo,
                          onChanged: (value) {
                            setState(() {
                              selectedChooseTo = value;
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                          width: double.infinity,
                          child: CustomNextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/players_selection');
                            },
                            label: 'Next',
                          ),
                        ),
                        SizedBox(height: screenPadding.bottom + 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (int index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home_page');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/acc_page');
          }
        },
      ),
    );
  }
}
