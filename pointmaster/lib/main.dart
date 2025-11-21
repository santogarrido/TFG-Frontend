import 'package:flutter/material.dart';
//import 'package:pointmaster/screens/login_screen.dart';
import 'package:pointmaster/screens/users/select_club_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SelectClubScreen(),
    );
  }
}