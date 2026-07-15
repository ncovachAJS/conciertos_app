class User {
  final String id;
  final String name;
  final String email;
  final int memberNumber;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.memberNumber,
    this.avatarUrl,
  });
}
