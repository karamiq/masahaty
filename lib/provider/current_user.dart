import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // Import the dart:convert library
import 'package:masahaty/models/user_model.dart';

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null) {
    _loadUserFromPreferences();
  }

  static const String _userKey = 'current_user';

  Future<void> changeUser(User newUser) async {
    state = newUser;
    await _saveUserToPreferences(newUser);
  }

  Future<void> logOutCurrentUser() async {
    state = null;
    await _removeUserFromPreferences();
  }
  
  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));  // Use jsonEncode here
  }

  Future<void> _removeUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      state = User.fromJson(jsonDecode(userJson));  // Use jsonDecode here
    }
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) => CurrentUserNotifier());
