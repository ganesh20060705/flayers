import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/label_with_edit.dart';
import 'package:flayer/components/customnext_button.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({super.key});

  @override
  State<NewMatchPage> createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  String? selectedOver = '10 Overs';
  String? selectedTeam1;
  String? selectedTeam2;

  final List<String> overs = ['5 Overs', '10 Overs', '15 Overs', '20 Overs'];
  final List<String> teams = ['Team A', 'Team B'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      kBottomNavigationBarHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: screenHeight * 0.03, // Responsive vertical padding
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'New Match Details',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      const Text(
                        'Over per innings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown(
                        value: selectedOver,
                        items: overs,
                        onChanged: (value) {
                          setState(() {
                            selectedOver = value;
                          });
                        },
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      const LabelWithEdit(label: 'Select Team 1'),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        value: selectedTeam1,
                        hint: 'Select Team 1',
                        items: teams,
                        onChanged: (value) {
                          setState(() {
                            selectedTeam1 = value;
                          });
                        },
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      const LabelWithEdit(label: 'Select Team 2'),
                      const SizedBox(height: 8),
                      CustomDropdown(
                        value: selectedTeam2,
                        hint: 'Select Team 2',
                        items: teams,
                        onChanged: (value) {
                          setState(() {
                            selectedTeam2 = value;
                          });
                        },
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      SizedBox(
                        width: double.infinity,
                        child: CustomNextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/toss_details');
                          },
                        ),
                      ),
                    ],
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
