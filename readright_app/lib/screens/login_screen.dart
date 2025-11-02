import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/enums.dart';
import '../services/auth_service.dart';
import 'student_home.dart';
import 'teacher_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  Future<void> _submit(BuildContext context) async {
    final auth = context.read<AuthService>();
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email and password required.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await auth.login(email: email, password: password, role: _selectedRole);
      } else {
        await auth.signup(email: email, password: password, role: _selectedRole);
      }

      // 👇 Immediately navigate based on role (no refresh needed)
      if (context.mounted) {
        final role = auth.role;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => role == UserRole.teacher
                ? const TeacherDashboardScreen()
                : const StudentHome(),
          ),
              (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Authentication error');
    } catch (e) {
      setState(() => _error = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleItems = [
      DropdownMenuItem(
        value: UserRole.student,
        child: const Text('Student'),
      ),
      DropdownMenuItem(
        value: UserRole.teacher,
        child: const Text('Teacher'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ReadRight Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),

              // Email field
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),

              // Password field
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),

              // Role dropdown
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                items: roleItems,
                onChanged: (role) => setState(() => _selectedRole = role!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : () => _submit(context),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Login' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 12),

              // Toggle between login / signup
              TextButton(
                onPressed: () {
                  setState(() => _isLogin = !_isLogin);
                },
                child: Text(
                  _isLogin
                      ? 'Create a new account'
                      : 'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}