import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Models & Services
import 'models/enums.dart';
import 'services/auth_service.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/student_home.dart';
import 'screens/teacher_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize AuthService (restores session & role)
  final auth = AuthService();
  await auth.init();

  runApp(
    ChangeNotifierProvider<AuthService>.value(
      value: auth,
      child: const ReadRightApp(),
    ),
  );
}

class ReadRightApp extends StatelessWidget {
  const ReadRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    // Show loading spinner during startup
    if (auth.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Choose home screen based on login + role
    Widget home;
    if (!auth.isLoggedIn) {
      home = const LoginScreen();
    } else if (auth.role == UserRole.teacher) {
      home = const TeacherDashboardScreen();
    } else {
      home = const StudentHome();
    }

    return MaterialApp(
      title: 'ReadRight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
