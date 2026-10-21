import 'package:conciertos_app/core/utils/user_prefs.dart';
import 'package:conciertos_app/features/auth/domain/entities/user.dart';
import 'package:conciertos_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

User _user(String id) =>
    User(id: id, name: 'n', email: '$id@t.com', memberNumber: 1);

void main() {
  tearDown(() => AuthController.instance.user = null);

  test('la clave depende del usuario con sesión', () {
    AuthController.instance.user = _user('a');
    final keyA = UserPrefs.key('quick_actions_v1');
    AuthController.instance.user = _user('b');
    expect(UserPrefs.key('quick_actions_v1'), isNot(keyA));
    AuthController.instance.user = null;
    expect(UserPrefs.key('quick_actions_v1'), endsWith('_uguest'));
  });

  test('el primer usuario reclama la clave global y el segundo no la hereda',
      () async {
    SharedPreferences.setMockInitialValues({'quick_actions_v1': '["add"]'});
    final prefs = await SharedPreferences.getInstance();

    AuthController.instance.user = _user('a');
    await UserPrefs.claimLegacy(prefs, 'quick_actions_v1');
    expect(prefs.getString(UserPrefs.key('quick_actions_v1')), '["add"]');
    expect(prefs.containsKey('quick_actions_v1'), isFalse);

    AuthController.instance.user = _user('b');
    await UserPrefs.claimLegacy(prefs, 'quick_actions_v1');
    expect(prefs.getString(UserPrefs.key('quick_actions_v1')), isNull);
  });

  test('sin sesión no se reclama la clave global', () async {
    SharedPreferences.setMockInitialValues({'theme': 'dark'});
    final prefs = await SharedPreferences.getInstance();
    await UserPrefs.claimLegacy(prefs, 'theme');
    expect(prefs.getString('theme'), 'dark');
  });
}
