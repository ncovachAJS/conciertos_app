class User {
  final String id;
  final String name;
  final String email;
  final int memberNumber;
  final String? avatarUrl;
  final bool isPro;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.memberNumber,
    this.avatarUrl,
    this.isPro = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? memberNumber,
    String? avatarUrl,
    bool? isPro,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      memberNumber: memberNumber ?? this.memberNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPro: isPro ?? this.isPro,
    );
  }
}
