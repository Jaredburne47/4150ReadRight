import 'package:flutter/material.dart';

//Progress screen on Teachers end

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Progress'),
      ),
      body: const Center(
        child: Text(
          'This is where teachers will see student progress charts.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
