import 'package:flutter/material.dart';

class Player {
  int number;
  String name;
  String role;
  Color color;

  Player(this.number, this.name, this.role, this.color);
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Player> players = [
    Player(1, 'Captain Name', 'Wicketkeeper', Colors.orange),
    Player(2, 'Player 2', 'Bowler', const Color(0xFF2196F3)),
    Player(3, 'Player 3', 'Batsman', const Color(0xFF2196F3)),
    Player(4, 'Player 4', 'Batsman', const Color(0xFF2196F3)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove explicit backgroundColor to match the second code
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle edit profile tap
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile/Logo section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.purpleAccent,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Players',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '"Driven by Passion, United for Victory!"',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Match Stats
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildStatBox('Match played', '12'),
                    Container(
                        width: 1, height: 60, color: Colors.grey.shade300),
                    _buildStatBox('Match Won', '10'),
                    Container(
                        width: 1, height: 60, color: Colors.grey.shade300),
                    _buildStatBox('Match Lost', '2'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Players header and Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Players',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addPlayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text(
                      'Add player',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Players list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: player.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${player.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                player.role,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: () => _removePlayer(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _addPlayer() {
    setState(() {
      int newNumber = players.length + 1;
      players.add(Player(
        newNumber,
        'Player $newNumber',
        'Batsman',
        const Color(0xFF2196F3),
      ));
    });
  }

  void _removePlayer(int index) {
    setState(() {
      players.removeAt(index);
      // (Optional: If you want to update numbering after remove, uncomment below)
      for (int i = 0; i < players.length; i++) {
        players[i].number = i + 1;
      }
    });
  }
}
