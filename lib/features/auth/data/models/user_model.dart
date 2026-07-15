import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.memberNumber,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      memberNumber: (json['memberNumber'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'],
    );
  }
}
