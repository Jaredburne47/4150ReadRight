import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/student_repository.dart';

class ClassManagementScreen extends StatefulWidget {
  final String teacherId;
  final String classId;
  final String className;

  const ClassManagementScreen({
    super.key,
    required this.teacherId,
    required this.classId,
    required this.className,
  });

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final StudentRepository _repo = StudentRepository();
  late Future<List<Student>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = _repo.getStudents(
      teacherId: widget.teacherId,
      classId: widget.classId,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _futureStudents = _repo.getStudents(
        teacherId: widget.teacherId,
        classId: widget.classId,
      );
    });
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final pinController = TextEditingController();
    String selectedAvatar = 'tiger';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Student to ${widget.className}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pinController,
                  decoration: const InputDecoration(
                    labelText: 'PIN (optional, 2–4 digits)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose an avatar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _avatarChip('tiger', '🐯', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                    _avatarChip('fox', '🦊', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                    _avatarChip('bear', '🐻', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                    _avatarChip('panda', '🐼', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                    _avatarChip('bunny', '🐰', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                    _avatarChip('frog', '🐸', selectedAvatar, (v) {
                      setState(() => selectedAvatar = v);
                    }),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                await _repo.addStudent(
                  teacherId: widget.teacherId,
                  classId: widget.classId,
                  name: name,
                  avatar: selectedAvatar,
                  pin: pinController.text.trim()
                );
                if (!mounted) return;
                Navigator.pop(context);
                _refresh();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showImportDialog() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import Class List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paste one student name per line, or paste a simple list.\n'
                    'Example:\nAlice\nBobby\nChloe\nDaniel',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Alice\nBobby\nChloe\nDaniel',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final raw = textController.text;
                final names = raw.split(RegExp(r'\r?\n'));
                await _repo.importStudents(
                  teacherId: widget.teacherId,
                  classId: widget.classId,
                  names: names,
                );
                if (!mounted) return;
                Navigator.pop(context);
                _refresh();
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  Widget _avatarChip(
      String value,
      String emoji,
      String selected,
      void Function(String) onSelected,
      ) {
    final bool isSelected = value == selected;
    return ChoiceChip(
      label: Text(emoji),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.className}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top buttons: Add + Import
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAddStudentDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Student'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showImportDialog,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Import List'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: _futureStudents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading students.\nShowing any cached data.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final students = snapshot.data ?? [];
                  if (students.isEmpty) {
                    return Center(
                      child: Text(
                        'No students yet.\nUse "Add Student" or "Import List".',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final s = students[index];
                      return _buildStudentTile(s);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTile(Student s) {
    final emoji = _emojiForAvatar(s.avatar);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Later: go to student's progress, or select for "I’m a student" mode
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 8),
              Text(
                s.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (s.pin!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'PIN: ${s.pin}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _emojiForAvatar(String avatar) {
    switch (avatar) {
      case 'tiger':
        return '🐯';
      case 'fox':
        return '🦊';
      case 'bear':
        return '🐻';
      case 'panda':
        return '🐼';
      case 'bunny':
        return '🐰';
      case 'frog':
        return '🐸';
      case 'lion':
        return '🦁';
      case 'cat':
        return '🐱';
      case 'dog':
        return '🐶';
      default:
        return '🙂';
    }
  }
}