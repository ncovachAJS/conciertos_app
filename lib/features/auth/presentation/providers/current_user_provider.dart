import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

/// Id del usuario con sesión iniciada (null si no hay). Los providers que
/// dependen del usuario lo observan para recargarse al iniciar o cambiar de
/// sesión.
class CurrentUserIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    final auth = AuthController.instance;
    void onAuthChanged() {
      final id = auth.user?.id;
      if (id != state) state = id;
    }

    auth.addListener(onAuthChanged);
    ref.onDispose(() => auth.removeListener(onAuthChanged));
    return auth.user?.id;
  }
}

final currentUserIdProvider = NotifierProvider<CurrentUserIdNotifier, String?>(
  CurrentUserIdNotifier.new,
);
