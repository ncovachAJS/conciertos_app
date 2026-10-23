import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../data/models/app_notification_model.dart';
import '../../domain/notification_target.dart';
import '../../data/services/notifications_api_service.dart';

class NotificationsController extends ChangeNotifier {
  static final NotificationsController instance = NotificationsController._();
  NotificationsController._();

  final NotificationsApiService _api = NotificationsApiService();

  List<AppNotificationModel> notifications = [];
  int unreadCount = 0;
  bool loading = false;

  // ── Inicializar Firebase Messaging ───────────────────────────────────────

  Future<void> init() async {
    await _requestPermissions();
    await _registerToken();
    _listenForeground();
    _listenTaps();
  }

  Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _registerToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final platform = Platform.isIOS ? 'ios' : 'android';
        await _api.saveToken(token, platform);
      }

      // Refrescar token si cambia
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        final platform = Platform.isIOS ? 'ios' : 'android';
        await _api.saveToken(newToken, platform);
      });
    } catch (_) {}
  }

  bool _tapsListening = false;

  /// Toque en una push con la app en segundo plano o cerrada: si el aviso trae
  /// un `target` (avisos del admin), lleva al usuario a esa pantalla.
  void _listenTaps() {
    if (_tapsListening) return;
    _tapsListening = true;

    FirebaseMessaging.onMessageOpenedApp.listen(_openTarget);

    // Arranque en frío desde una push: esperar a que el router termine de
    // redirigir desde /gate para que la navegación no se pierda.
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) return;
      Future.delayed(const Duration(seconds: 1), () => _openTarget(message));
    }).ignore();
  }

  void _openTarget(RemoteMessage message) {
    NotificationTarget.open(message.data['target']?.toString()).ignore();
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      // Incrementar badge cuando llega notif con la app abierta
      unreadCount++;
      notifyListeners();
      // Recargar la lista
      loadNotifications();
    });
  }

  // ── Cargar notificaciones ────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    loading = true;
    notifyListeners();
    try {
      notifications = await _api.getAll();
      unreadCount = notifications.where((n) => !n.read).length;
    } catch (_) {}
    loading = false;
    notifyListeners();
  }

  Future<void> refreshUnreadCount() async {
    try {
      unreadCount = await _api.getUnreadCount();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markRead(String id) async {
    try {
      await _api.markRead(id);
      notifications = notifications.map((n) {
        if (n.id == id) {
          return AppNotificationModel(
            id: n.id,
            type: n.type,
            title: n.title,
            body: n.body,
            read: true,
            createdAt: n.createdAt,
            data: n.data,
            sender: n.sender,
          );
        }
        return n;
      }).toList();
      unreadCount = notifications.where((n) => !n.read).length;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _api.markAllRead();
      notifications = notifications
          .map(
            (n) => AppNotificationModel(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              read: true,
              createdAt: n.createdAt,
              data: n.data,
              sender: n.sender,
            ),
          )
          .toList();
      unreadCount = 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> deleteOne(String id) async {
    try {
      await _api.deleteOne(id);
      notifications.removeWhere((n) => n.id == id);
      unreadCount = notifications.where((n) => !n.read).length;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> deleteAll() async {
    try {
      await _api.deleteAll();
      notifications = [];
      unreadCount = 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> logout(String? fcmToken) async {
    if (fcmToken != null) {
      try {
        await _api.removeToken(fcmToken);
      } catch (_) {}
    }
    notifications = [];
    unreadCount = 0;
    notifyListeners();
  }
}
