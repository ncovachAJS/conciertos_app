import 'package:flutter/material.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/upcoming_concerts.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(),
          SizedBox(height: 24),
          DashboardStats(),
          SizedBox(height: 32),
          UpcomingConcerts(),
        ],
      ),
    );
  }
}
