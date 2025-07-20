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
            child: TeamSetupSection(
              teamName: 'Team 2',
              players: players,
              onAdd: _addPlayer,
              onRemove: _removePlayer,
              onPlayerUpdate: () => setState(() {}),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            child: SizedBox(
              width: 350,
              child: CustomNextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/new_match_details');
                },
                label: 'Save and Continue',
              ),
            ),
          ),
          CustomBottomNavBar(
            selectedIndex: 0,
            onItemTapped: (int index) {},
          ),
        ],
      ),
    );
  }
}

class TeamSetupSection extends StatelessWidget {
  final String teamName;
  final List<Player> players;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onPlayerUpdate;

  const TeamSetupSection({
    super.key,
    required this.teamName,
    required this.players,
    required this.onAdd,
    required this.onRemove,
    required this.onPlayerUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Name + Add/Remove
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                teamName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: 110,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 18, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'Add Players',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 138,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.remove, size: 18, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'Remove Players',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: players.map((player) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Player Number
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: player.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${player.number}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Player Name Input
                          Container(
                            width: 214,
                            height: 38,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: TextEditingController(text: player.name),
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                                onChanged: (value) {
                                  player.name = value;
                                  onPlayerUpdate();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Player Role Dropdown
                          SizedBox(
                            width: 180,
                            height: 38,
                            child: CustomDropdown(
                              value: player.role,
                              items: const [
                                'Wicketkeeper',
                                'Batsman',
                                'Bowler',
                                'All-rounder',
                              ],
                              onChanged: (String? newValue) {
                                player.role = newValue!;
                                onPlayerUpdate();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Player {
  int number;
  String name;
  String role;
  Color color;

  Player(this.number, this.name, this.role, this.color);
}
