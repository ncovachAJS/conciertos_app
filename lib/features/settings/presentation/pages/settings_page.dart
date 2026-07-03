import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Ajustes',
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.file_download, color: Colors.redAccent),
              title: const Text('Importar festivales'),
              subtitle: const Text('Importar conciertos desde el catálogo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/import');
              },
            ),
          ),
        ],
      ),
    );
  }
}
