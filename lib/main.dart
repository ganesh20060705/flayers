import 'package:flayer/pages/home_page.dart';
import 'package:flayer/pages/new_match_details.dart';
import 'package:flayer/pages/toss_details.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      
      home:TossDetails() ,
    );
  }
}

