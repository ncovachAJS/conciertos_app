import 'package:flutter/material.dart';

import '../../data/models/friend_model.dart';
import '../../data/services/friends_api_service.dart';

class FriendsController extends ChangeNotifier {
  static final FriendsController instance = FriendsController._();
  FriendsController._();

  final FriendsApiService _api = FriendsApiService();

  List<FriendModel> friends = [];
  List<FriendModel> pendingRequests = [];
  List<FriendModel> searchResults = [];

  bool loading = false;
  bool searching = false;
  String? error;

  Future<void> loadFriends() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      friends = await _api.getFriends();
      pendingRequests = await _api.getPendingRequests();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> search(String q) async {
    if (q.trim().length < 2) {
      searchResults = [];
      notifyListeners();
      return;
    }
    searching = true;
    notifyListeners();
    try {
      searchResults = await _api.searchUsers(q);
    } catch (_) {
      searchResults = [];
    } finally {
      searching = false;
      notifyListeners();
    }
  }

  Future<void> sendRequest(String receiverId) async {
    await _api.sendRequest(receiverId);
    // Actualizar estado local del resultado de búsqueda
    searchResults = searchResults.map((u) {
      if (u.id == receiverId) {
        return FriendModel(
          id: u.id,
          name: u.name,
          email: u.email,
          avatarUrl: u.avatarUrl,
          friendshipStatus: 'PENDING',
          isSender: true,
        );
      }
      return u;
    }).toList();
    notifyListeners();
  }

  Future<void> acceptRequest(String friendshipId, String senderId) async {
    await _api.acceptRequest(friendshipId);
    // Mover de pendientes a amigos
    final req = pendingRequests.firstWhere(
      (r) => r.friendshipId == friendshipId,
    );
    pendingRequests.removeWhere((r) => r.friendshipId == friendshipId);
    friends.add(
      FriendModel(
        id: req.id,
        name: req.name,
        email: req.email,
        avatarUrl: req.avatarUrl,
        friendshipId: friendshipId,
        friendshipStatus: 'ACCEPTED',
      ),
    );
    notifyListeners();
  }

  Future<void> removeFriend(String friendshipId) async {
    await _api.removeFriend(friendshipId);
    friends.removeWhere((f) => f.friendshipId == friendshipId);
    pendingRequests.removeWhere((r) => r.friendshipId == friendshipId);
    notifyListeners();
  }

  Future<void> tagFriend(String concertId, String friendId) async {
    await _api.tagFriend(concertId, friendId);
  }

  Future<void> untagFriend(String concertId, String friendId) async {
    await _api.untagFriend(concertId, friendId);
  }

  void clearSearch() {
    searchResults = [];
    notifyListeners();
  }
}
