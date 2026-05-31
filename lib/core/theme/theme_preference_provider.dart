import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference {
  system('Sistem ayarı', ThemeMode.system),
  light('Açık tema', ThemeMode.light),
  dark('Koyu tema', ThemeMode.dark);

  const ThemePreference(this.label, this.themeMode);

  final String label;
  final ThemeMode themeMode;

  static ThemePreference fromStorage(String? value) {
    return ThemePreference.values.firstWhere(
      (preference) => preference.name == value,
      orElse: () => ThemePreference.system,
    );
  }
}

class ThemePreferenceNotifier extends Notifier<ThemePreference> {
  static const _storageKey = 'theme_preference';

  @override
  ThemePreference build() {
    unawaited(_loadSavedPreference());
    return ThemePreference.system;
  }

  Future<void> setPreference(ThemePreference preference) async {
    state = preference;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, preference.name);
  }

  Future<void> _loadSavedPreference() async {
    final preferences = await SharedPreferences.getInstance();
    final savedPreference = ThemePreference.fromStorage(
      preferences.getString(_storageKey),
    );

    if (state != savedPreference) {
      state = savedPreference;
    }
  }
}

final themePreferenceProvider =
    NotifierProvider<ThemePreferenceNotifier, ThemePreference>(
  ThemePreferenceNotifier.new,
);
