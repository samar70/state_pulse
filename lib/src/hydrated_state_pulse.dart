// src/hydrated_state_pulse.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This mixin provides state persistence for Flutter applications using
/// `ChangeNotifier` and `SharedPreferences`. It allows storing and restoring
/// state from persistent storage, ensuring data is available across app restarts.
///
/// - [storageKey]: The unique key used to store the state in SharedPreferences.
/// - [toJson]: A method that serializes the state into a JSON map.
/// - [fromJson]: A method that deserializes the state from a JSON map.
///
/// This mixin is designed to be used with any class that extends `ChangeNotifier`
/// to provide hydration and persistence features.
mixin HydratedStatePulse on ChangeNotifier {
  bool _hydrated = false;

  String get storageKey;
  Map<String, dynamic> toJson();
  void fromJson(Map<String, dynamic> json);

  Future<void> _hydrate() async {
    if (_hydrated) return;
    _hydrated = true;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw != null) {
      fromJson(jsonDecode(raw));
    }

    super.notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
    fromJson({});
    super.notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    _hydrate();
    super.addListener(listener);
  }

  @override
  void notifyListeners() {
    _persist();
    super.notifyListeners();
  }
}
