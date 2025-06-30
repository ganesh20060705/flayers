import 'package:flutter/material.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';

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
    return Scaffold(
      appBar: const CustomBackActionsAppBar(), // ← If this has custom height, still safe
      body: SafeArea( // ✅ Add SafeArea to respect system padding
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'New Match Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Over per innings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedOver,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: overs
                          .map((over) => DropdownMenuItem(
                                value: over,
                                child: Text(over),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOver = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Team 1',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 4),
                          Text('Edit'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTeam1,
                      hint: const Text('Select team 1'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: teams
                          .map((team) => DropdownMenuItem(
                                value: team,
                                child: Text(team),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTeam1 = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Team 2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 4),
                          Text('Edit'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTeam2,
                      hint: const Text('Select Team 2'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: teams
                          .map((team) => DropdownMenuItem(
                                value: team,
                                child: Text(team),
                              ))
                          .toList(),
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
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCCFF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Next button action
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0, // Or your index
        onItemTapped: (int index) {
          // handle tap
        },
      ),
    );
  }
}
