import 'package:flutter/material.dart';

class ConcertCard extends StatelessWidget {
  final String artist;
  final String festival;
  final String date;
  final IconData icon;
  final VoidCallback? onTap;

  const ConcertCard({
    super.key,
    required this.artist,
    required this.festival,
    required this.date,
    this.icon = Icons.music_note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(
          artist,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$festival\n$date"),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
