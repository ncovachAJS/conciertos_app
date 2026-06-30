import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_search_bar.dart';
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

          SizedBox(height: 28),

          AppSearchBar(),

          SizedBox(height: 36),

          DashboardStats(),

          SizedBox(height: 36),

          UpcomingConcerts(),
        ],
      ),
    );
  }
}
