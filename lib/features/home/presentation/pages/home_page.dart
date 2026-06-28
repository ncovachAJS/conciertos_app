import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
import '../views/dashboard_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(title: '🎸 My Concerts', child: DashboardView());
  }
}
