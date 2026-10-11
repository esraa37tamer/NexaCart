import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this.service) : super(ThemeMode.system);
  final ThemeService service;

  Future<void> load() async => emit(await service.load());

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await service.save(next);
    emit(next);
  }
}
