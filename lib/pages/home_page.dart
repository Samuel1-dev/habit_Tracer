import 'package:flutter/material.dart';
import 'package:habit_tracker/services/firebase/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Auth().Logout();
          },
          child: const Text("Se déconnecter"),
        ),
      ),
    );
  }
}
