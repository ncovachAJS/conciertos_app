class Friend {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? friendshipId;
  final String? friendshipStatus; // 'PENDING' | 'ACCEPTED' | 'REJECTED' | null
  final bool? isSender;

  const Friend({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.friendshipId,
    this.friendshipStatus,
    this.isSender,
  });

  bool get isAccepted => friendshipStatus == 'ACCEPTED';
  bool get isPending => friendshipStatus == 'PENDING';
  bool get hasNoRelation => friendshipStatus == null;
}
