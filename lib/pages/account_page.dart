import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flayer/components/custom_dialog_box.dart'; // ✅ your reusable dialog
import 'package:flayer/components/custom_dropdown_box.dart'; // ✅ your reusable dropdown

class Player {
  String id;
  int number;
  String name;
  String role;
  bool isCaptain;

  Player({
    required this.id,
    required this.number,
    required this.name,
    required this.role,
    required this.isCaptain,
  });

  factory Player.fromMap(String id, Map<String, dynamic> data) {
    return Player(
      id: id,
      number: data['number'] ?? 0,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      isCaptain: data['isCaptain'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'role': role,
      'isCaptain': isCaptain,
    };
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final String userId = 'testUser123'; // Replace with FirebaseAuth
  final List<String> roleOptions = ['Batsman', 'Bowler', 'Wicketkeeper', 'All-Rounder'];
  String tagline = '';

  Stream<List<Player>> getPlayersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('players')
        .orderBy('number')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Player.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> _addPlayerDialog() async {
    _showPlayerDialog(
      title: 'Add New Player',
      confirmText: 'Add',
      initialName: '',
      initialRole: '',
      onConfirm: (name, role) async {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
        final playersRef = userDoc.collection('players');
        final snapshot = await playersRef.get();
        final newNumber = snapshot.docs.length + 1;

        await playersRef.add({
          'number': newNumber,
          'name': name.isEmpty ? 'Player $newNumber' : name,
          'role': role.isEmpty ? 'Batsman' : role,
          'isCaptain': false,
        });
      },
    );
  }

  Future<void> _editPlayerDialog(Player player) async {
    _showPlayerDialog(
      title: 'Edit Player',
      confirmText: 'Save',
      initialName: player.name,
      initialRole: player.role,
      onConfirm: (name, role) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('players')
            .doc(player.id)
            .update({
          'name': name,
          'role': role,
        });
      },
    );
  }

  void _showPlayerDialog({
    required String title,
    required String confirmText,
    required String initialName,
    required String initialRole,
    required Function(String, String) onConfirm,
  }) {
    final nameController = TextEditingController(text: initialName);
    String? selectedRole = initialRole.isEmpty ? null : initialRole;

    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(
          title: title,
          confirmText: confirmText,
          onConfirm: () {
            onConfirm(nameController.text.trim(), selectedRole ?? 'Batsman');
            Navigator.pop(context);
          },
          fields: [
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Player Name',
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            CustomDropdown(
              value: selectedRole,
              hint: 'Select Role',
              items: roleOptions,
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _removePlayer(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('players')
        .doc(id)
        .delete();
  }

  Future<void> _onReorder(List<Player> players, int oldIndex, int newIndex) async {
    if (oldIndex == 0 || newIndex == 0) return;
    if (newIndex > oldIndex) newIndex -= 1;

    final moved = players.removeAt(oldIndex);
    players.insert(newIndex, moved);

    final batch = FirebaseFirestore.instance.batch();
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    for (int i = 0; i < players.length; i++) {
      final docRef = userDoc.collection('players').doc(players[i].id);
      batch.update(docRef, {'number': i + 1});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => _editTaglineDialog(),
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Edit Tagline',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Team logo + tagline
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 132,
                      height: 132,
                      decoration: const BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Team Name',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tagline.isEmpty ? '"Your Team Tagline Here!"' : '"$tagline"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Stats box
              Container(
                width: 414,
                height: 91,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildStatBox('Match Played', '0'),
                    _verticalDivider(),
                    _buildStatBox('Match Won', '0'),
                    _verticalDivider(),
                    _buildStatBox('Match Lost', '0'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Players header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Players',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: _addPlayerDialog,
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      label: const Text(
                        'Add Player',
                        style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              StreamBuilder<List<Player>>(
                stream: getPlayersStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final players = snapshot.data!;
                  return ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) => _onReorder(players, oldIndex, newIndex),
                    children: List.generate(players.length, (index) {
                      final player = players[index];
                      final isCaptain = index == 0;
                      return Container(
                        key: ValueKey(player.id),
                        width: 415,
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isCaptain ? Colors.orange : const Color(0xFF2196F3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${player.number}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(player.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text(player.role, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 24),
                                  onPressed: () => _editPlayerDialog(player),
                                ),
                                if (!isCaptain)
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 24),
                                    onPressed: () => _removePlayer(player.id),
                                  ),
                                if (!isCaptain) const Icon(Icons.drag_indicator, size: 24),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(width: 1, color: Colors.grey.shade300),
    );
  }

  void _editTaglineDialog() {
    final taglineController = TextEditingController(text: tagline);
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(
          title: 'Edit Tagline',
          confirmText: 'Save',
          onConfirm: () {
            setState(() {
              tagline = taglineController.text.trim();
            });
            Navigator.pop(context);
          },
          fields: [
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: taglineController,
                decoration: const InputDecoration(hintText: 'Enter Tagline'),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}
