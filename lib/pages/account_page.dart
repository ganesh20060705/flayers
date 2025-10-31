import 'package:flutter/material.dart';
import 'package:flayer/components/custom_dialog_box.dart';
import 'package:flayer/components/custom_dropdown_box.dart';
import 'package:flayer/components/primary_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

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
  bool isUploading = false;
  bool isLoading = true;
  List<Player> _playersList = [];
  StreamController<List<Player>>? _playersStreamController;
  int _nextPlayerId = 1;

  @override
  void initState() {
    super.initState();
    // Initialize players stream
    getPlayersStream();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    try {
      await _loadProfileData();
    } catch (e) {
      _showErrorSnackBar('Initialization error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadProfilePhoto() async {
    if (isUploading) return;

    try {
      setState(() => isUploading = true);

      // Pick image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      // Validate file
      final file = File(pickedFile.path);
      if (!await file.exists()) {
        throw Exception("Selected file does not exist");
      }

      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception("File too large (max 10MB)");
      }

      if (fileSize == 0) {
        throw Exception("File is empty");
      }

      // Show upload progress
      _showUploadProgress();

      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 1));

      // Store file path locally (in a real app, upload to your database/storage)
      // For now, we'll use the file path directly
      final localPath = pickedFile.path;

      // Save profile data locally
      await _saveProfileLocally(localPath);

      // Update UI
      if (mounted) {
        setState(() {
          profilePhotoUrl = localPath;
        });
        _showSuccessSnackBar('Photo updated successfully!');
      }

    } catch (e) {
      _handleUploadError(e);
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
  }

  Future<void> _saveProfileLocally(String photoPath) async {
    // In a real app, save to your preferred database/storage
    // For now, we just update the local state
    debugPrint('Saving profile: $photoPath, teamName: $teamName, tagline: $tagline');
  }

  void _showUploadProgress() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text('Uploading photo...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'RETRY',
            textColor: Colors.white,
            onPressed: _pickAndUploadProfilePhoto,
          ),
        ),
      );
    }
  }

  void _handleUploadError(dynamic error) {
    String errorMessage = "Unknown error occurred";
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains("network") || errorString.contains("timeout")) {
      errorMessage = "Network error. Check your internet connection.";
    } else if (errorString.contains("permission")) {
      errorMessage = "Permission denied. Check app permissions.";
    } else if (errorString.contains("storage")) {
      errorMessage = "Storage error. Please try again.";
    } else if (errorString.contains("file") || errorString.contains("exists")) {
      errorMessage = "File error. Please try selecting the image again.";
    } else {
      errorMessage = "Upload failed: ${error.toString().split('.').first}";
    }
    
    _showErrorSnackBar(errorMessage);
  }

  Future<void> _loadProfileData() async {  
    try {
      // In a real app, load from your preferred database
      // For now, we'll use default values
      if (mounted) {
        setState(() {
          teamName = 'Team Name';
          tagline = '';
          profilePhotoUrl = '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
  }

  Stream<List<Player>> getPlayersStream() {
    // Return existing stream if available
    if (_playersStreamController != null) {
      return _playersStreamController!.stream;
    }
    
    // Create a stream controller for local state management
    final controller = StreamController<List<Player>>.broadcast();
    
    // Initial players list (empty)
    _playersList = [];
    controller.add(_playersList);
    
    // Store controller reference for updates
    _playersStreamController = controller;
    
    return controller.stream;
  }

  Future<void> _addPlayerDialog() async {
    _showPlayerDialog(
      title: 'Add New Player',
      confirmText: 'Add',
      initialName: '',
      initialRole: '',
      onConfirm: (name, role) async {
        final newNumber = _playersList.length + 1;
        final newPlayer = Player(
          id: 'player_${_nextPlayerId++}',
          number: newNumber,
          name: name.isEmpty ? 'Player $newNumber' : name,
          role: role.isEmpty ? 'Batsman' : role,
          isCaptain: _playersList.isEmpty,
        );
        
        setState(() {
          _playersList.add(newPlayer);
        });
        
        _playersStreamController?.add(_playersList);
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
        final index = _playersList.indexWhere((p) => p.id == player.id);
        if (index != -1) {
          setState(() {
            _playersList[index] = Player(
              id: player.id,
              number: player.number,
              name: name,
              role: role,
              isCaptain: player.isCaptain,
            );
          });
          _playersStreamController?.add(_playersList);
        }
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
                const Text('Player Name', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                const Text('Player Role', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
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
      setState(() {
        _playersList.removeWhere((p) => p.id == id);
        // Reorder remaining players
        for (int i = 0; i < _playersList.length; i++) {
          _playersList[i] = Player(
            id: _playersList[i].id,
            number: i + 1,
            name: _playersList[i].name,
            role: _playersList[i].role,
            isCaptain: i == 0,
          );
        }
      });
      _playersStreamController?.add(_playersList);
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
            final newTeamName = nameController.text.trim();
            final newTagline = taglineController.text.trim();
            
            setState(() {
              teamName = newTeamName.isEmpty ? 'Team Name' : newTeamName;
              tagline = newTagline;
            });
            
            // In a real app, save to your preferred database
            debugPrint('Saving profile: teamName=$teamName, tagline=$tagline');
            
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          fields: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildProfileAvatar(radius: 40, backgroundColor: Colors.grey[300]),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: isUploading ? null : _pickAndUploadProfilePhoto,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUploading ? Colors.grey : Colors.blue,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: isUploading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Team Name', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text('Tagline', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    // Prevent reordering of captain (first player)
    if (oldIndex == 0 || newIndex == 0) return;
    
    if (newIndex > oldIndex) newIndex -= 1;

    setState(() {
      final moved = players.removeAt(oldIndex);
      players.insert(newIndex, moved);
      
      // Update player numbers
      for (int i = 0; i < players.length; i++) {
        players[i] = Player(
          id: players[i].id,
          number: i + 1,
          name: players[i].name,
          role: players[i].role,
          isCaptain: i == 0,
        );
      }
      _playersList = List.from(players);
    });
    
    _playersStreamController?.add(_playersList);
  }

  Widget _buildProfileAvatar({required double radius, Color? backgroundColor}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.purpleAccent,
      child: isUploading
          ? SizedBox(
              width: radius,
              height: radius,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
              : profilePhotoUrl.isNotEmpty
              ? ClipOval(
                  child: Image.file(
                    File(profilePhotoUrl),
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: radius * 2,
                        height: radius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person,
                          size: radius,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.white,
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
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
                  const Text('Account', 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _editProfileDialog,
                    child: const Row(
                      children: [
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

              // Team logo + tagline
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: isUploading ? null : _pickAndUploadProfilePhoto,
                      child: _buildProfileAvatar(radius: 66),
                    ),
                    const SizedBox(height: 8),
                    Text(teamName, 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

              // Stats box
              Container(
                width: double.infinity,
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

              // Players header
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
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Players list
              StreamBuilder<List<Player>>(
                stream: getPlayersStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final players = snapshot.data!;
                  
                  if (players.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No players added yet.\nTap "Add Player" to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) => _onReorder(players, oldIndex, newIndex),
                    children: List.generate(players.length, (index) {
                      final player = players[index];
                      final isCaptain = index == 0;
                      
                      return Container(
                        key: ValueKey(player.id),
                        width: double.infinity,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 24),
                                  onPressed: () => _editPlayerDialog(player),
                                ),
                                if (!isCaptain) ...[
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 24),
                                    onPressed: () => _removePlayer(player.id),
                                  ),
                                  const Icon(Icons.drag_indicator, size: 24),
                                ],
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 65,
      color: Colors.grey.shade300,
    );
  }

  @override
  void dispose() {
    _playersStreamController?.close();
    super.dispose();
  }
}