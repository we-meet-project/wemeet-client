import 'package:shared_preferences/shared_preferences.dart';

class LocalprofileService {
  LocalprofileService._() {
    print("Localprofile_Service initialize");
  }

  static final LocalprofileService inst = LocalprofileService._();

  late final SharedPreferences _preferences;

  static const String _kUserId = 'user_id';
  static const String _kGroupId = 'user_group_id';
  static const String _kUserEmail = 'user_email';

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUserProfile({
    required String userId,
    required String email,
    required String groupId,
  }) async {
    await Future.wait([
      _preferences.setString(_kUserId, userId),
      _preferences.setString(_kUserEmail, email),
      _preferences.setString(_kGroupId, groupId),
    ]);
  }

  String? getUserGroup() {
    return _preferences.getString(_kGroupId);
  }

  String? getUserId() {
    return _preferences.getString(_kUserId);
  }

  // 로그아웃시 호출
  Future<void> clearOnLogout() async {
    await Future.wait([
      _preferences.remove(_kUserId),
      _preferences.remove(_kUserEmail),
      _preferences.remove(_kGroupId),
    ]);
  }
}
