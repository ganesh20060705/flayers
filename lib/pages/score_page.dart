import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
 
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String selectedBowler = "Player-10";
  List<String> allBatsmen = [
  'Player 1', 'Player 2', 'Player 3', 'Player 4', 'Player 5',
  'Player 6', 'Player 7', 'Player 8', 'Player 9', 'Player 10', 'Player 11',
];
int? totalOvers;


@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _showOversDialog());
}


List<String> usedBatsmen = ['Player 1', 'Player 2'];

String striker = 'Player 1';
String nonStriker = 'Player 2';

Map<String, Map<String, int>> batsmanStats = {
  'Player 1': {'runs': 0, 'balls': 0},
  'Player 2': {'runs': 0, 'balls': 0},
};
List<Map<String, dynamic>> actionHistory = [];


  int runs = 0;
  int wickets = 0;
  double overs = 1.0;
  int balls = 0;
  List<String> lastSixBalls = [];
  //  String selectedBowler = "Player-10";
  bool isOnStrike = true; // true = Player 1, false = Player 2

  void _showOversDialog() {
  int selectedOvers = 5; // default

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Total Overs"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<int>(
              value: selectedOvers,
              items: [2, 5, 10, 20, 50].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value Overs"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedOvers = value;
                  });
                }
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                totalOvers = selectedOvers;
              });
            },
            child: const Text("Start Match"),
          ),
        ],
      );
    },
  );
}

  
  // void addRun(int runsToAdd) {
  //   setState(() {
  //     runs += runsToAdd;
  //     balls++;
      
  //     // Add to last six balls
  //     lastSixBalls.add(runsToAdd.toString());
  //     if (lastSixBalls.length > 6) {
  //       lastSixBalls.removeAt(0);
  //     }
      
  //     // Switch strike if odd runs (1, 3, etc.)
  //     if (runsToAdd % 2 == 1) {
  //       isOnStrike = !isOnStrike;
  //     }
      
  //     if (balls == 6) {
  //       overs += 1;
  //       balls = 0;
  //       isOnStrike = !isOnStrike; // Switch strike after over
  //       _showBowlerSelection(); // Show bowler selection dialog
  //     }
  //   });
  // }
  // Add this method below _showBowlerSelection()
