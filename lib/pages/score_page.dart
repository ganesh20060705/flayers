import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top bar with "Flayers VS Shadows" and Quit
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title with colored "VS"
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: 'Flayers ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      TextSpan(
                          text: 'VS',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange[700])),
                      const TextSpan(
                          text: ' Shadows',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),

                // Quit button
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Add your own quit logic here
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text("Quit", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Match Code Bar
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(const ClipboardData(text: 'RCTAFU'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match Code Copied')),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Match Code : ",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  Text("RCTAFU",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 5),
                  Icon(Icons.copy, size: 16, color: Colors.black54),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Blue Score Box
                  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue[400]!.withOpacity(0.95),
    borderRadius: BorderRadius.circular(16),
    image: const DecorationImage(
      image: AssetImage('assets/logo.png'),
      fit: BoxFit.contain,
      alignment: Alignment.center,
      opacity: 0.2,
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Runs / Wickets", style: TextStyle(color: Colors.white)),
          Text("Overs", style: TextStyle(color: Colors.white)),
        ],
      ),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("0 / 0",
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          Text("1/10", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 4),
      const Text("CRR : 0.00", style: TextStyle(color: Colors.white)),
      const Divider(color: Colors.white70, thickness: 1),
      const SizedBox(height: 6),
      Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("On Strike", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Player - 1", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("12⁶", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Non Strike", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Player - 2", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("7¹⁰", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Bowler", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Player-10", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("3 (0.1)", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Target", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text("--", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

                  const SizedBox(height: 16),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Ball by Ball Scoring", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(7, (i) {
                      final labels = ["0", "1", "2", "3", "4", "6", "W"];
                      final colors = [
                        Colors.grey[300],
                        Colors.grey[300],
                        Colors.grey[300],
                        Colors.grey[300],
                        Colors.blue,
                        Colors.amber,
                        Colors.red
                      ];
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors[i],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(60, 50),
                        ),
                        child: Text(labels[i], style: const TextStyle(fontSize: 18)),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Extras", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 12),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Last 6 ball", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ["1", "4", "6", "W", "Wd"].map((e) {
                      final color = e == "W"
                          ? Colors.red
                          : e == "Wd"
                              ? Colors.orange
                              : Colors.blue;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        child: Text(e, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sync),
                          label: const Text("Change Bowler"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            minimumSize: const Size(0, 50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text("Switch Strike"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            minimumSize: const Size(0, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
