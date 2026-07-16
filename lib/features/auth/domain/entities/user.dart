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

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? memberNumber,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      memberNumber: memberNumber ?? this.memberNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
