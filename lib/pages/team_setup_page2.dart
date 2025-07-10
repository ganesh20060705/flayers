import 'package:flutter/material.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/components/custom_dropdown_box.dart';

class TeamSetupPage2 extends StatefulWidget {
  const TeamSetupPage2({super.key});

  @override
  State<TeamSetupPage2> createState() => _TeamSetupPage2State();
}

class _TeamSetupPage2State extends State<TeamSetupPage2> {
  List<Player> players = [
    Player(1, 'Captain', 'Wicketkeeper', Colors.orange),
    Player(2, 'Player 2', 'Batsman', const Color(0xFF2196F3)),
    Player(3, 'Player 3', 'Bowler', const Color(0xFF2196F3)),
    Player(4, 'Player 4', 'All-rounder', const Color(0xFF2196F3)),
    Player(5, 'Player 5', 'All-rounder', const Color(0xFF2196F3)),
    Player(6, 'Player 6', 'All-rounder', const Color(0xFF2196F3)),
    Player(7, 'Player 7', 'All-rounder', const Color(0xFF2196F3)),
    Player(8, 'Player 8', 'All-rounder', const Color(0xFF2196F3)),
    Player(9, 'Player 9', 'All-rounder', const Color(0xFF2196F3)),
    Player(10, 'Player 10', 'All-rounder', const Color(0xFF2196F3)),
    Player(11, 'Player 11', 'All-rounder', const Color(0xFF2196F3)),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomBackActionsAppBar(),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Team label + Add/Remove buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Team 2',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _addPlayer,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.add, size: 16, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add Players',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _removePlayer,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.remove, size: 16, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    'Remove Players',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Players List
                  Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: player.color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    '${player.number}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: TextField(
                                      controller: TextEditingController(text: player.name),
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                      textAlignVertical: TextAlignVertical.center,
                                      onChanged: (value) {
                                        player.name = value;
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Container(
                                width: 160,
                                height: 40,
                                child: CustomDropdown(
                                  value: player.role,
                                  items: const [
                                    'Wicketkeeper',
                                    'Batsman',
                                    'Bowler',
                                    'All-rounder',
                                  ],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      player.role = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 350,
                child: CustomNextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/players_selection');
                  },
                  label: 'Save and Continue',
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

  void _addPlayer() {
    setState(() {
      int newNumber = players.length + 1;
      players.add(
        Player(newNumber, 'Player $newNumber', 'Batsman', const Color(0xFF2196F3)),
      );
    });
  }

  void _removePlayer() {
    if (players.length > 1) {
      setState(() {
        players.removeLast();
      });
    }
  }
}

class Player {
  int number;
  String name;
  String role;
  Color color;

  Player(this.number, this.name, this.role, this.color);
}
