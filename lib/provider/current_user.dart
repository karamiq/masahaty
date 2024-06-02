import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masahaty/models/user.dart';

class CurrentUserNotifier extends StateNotifier<UserInfo?> {
  CurrentUserNotifier() : super(null) {
    _loadUserFromPreferences();
  }

  static const String _userKey = 'current_user';

  Future<void> changeUser(UserInfo newUser) async {
    state = newUser;
    await _saveUserToPreferences(newUser);
  }

  Future<void> logOutCurrentUser() async {
    state = null;
    await _removeUserFromPreferences();
  }
  
  Future<void> _saveUserToPreferences(UserInfo user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJson());
  }

  Future<void> _removeUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      state = UserInfo.fromJson(userJson);
    }
  }
}
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserInfo?>((ref) => CurrentUserNotifier());
