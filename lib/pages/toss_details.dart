import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/label_with_edit.dart';
import 'package:flayer/components/customnext_button.dart';

class TossDetails extends StatefulWidget {
  const TossDetails({super.key});

  @override
  State<TossDetails> createState() => _TossDetailsState();
}

class _TossDetailsState extends State<TossDetails> {
  String? selectedTossWinner = 'Team A';  // ✅ must match teams list
  String? selectedChooseTo = 'Bat';       // ✅ must match choose_to list

  final List<String> teams = ['Team A', 'Team B'];
  final List<String> choose_to = ['Bat', 'Bowl'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: Stack(
        children: [
          // ✅ Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Page content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ✅ Page title
                          const Center(
                            child: Text(
                              'TOSS DETAILS',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // ✅ Toss Winner dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Toss Winner',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                            ],
                          ),

                          // ✅ Choose To dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LabelWithEdit(label: 'Choose To'),
                              const SizedBox(height: 8),
                              CustomDropdown(
                                value: selectedChooseTo,
                                hint: 'Select',
                                items: choose_to,
                                onChanged: (value) {
                                  setState(() {
                                    selectedChooseTo = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          // ✅ Next button
                          CustomNextButton(
                            onPressed: () {
                              // Do something next
                              debugPrint('Next pressed with: Winner=$selectedTossWinner, Choose=$selectedChooseTo');
                            },
                          ),
                        ],
                      ),
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
          // Handle bottom nav tap
        },
      ),
    );
  }
}
