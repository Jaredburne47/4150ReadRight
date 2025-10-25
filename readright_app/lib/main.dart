import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/student_home.dart';
import 'screens/teacher_dashboard_screen.dart';

//Main

void main() {
  runApp(const ReadingApp());
}

class ReadingApp extends StatelessWidget {
  const ReadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Practice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/studentHome': (context) => const StudentHome(),
        '/teacherDashboard': (context) => const TeacherDashboardScreen(),
      },
    );
  }
}
