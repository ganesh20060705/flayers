import 'package:flutter/material.dart';
import 'pages/score_page.dart';

void main() {
  runApp(CricketScorer());
}

class CricketScorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Scorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: ScorePage(),
    );
  }
}
