import 'package:flutter/material.dart';
import 'package:flayer/components/customnext_button.dart';
import 'package:flayer/components/custom_back_actions_app_bar.dart';


class InviteFriendsPage extends StatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  State<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  bool showFriends = false;

  // Example friend list
  final List<String> friends = [
    "Arun Kumar",
    "Sneha Reddy",
    "Vikram Raj",
    "Priya Sharma"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // light bg from figma
      appBar: CustomBackActionsAppBar(
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle Button
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showFriends = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: showFriends ? Colors.transparent : const Color(0xFFC9FF26),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Invite",
                            style: TextStyle(
                              color: showFriends ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showFriends = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: showFriends ? const Color(0xFFC9FF26) : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Friends",
                            style: TextStyle(
                              color: showFriends ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: showFriends ? _friendsList() : _inviteUI(),
            )
          ],
        ),
      ),
    );
  }

  // Invite UI
  Widget _inviteUI() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.group_add, size: 80, color: Color(0xFFC9FF26)),
              const SizedBox(height: 16),
              const Text(
                "Invite your friends!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Share the app with your friends and enjoy together.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Custom button
              CustomNextButton(
                label: "Invite Friends",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Share feature coming soon!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Friends List UI
  Widget _friendsList() {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0096FF),
              child: Text(
                friends[index][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              friends[index],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}
