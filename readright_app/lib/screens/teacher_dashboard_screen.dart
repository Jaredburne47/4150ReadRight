import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/accessibility_button.dart';
import 'login_screen.dart';
import 'manage_word_list_screen.dart';
import 'student_progress_screen.dart';

/// Professional dashboard for teachers
class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          const AccessibilityButton(isStudentMode: false),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade700, Colors.indigo.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.school, color: Colors.white, size: 32),
                            SizedBox(width: 12),
                            Text(
                              'ReadRight',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome back! Manage your students and word lists.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Dashboard actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // Action cards grid
                _buildActionCard(
                  context: context,
                  icon: Icons.people,
                  title: 'Student Progress',
                  description: 'View and track student performance',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StudentProgressScreen()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _buildActionCard(
                  context: context,
                  icon: Icons.list_alt,
                  title: 'Manage Word Lists',
                  description: 'Create and edit word lists for students',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ManageWordListScreen()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _buildActionCard(
                  context: context,
                  icon: Icons.analytics,
                  title: 'Analytics',
                  description: 'View detailed reports and insights',
                  color: Colors.purple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Analytics coming soon!')),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Info section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.info_outline, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text(
                              'About ReadRight',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'ReadRight helps students practice reading words aloud with real-time feedback and pronunciation assessment.',
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    // Convert to MaterialColor for proper shading
    final MaterialColor materialColor = _toMaterialColor(color);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: materialColor.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: materialColor.shade700, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  MaterialColor _toMaterialColor(Color color) {
    if (color is MaterialColor) return color;

    final int colorValue = color.value;
    return MaterialColor(colorValue, {
      50: Color.lerp(color, Colors.white, 0.9)!,
      100: Color.lerp(color, Colors.white, 0.8)!,
      200: Color.lerp(color, Colors.white, 0.6)!,
      300: Color.lerp(color, Colors.white, 0.4)!,
      400: Color.lerp(color, Colors.white, 0.2)!,
      500: color,
      600: Color.lerp(color, Colors.black, 0.1)!,
      700: Color.lerp(color, Colors.black, 0.2)!,
      800: Color.lerp(color, Colors.black, 0.3)!,
      900: Color.lerp(color, Colors.black, 0.4)!,
    });
  }
}