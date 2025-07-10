import 'package:flutter/material.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/components/custom_dropdown_box.dart';

class TeamSetupScreen extends StatefulWidget {
  @override
  _TeamSetupScreenState createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  List<Player> players = [
    Player(1, 'Captain', 'Wicketkeeper', Colors.orange),
    Player(2, 'Player 2', 'Batsman', Color(0xFF2196F3)),
    Player(3, 'Player 3', 'Bowler', Color(0xFF2196F3)),
    Player(4, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(5, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(6, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(7, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(8, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(9, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(10, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
    Player(11, 'Player 4', 'All-rounder', Color(0xFF2196F3)),
  ];

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Team 1 (left) & Add/Remove buttons (right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Team 1',
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

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
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
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
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
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
      width: 350, // 🎯 Your desired width
      child: CustomNextButton(
        onPressed: () {
          // handle save action
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