void _showExtraRunsDialog(String extraType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Runs with $extraType?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) => index).map((run) {
            return ListTile(
              title: Text('$run run${run != 1 ? 's' : ''}'),
              onTap: () {
                addExtra(extraType, run);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  void addRun(int runsToAdd) {
  if (wickets >= 10) return; // Stop if all out
  if (totalOvers != null && overs >= totalOvers!) {
  // You can disable input or show "Innings Over"
  return;
}
 
  actionHistory.add({
  'runs': runs,
  'balls': balls,
  'overs': overs,
  'wickets': wickets,
  'isOnStrike': isOnStrike,
  'striker': striker,
  'nonStriker': nonStriker,
  'batsmanStats': Map<String, Map<String, int>>.fromEntries(
    batsmanStats.entries.map((e) => MapEntry(e.key, Map<String, int>.from(e.value))),
  ),
  'lastSixBalls': List<String>.from(lastSixBalls),
});

  setState(() {
    runs += runsToAdd;
    balls++;

    // Add to last six balls
    lastSixBalls.add(runsToAdd.toString());
    if (lastSixBalls.length > 6) {
      lastSixBalls.removeAt(0);
    }

    // ✅ Update current striker's stats
    String currentStriker = isOnStrike ? striker : nonStriker;
    batsmanStats.putIfAbsent(currentStriker, () => {'runs': 0, 'balls': 0});
    batsmanStats[currentStriker]!['runs'] =
        (batsmanStats[currentStriker]!['runs'] ?? 0) + runsToAdd;
    batsmanStats[currentStriker]!['balls'] =
        (batsmanStats[currentStriker]!['balls'] ?? 0) + 1;

    // Switch strike if odd runs (1, 3, 5, etc.)
    if (runsToAdd % 2 == 1) {
      isOnStrike = !isOnStrike;
    }

    // Over completed
    if (balls == 6) {
      overs += 1;
      balls = 0;

      isOnStrike = !isOnStrike; // Switch strike after every over
      _showBowlerSelection();   // Custom method to change bowler
    }
  });
}


  
 void addWicket() {
  if (wickets >= 10) return;
  if (totalOvers != null && overs >= totalOvers!) {
  // You can disable input or show "Innings Over"
  return;
}

  String outgoingBatsman = isOnStrike ? striker : nonStriker;

  setState(() {
    wickets++;
    balls++;

    // Add wicket to last six balls
    lastSixBalls.add('W');
    if (lastSixBalls.length > 6) {
      lastSixBalls.removeAt(0);
    }

    usedBatsmen.add(outgoingBatsman); // ✅ Move inside setState

    if (balls == 6) {
      overs += 1;
      balls = 0;
      isOnStrike = !isOnStrike;
      _showBowlerSelection();
    }
  });

  // ✅ Only show dialog if not all out
  if (wickets < 10) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Next Batsman'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: allBatsmen.map((player) {
              bool isDisabled = usedBatsmen.contains(player);
              return ListTile(
                title: Text(
                  player,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.black,
                  ),
                ),
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          if (isOnStrike) {
                            striker = player;
                          } else {
                            nonStriker = player;
                          }
                          batsmanStats[player] = {'runs': 0, 'balls': 0};
                          usedBatsmen.add(player);
                        });
                        Navigator.pop(context);
                      },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}


  void addExtra(String extraType, [int additionalRuns = 0]) {
  setState(() {
    if (extraType == 'Wd' || extraType == 'Nb') {
      runs += 1 + additionalRuns; // extra + run
      if (additionalRuns > 0) {
        lastSixBalls.add("$extraType+$additionalRuns");
      } else {
        lastSixBalls.add(extraType);
      }
      // No ball / wide: do not increment ball
    } else if (extraType == 'B' || extraType == 'Lb') {
      runs += 1 + additionalRuns;
      balls++; // counts as legal delivery
      lastSixBalls.add("$extraType+$additionalRuns");
    }

    if (lastSixBalls.length > 6) {
      lastSixBalls.removeAt(0);
    }

    if (balls == 6) {
      overs += 1;
      balls = 0;
      isOnStrike = !isOnStrike;
      _showBowlerSelection();
    }
  });
}


  // void addExtra(String extraType) {
  //   setState(() {
  //     if (extraType == 'Wd' || extraType == 'Nb') {
  //       runs += 1; // Wide and No-ball add 1 run
  //       // Don't increment balls for wide/no-ball
  //     } else if (extraType == 'B' || extraType == 'Lb') {
  //       runs += 1; // Byes and Leg-byes add 1 run
  //       balls++; // These do count as balls
  //     }
      
  //     // Add to last six balls
  //     lastSixBalls.add(extraType);
  //     if (lastSixBalls.length > 6) {
  //       lastSixBalls.removeAt(0);
  //     }
      
  //     if (balls == 6) {
  //       overs += 1;
  //       balls = 0;
  //       isOnStrike = !isOnStrike; // Switch strike after over
  //       _showBowlerSelection(); // Show bowler selection dialog
  //     }
  //   });
  // }
  
//   void _showBowlerSelection() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Select New Bowler'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('Player-11'),
//               onTap: () {
//                 setState(() {
//                   selectedBowler = "Player-11";
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Player-12'),
//               onTap: () {
//                 setState(() {
//                   selectedBowler = "Player-12";
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Player-13'),
//               onTap: () {
//                 setState(() {
//                   selectedBowler = "Player-13";
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Player-14'),
//               onTap: () {
//                 setState(() {
//                   selectedBowler = "Player-14";
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }

