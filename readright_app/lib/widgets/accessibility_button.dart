import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_service.dart';

/// Accessibility control with larger fonts and contrast toggle
class AccessibilityButton extends StatelessWidget {
  final bool isStudentMode;

  const AccessibilityButton({super.key, this.isStudentMode = false});

  @override
  Widget build(BuildContext context) {
    final acc = context.watch<AccessibilityService>();

    return PopupMenuButton<int>(
      tooltip: 'Accessibility Options',
      icon: Icon(
        Icons.accessibility_new,
        size: isStudentMode ? 32 : 24,
        color: isStudentMode ? Colors.orange.shade700 : null,
      ),
      onSelected: (value) {
        final svc = context.read<AccessibilityService>();
        if (value == 1) svc.toggleContrast();
        if (value == 2) svc.increaseText();
        if (value == 3) svc.decreaseText();
        if (value == 4) svc.resetTextScale();
      },
      itemBuilder: (ctx) => [
        CheckedPopupMenuItem(
          value: 1,
          checked: acc.highContrast,
          child: Row(
            children: const [
              Icon(Icons.contrast, size: 20),
              SizedBox(width: 12),
              Text('High Contrast', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: const [
              Icon(Icons.text_increase, size: 20),
              SizedBox(width: 12),
              Text('Increase Text Size', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: const [
              Icon(Icons.text_decrease, size: 20),
              SizedBox(width: 12),
              Text('Decrease Text Size', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: [
              const Icon(Icons.refresh, size: 20),
              const SizedBox(width: 12),
              Text(
                'Reset (${acc.textScale.toStringAsFixed(1)}x)',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
