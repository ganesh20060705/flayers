import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flayer/components/custom_dialog_box.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/primary_button.dart';

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
  final String userId = 'testUser123';
  final List<String> roleOptions = ['Batsman', 'Bowler', 'Wicketkeeper', 'All-Rounder'];

  String teamName = 'Team Name';
  String tagline = '';
  String profilePhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        teamName = doc.data()?['teamName'] ?? 'Team Name';
        tagline = doc.data()?['tagline'] ?? '';
        profilePhotoUrl = doc.data()?['profilePhotoUrl'] ?? '';
      });
    }
  }

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
          'isCaptain': snapshot.docs.isEmpty,
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
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: title,
              confirmText: confirmText,
              onConfirm: () {
                onConfirm(nameController.text.trim(), selectedRole ?? 'Batsman');
                Navigator.pop(context);
              },
              fields: [
                const Text('Player Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Player Name',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Player Role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
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
      },
    );
  }

  Future<void> _removePlayer(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Player'),
          content: const Text('Are you sure you want to delete this player?'),
          actions: [
            PrimaryButton(
              label: 'Delete',
              onPressed: () => Navigator.pop(context, true),
              color: Colors.red,
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final playersRef =
          FirebaseFirestore.instance.collection('users').doc(userId).collection('players');
      await playersRef.doc(id).delete();

      final snapshot = await playersRef.orderBy('number').get();
      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < snapshot.docs.length; i++) {
        batch.update(snapshot.docs[i].reference, {'number': i + 1});
      }
      await batch.commit();
    }
  }

  Future<void> _editProfileDialog() async {
    final nameController = TextEditingController(text: teamName);
    final taglineController = TextEditingController(text: tagline);

    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(
          title: 'Edit Profile',
          confirmText: 'Save',
          onConfirm: () async {
            setState(() {
              teamName = nameController.text.trim();
              tagline = taglineController.text.trim();
            });
            await FirebaseFirestore.instance.collection('users').doc(userId).set({
              'teamName': teamName,
              'tagline': tagline,
              'profilePhotoUrl': profilePhotoUrl,
            }, SetOptions(merge: true));
            Navigator.pop(context);
          },
          fields: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.black54),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('Profile photo picker clicked');
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Team Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Team Name',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Tagline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: taglineController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter Tagline',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
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
                  const Text('Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _editProfileDialog,
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Edit Profile',
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
                    CircleAvatar(
                      radius: 66,
                      backgroundColor: Colors.purpleAccent,
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(teamName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

              /// Players list
              StreamBuilder<List<Player>>(
                stream: getPlayersStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    player.role,
                                    style: const TextStyle(fontSize: 14),
                                  ),
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
                                if (!isCaptain)
                                  const Icon(Icons.drag_indicator, size: 24),
                              ],
                            ),
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
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.shade300,
    );
  }
}