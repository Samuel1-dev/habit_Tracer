import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth_screen/login_screen.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/firebase/auth.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
