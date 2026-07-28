class ConcertParticipant {
  final String id;
  final String name;
  final String? avatarUrl;

  const ConcertParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ConcertParticipant.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return ConcertParticipant(
      id: user['id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      avatarUrl: user['avatarUrl']?.toString(),
    );
  }
}
