import 'package:flutter/material.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _QuickAction(
            icon: Icons.add_rounded,
            title: 'Añadir',
            color: Color(0xFFE53935),
          ),
        ),

        SizedBox(width: 14),

        Expanded(
          child: _QuickAction(
            icon: Icons.calendar_month_rounded,
            title: 'Calendario',
            color: Color(0xFF42A5F5),
          ),
        ),

        SizedBox(width: 14),

        Expanded(
          child: _QuickAction(
            icon: Icons.map_rounded,
            title: 'Mapa',
            color: Color(0xFF66BB6A),
          ),
        ),

        SizedBox(width: 14),

        Expanded(
          child: _QuickAction(
            icon: Icons.bar_chart_rounded,
            title: 'Estadísticas',
            color: Color(0xFFFFB300),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
