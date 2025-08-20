import 'package:firebase_core/firebase_core.dart';
import 'package:flayer/pages/account_page.dart';
import 'package:flayer/pages/home_page.dart';
import 'package:flayer/pages/score_page.dart';
import 'package:flayer/pages/new_match_details.dart';
import 'package:flayer/pages/players_selection.dart';
import 'package:flayer/pages/team_setup_page2.dart';
import 'package:flutter/material.dart';
import 'package:flayer/pages/team_setup_page.dart';
import 'package:flayer/pages/toss_details.dart';
import 'package:flayer/pages/invite_friends.dart';
import 'package:flayer/pages/login_signup.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flayers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomePage(); // ✅ user logged in
          } else {
            return const AuthPage(); // ✅ user not logged in
          }
        },
      ),
      routes: {
        '/home_page': (context) => HomePage(),
        '/new_match_details': (context) => const NewMatchPage(),
        '/players_selection': (context) => const PlayersSelection(),
        '/team_setup_page': (context) => TeamSetupScreen(),
        '/team_setup_page2': (context) => TeamSetupPage2(),
        '/toss_details': (context) => TossDetails(),
        '/acc_page': (context) => AccountScreen(),
        '/score_page': (context) => ScorePage(),
      },
    );
  }
}
