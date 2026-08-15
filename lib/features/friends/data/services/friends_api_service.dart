import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../profile/domain/achievement.dart';
import '../models/friend_model.dart';

class FriendsApiService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<FriendModel>> getFriends() async {
    final response = await http.get(
      Uri.parse(ApiConfig.friendsEndpoint),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => FriendModel.fromJson(e)).toList();
  }

  Future<List<FriendModel>> getPendingRequests() async {
    final response = await http.get(
      Uri.parse(ApiConfig.friendsPendingEndpoint),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => FriendModel.fromPendingRequest(e)).toList();
  }

  Future<List<FriendModel>> searchUsers(String q) async {
    final uri = Uri.parse(
      ApiConfig.friendsSearchEndpoint,
    ).replace(queryParameters: {'q': q});
    final response = await http.get(uri, headers: await _headers());

    debugPrint('🔍 SEARCH status: ${response.statusCode}');
    debugPrint('🔍 SEARCH body: ${response.body}');

    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => FriendModel.fromJson(e)).toList();
  }

  Future<void> sendRequest(String receiverId) async {
    final response = await http.post(
      Uri.parse(ApiConfig.friendRequestEndpoint(receiverId)),
      headers: await _headers(),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> acceptRequest(String friendshipId) async {
    final response = await http.post(
      Uri.parse(ApiConfig.friendAcceptEndpoint(friendshipId)),
      headers: await _headers(),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> removeFriend(String friendshipId) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.friendEndpoint(friendshipId)),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future<void> tagFriend(String concertId, String friendId) async {
    final response = await http.post(
      Uri.parse(ApiConfig.concertTagEndpoint(concertId, friendId)),
      headers: await _headers(),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> untagFriend(String concertId, String friendId) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.concertTagEndpoint(concertId, friendId)),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future<UserStats> getFriendStats(String friendId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.friendStatsEndpoint(friendId)),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    return UserStats.fromJson(jsonDecode(response.body));
  }

  Future<List<Concert>> getFriendUpcomingConcerts(String friendId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.friendUpcomingConcertsEndpoint(friendId)),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => ConcertModel.fromJson(e)).toList();
  }

  Future<List<Concert>> getFriendAllConcerts(String friendId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.friendAllConcertsEndpoint(friendId)),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => ConcertModel.fromJson(e)).toList();
  }
}
