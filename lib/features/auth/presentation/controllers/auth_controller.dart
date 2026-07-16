import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/services/auth_api_service.dart';
import '../../domain/entities/user.dart';

class AuthController extends ChangeNotifier {
  AuthController._();

  static final AuthController instance = AuthController._();
  final AuthApiService _api = AuthApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? user;
  bool loading = false;
  String? _token;

  bool get isLogged => user != null;
  String? get token => _token;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    loading = true;
    notifyListeners();
    try {
      final result = await _api.register(
        name: name,
        email: email,
        password: password,
      );
      user = result.$1;
      _token = result.$2;
      await _storage.write(key: 'token', value: _token);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    loading = true;
    notifyListeners();
    try {
      final result = await _api.login(email: email, password: password);
      user = result.$1;
      _token = result.$2;
      await _storage.write(key: 'token', value: _token);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadSession() async {
    final savedToken = await _storage.read(key: 'token');
    if (savedToken == null) return;
    try {
      _token = savedToken;
      user = await _api.me(savedToken);
      if (user == null) {
        await logout();
        return;
      }
      notifyListeners();
    } catch (_) {
      await logout();
    }
  }

  /// Actualiza el avatar en memoria sin necesidad de volver a llamar a la API.
  void updateAvatarUrl(String avatarUrl) {
    if (user == null) return;
    user = user!.copyWith(avatarUrl: avatarUrl);
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _token = null;
    user = null;
    notifyListeners();
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
    _token = null;
    user = null;
    notifyListeners();
  }
}
