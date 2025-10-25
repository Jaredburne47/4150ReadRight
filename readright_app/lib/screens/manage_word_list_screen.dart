import 'package:flutter/material.dart';

//Word list management screen for teacher

class ManageWordListScreen extends StatelessWidget {
  const ManageWordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Word List'),
      ),
      body: const Center(
        child: Text(
          'This is where teachers can view and edit the word list.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
