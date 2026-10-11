import 'package:flutter/material.dart';

abstract interface class ThemeService {
  Future<ThemeMode> load();
  Future<void> save(ThemeMode mode);
}
