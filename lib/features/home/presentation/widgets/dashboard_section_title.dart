import 'package:flutter/material.dart';

class DashboardSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const DashboardSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE53935), size: 24),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),

        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
