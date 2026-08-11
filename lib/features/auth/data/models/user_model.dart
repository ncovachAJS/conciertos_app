import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.memberNumber,
    super.avatarUrl,
    super.isPro,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      memberNumber: (json['memberNumber'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl']?.toString(),
      isPro: json['isPro'] as bool? ?? true, // TODO: revert to false when RevenueCat is integrated
    );
  }
}
