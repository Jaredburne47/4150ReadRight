import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

// Models & Services
import 'models/enums.dart';
import 'services/auth_service.dart';
import 'services/accessibility_service.dart';

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

  // Accessibility service (default)
  final accessibility = AccessibilityService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: auth),
        ChangeNotifierProvider<AccessibilityService>.value(value: accessibility),
      ],
      child: const ReadRightApp(),
    ),
  );
}

class ReadRightApp extends StatelessWidget {
  const ReadRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final accessibility = context.watch<AccessibilityService>();

    // Show loading spinner during startup
    if (auth.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.orange.shade50,
          body: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
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
      // Set student preset for accessibility
      if (accessibility.textScale == 1.0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          accessibility.setStudentPreset();
        });
      }
      home = const StudentHome();
    }

    // CHILD-FRIENDLY theme for students (bright, playful, tiger mascot prominent)
    final studentTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        primary: Colors.orange.shade600,
        secondary: Colors.amber.shade500,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyLarge: const TextStyle(fontSize: 20, color: Colors.black87),
        bodyMedium: const TextStyle(fontSize: 18, color: Colors.black87),
        labelLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      scaffoldBackgroundColor: Colors.orange.shade50,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: GoogleFonts.quicksand(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
    );

    // PROFESSIONAL theme for teachers (clean, modern, sophisticated)
    final teacherTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        primary: Colors.indigo.shade700,
        secondary: Colors.blue.shade600,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        headlineMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyLarge: const TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

    // Select base theme based on role
    final baseTheme = auth.isLoggedIn && auth.role == UserRole.student
        ? studentTheme
        : teacherTheme;

    // Apply high-contrast variant if requested
    final appliedTheme = accessibility.highContrast
        ? baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              surface: Colors.grey.shade900,
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.black,
            cardTheme: baseTheme.cardTheme.copyWith(
              color: Colors.grey.shade900,
            ),
          )
        : baseTheme;

    return MaterialApp(
      title: 'ReadRight',
      debugShowCheckedModeBanner: false,
      theme: appliedTheme,
      home: Builder(builder: (context) {
        // Apply text scale factor from accessibility service
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accessibility.textScale),
          ),
          child: home,
        );
      }),
    );
  }
}
