import 'package:flutter/material.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';
import 'package:flayer/components/bottom_nav_bar.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/pages/account_page.dart';

class TeamSetupScreen extends StatefulWidget {
  const TeamSetupScreen({super.key});

  @override
  _TeamSetupScreenState createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  int currentIndex = 0;

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
    final List<Widget> pages = [
      buildTeamSetupContent(),
      const AccountScreen(),
    ];

    return Scaffold(
      appBar: const CustomBackActionsAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentIndex == 0)
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
            selectedIndex: currentIndex,
            onItemTapped: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

 Widget buildTeamSetupContent() {
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    color: Colors.white, // 👈 background color here
    child: Column(
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
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onTap: _removePlayer,
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
                SizedBox(height: screenHeight * 0.02),
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
                                // Number box
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
                                // Name box
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
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Role dropdown
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
                                      setState(() {
                                        player.role = newValue!;
                                      });
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
          ),
        ),
      ],
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
