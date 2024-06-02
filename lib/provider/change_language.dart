// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageNotifier extends StateNotifier<Locale?> {
  ChangeLanguageNotifier() : super(null);

  
  Future<void> changeLanguage(Locale newLang) async {
    state = newLang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', newLang.languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }
  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language') ?? 'ar';
      
      state = Locale(languageCode);
      
    } catch (e) {
      print('Error loading language preference: $e');
    }
  }
}

final currentLanguageProvider =
    StateNotifierProvider<ChangeLanguageNotifier, Locale?>((ref) => ChangeLanguageNotifier());