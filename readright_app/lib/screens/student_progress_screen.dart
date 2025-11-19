// lib/screens/student_progress_screen.dart
//
// Allows teachers to select a date range and export attempts as a PDF.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/local_progress_service.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() =>
      _StudentProgressScreenState();
}

class _StudentProgressScreenState
    extends State<StudentProgressScreen> {
  DateTime? _start;
  DateTime? _end;

  final LocalProgressService _progressService =
  LocalProgressService();

  final df = DateFormat('yyyy-MM-dd');

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _start ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _end ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _exportPDF() async {
    if (_start == null || _end == null) return;

    if (_end!.isBefore(_start!)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Invalid Date Range"),
          content: const Text(
              "End date must be the same or after the start date."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    // Ensure full-day coverage
    final adjustedEnd = DateTime(
      _end!.year,
      _end!.month,
      _end!.day,
      23,
      59,
      59,
    );

    final path =
    await _progressService.exportAttemptsPDFToAndroidDownloads(
        _start!, adjustedEnd);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("PDF Export Complete"),
        content: Text(
            "Your PDF report has been saved to:\n\n$path\n\nOpen your device's 'Download' folder to view it."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Start date
            Row(
              children: [
                const Text("Start: "),
                Expanded(
                  child: Text(
                    _start == null
                        ? "Not set"
                        : df.format(_start!),
                  ),
                ),
                ElevatedButton(
                    onPressed: _pickStart,
                    child: const Text("Pick Start")),
              ],
            ),

            const SizedBox(height: 20),

            // End date
            Row(
              children: [
                const Text("End: "),
                Expanded(
                  child: Text(
                    _end == null ? "Not set" : df.format(_end!),
                  ),
                ),
                ElevatedButton(
                    onPressed: _pickEnd,
                    child: const Text("Pick End")),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed:
              (_start != null && _end != null) ? _exportPDF : null,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Export PDF to Downloads"),
            ),
          ],
        ),
      ),
    );
  }
}