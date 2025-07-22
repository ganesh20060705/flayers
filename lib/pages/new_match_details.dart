import 'package:flutter/material.dart';

import '../components/bottom_nav_bar.dart';
import '../components/custom_back_actions_app_bar.dart';
import '../components/custom_dropdown_box.dart';
import '../components/customnext_button.dart';
import '../components/label_with_edit.dart';
import 'account_page.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({super.key});

  @override
  State<NewMatchPage> createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  int currentIndex = 0;

  String? selectedOver = '10 Overs';
  String? selectedTeam1;
  String? selectedTeam2;

  final List<String> overs = ['5 Overs', '10 Overs', '15 Overs', '20 Overs', 'Custom'];
  final List<String> teams = ['Team A', 'Team B'];

  final TextEditingController customOverController = TextEditingController();

  @override
  void dispose() {
    customOverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: currentIndex == 0
          ? buildNewMatchDetailsPage()
          : const AccountScreen(),
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

  Widget buildNewMatchDetailsPage() {
    return Stack(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'New Match Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      const Text(
                        'Over per innings',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: CustomDropdown(
                          value: overs.contains(selectedOver) ? selectedOver : 'Custom',
                          items: overs,
                          onChanged: (value) {
                            setState(() {
                              selectedOver = value;
                              if (value != 'Custom') {
                                customOverController.clear();
                              }
                            });
                          },
                        ),
                      ),

                      if (selectedOver == 'Custom') ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: customOverController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter custom overs',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedOver = '$value Overs';
                            });
                          },
                        ),
                      ],

                      const SizedBox(height: 20),

                      LabelWithEdit(
                        label: 'Select Team 1',
                        onEdit: () {
                          Navigator.pushNamed(context, '/team_setup_page');
                        },
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: CustomDropdown(
                          value: selectedTeam1,
                          hint: 'Select Team 1',
                          items: teams,
                          onChanged: (value) {
                            setState(() {
                              selectedTeam1 = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabelWithEdit(
                        label: 'Select Team 2',
                        onEdit: () {
                          Navigator.pushNamed(context, '/team_setup_page2');
                        },
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: CustomDropdown(
                          value: selectedTeam2,
                          hint: 'Select Team 2',
                          items: teams,
                          onChanged: (value) {
                            setState(() {
                              selectedTeam2 = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: CustomNextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/toss_details');
                          },
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.67,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
