import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_service.dart';

class ThemeServiceImpl implements ThemeService {
  ThemeServiceImpl(this.preferences);
  final SharedPreferencesAsync preferences;
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> load() async {
    final value = await preferences.getString(_key);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> save(ThemeMode mode) => preferences.setString(_key, mode.name);
}