void _showBowlerSelection() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.purple[400]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select New Bowler', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ...['Player-11', 'Player-12', 'Player-13', 'Player-14'].map((player) => 
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() { selectedBowler = player; });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(player, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ).toList(),
            ],
          ),
        ),
      );
    },
  );
}

  
  String get oversDisplay {
    if (balls == 0) {
      return "${overs.toInt()}";
    } else {
      return "${overs.toInt() - 1}.$balls";
    }
  }
  
  double get currentRunRate {
    double totalOvers = overs - 1 + (balls / 6);
    return totalOvers > 0 ? runs / totalOvers : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Status Bar Spacer
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Colors.white,
          ),
          
          // Top Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Flayers ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'VS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      const TextSpan(
                        text: ' Shadows',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  label: const Text(
                    "Quit",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Match Code Bar
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(const ClipboardData(text: 'RCTAFU'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Match Code Copied'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Match Code : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "RCTAFU",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Score Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[600]!,
                          Colors.blue[400]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        opacity: 0.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Score Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Runs / Wickets",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            // Text(
                            //   "Overs",
                            //   style: TextStyle(
                            //     color: Colors.white70,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            Text(
                                "Over: $overs.$balls / ${totalOvers ?? "-"}",
                                style: const TextStyle(
                                 fontWeight: FontWeight.bold,
                                fontSize: 16,     
                                ),
                              ),

                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Main Score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$runs / $wickets",
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              oversDisplay,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Current Run Rate
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "CRR : ${currentRunRate.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white54, thickness: 1),
                        const SizedBox(height: 16),
                        
                        // Player Cards
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isOnStrike ? Colors.white : Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isOnStrike ? Border.all(color: Colors.green, width: 2) : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isOnStrike ? "On Strike" : "Non Strike",
                                      style: TextStyle(
                                        color: isOnStrike ? Colors.green : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: isOnStrike ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        // Text(
                                        //   "Player - 1",
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // Text(
                                        //   "12⁶",
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        Text(
                                            striker,
                                            style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            ),
                                          ),
                                        Text(
                                            "${batsmanStats[striker]?['runs'] ?? 0}⁽${batsmanStats[striker]?['balls'] ?? 0}⁾",
                                            style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                             ),
                                            ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: !isOnStrike ? Colors.white : Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                  border: !isOnStrike ? Border.all(color: Colors.green, width: 2) : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      !isOnStrike ? "On Strike" : "Non Strike",
                                      style: TextStyle(
                                        color: !isOnStrike ? Colors.green : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: !isOnStrike ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        // Text(
                                        //   "Player - 2",
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // Text(
                                        //   "7¹⁰",
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        Text(
                                            nonStriker,
                                            style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            ),
                                          ),
                                        Text(
                                          "${batsmanStats[nonStriker]?['runs'] ?? 0}⁽${batsmanStats[nonStriker]?['balls'] ?? 0}⁾",
                                            style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                           fontSize: 14,
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
                        
                        const SizedBox(height: 16),
                        
                        // Bowler and Target
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Bowler",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedBowler,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
//                                         Text(
//   selectedBowler,  // Use the variable
//   style: TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   ),
// ),

                                        const Text(
                                          "3 (0.1)",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Target",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "--",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
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
                  ),

                  const SizedBox(height: 24),

                  // Ball by Ball Scoring Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ball by Ball Scoring",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     // Undo functionality
                      //   },
                      //   icon: const Icon(Icons.undo, size: 16),
                      //   label: const Text("Undo"),
                      //   style: TextButton.styleFrom(
                      //     foregroundColor: Colors.grey[600],
                      //   ),
                      // ),
                      TextButton.icon(
  onPressed: () {
    if (actionHistory.isNotEmpty) {
      final lastState = actionHistory.removeLast();

      setState(() {
        runs = lastState['runs'];
        balls = lastState['balls'];
        overs = lastState['overs'];
        wickets = lastState['wickets'];
        isOnStrike = lastState['isOnStrike'];
        striker = lastState['striker'];
        nonStriker = lastState['nonStriker'];
        batsmanStats = Map<String, Map<String, int>>.fromEntries(
          (lastState['batsmanStats'] as Map<String, dynamic>).entries.map(
            (e) => MapEntry(e.key, Map<String, int>.from(e.value)),
          ),
        );
        lastSixBalls = List<String>.from(lastState['lastSixBalls']);
      });
    }
  },
  icon: const Icon(Icons.undo, size: 16),
  label: const Text("Undo"),
  style: TextButton.styleFrom(
    foregroundColor: Colors.grey[600],
  ),
),

                    ],
                  ),
                  const SizedBox(height: 16),

                  // Number Buttons (0,1,2,3)
                  Row(
                    children: [
                      for (int i = 0; i <= 3; i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: i == 3 ? 0 : 8,
                            ),
                            child: ElevatedButton(
                              onPressed: () => addRun(i),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(0, 50),
                                elevation: 0,
                              ),
                              child: Text(
                                i.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Special Buttons (4 and 6)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () => addRun(4),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 60),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.sports_cricket,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            onPressed: () => addRun(6),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 60),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.sports_cricket,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "6",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Extras and Wicket
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
  // Show extras dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Extra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Wide (Wd)'),
              onTap: () {
                Navigator.pop(context);
                _showExtraRunsDialog('Wd');
              },
            ),
            ListTile(
              title: const Text('No Ball (Nb)'),
              onTap: () {
                Navigator.pop(context);
                _showExtraRunsDialog('Nb');
              },
            ),
            ListTile(
              title: const Text('Bye (B)'),
              onTap: () {
                Navigator.pop(context);
                _showExtraRunsDialog('B');
              },
            ),
            ListTile(
              title: const Text('Leg Bye (Lb)'),
              onTap: () {
                Navigator.pop(context);
                _showExtraRunsDialog('Lb');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
},

                            // onPressed: () {
                            //   // Show extras dialog
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: const Text('Select Extra'),
                            //         content: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             ListTile(
                            //               title: const Text('Wide (Wd)'),
                            //               onTap: () {
                            //                 addExtra('Wd');
                            //                 Navigator.pop(context);
                            //               },
                            //             ),
                            //             ListTile(
                            //               title: const Text('No Ball (Nb)'),
                            //               onTap: () {
                            //                 addExtra('Nb');
                            //                 Navigator.pop(context);
                            //               },
                            //             ),
                            //             ListTile(
                            //               title: const Text('Bye (B)'),
                            //               onTap: () {
                            //                 addExtra('B');
                            //                 Navigator.pop(context);
                            //               },
                            //             ),
                            //             ListTile(
                            //               title: const Text('Leg Bye (Lb)'),
                            //               onTap: () {
                            //                 addExtra('Lb');
                            //                 Navigator.pop(context);
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () => Navigator.pop(context),
                            //             child: const Text('Cancel'),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 50),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.sports_baseball,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Extras",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            onPressed: addWicket,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 50),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.sports_cricket,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Wicket",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Last 6 Balls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Last 6 balls",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "This Over: ${lastSixBalls.join(' • ')}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: lastSixBalls.isEmpty
                        ? const Center(
                            child: Text(
                              "No balls bowled yet",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: lastSixBalls.map((ball) {
                              Color ballColor = Colors.grey[400]!;
                              if (ball == "1" || ball == "2" || ball == "3") {
                                ballColor = Colors.grey[500]!;
                              } else if (ball == "4") {
                                ballColor = Colors.blue[600]!;
                              } else if (ball == "6") {
                                ballColor = Colors.amber[600]!;
                              } else if (ball == "W") {
                                ballColor = Colors.red[600]!;
                              } else if (ball == "Wd" || ball == "Nb") {
                                ballColor = Colors.orange[600]!;
                              } else if (ball == "B" || ball == "Lb") {
                                ballColor = Colors.purple[600]!;
                              }

                              return Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: ballColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ballColor.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    ball,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Change bowler functionality
                            },
                            icon: const Icon(Icons.sync, size: 18),
                            label: const Text("Change Bowler"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 50),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Switch strike functionality
                              setState(() {
                                isOnStrike = !isOnStrike;
                              });
                            },
                            icon: const Icon(Icons.swap_horiz, size: 18),
                            label: const Text("Switch Strike"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 50),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}