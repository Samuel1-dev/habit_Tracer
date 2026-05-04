import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/firebase/auth.dart';
import 'package:habit_tracker/widget%20/add_habit_sheet.dart';
import 'package:habit_tracker/widget%20/habit_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _habitController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference habitsCollection = FirebaseFirestore.instance
      .collection('habits');

  // ajouter une habitude
  void _addHabitToFirestore() async {
    if (_habitController.text.isNotEmpty) {
      await habitsCollection.add({
        'name': _habitController.text,
        'isDone': false,
        'streak': 0,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _habitController.clear();
      Navigator.pop(context);
    }
  }

  //  cocher/décocher
  void _toggleHabit(String docId, bool currentStatus) {
    habitsCollection.doc(docId).update({'isDone': !currentStatus});
  }

  // supprimer
  void _deleteHabit(String docId) {
    habitsCollection.doc(docId).delete();
  }

  // Afficher
  void _showAddHabit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitSheet(
        controller: _habitController,
        onSave: _addHabitToFirestore,
      ),
    );
  }

  //modifier
  void _updateHabitName(String docId, String newName) async {
    if (newName.isNotEmpty) {
      await habitsCollection.doc(docId).update({'name': newName});

      _habitController.clear();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Habit Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Auth().Logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: _showAddHabit,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: habitsCollection
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Aucune habitude trouvée."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Extraction des données du document
              final data = docs[index].data() as Map<String, dynamic>;
              final String docId = docs[index].id;

              return HabitCard(
                name: data['name'] ?? '',
                isDone: data['isDone'] ?? false,
                streak: data['streak'] ?? 0,
                onCheck: () => _toggleHabit(docId, data['isDone']),
                onDelete: () => _deleteHabit(docId),
                onEdit: () {
                  _habitController.text = data['name'] ?? '';
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddHabitSheet(
                      controller: _habitController,
                      onSave: () =>
                          _updateHabitName(docId, _habitController.text),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
