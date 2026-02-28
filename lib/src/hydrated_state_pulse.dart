// src/hydrated_state_pulse.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'storage.dart';

/// Base class that provides state persistence.
/// Must call `StatePulseStorage.init()` before runApp().
abstract class HydratedStatePulse extends ChangeNotifier {
  HydratedStatePulse() {
    _hydrateSync();
  }

  /// Unique key for storing state
  String get storagePrefix => runtimeType.toString();

  /// Override if you want multiple instances of same store type
  String get id => '';

  /// Final computed storage key
  /// /// DO NOT override storageKey.
  /// Override storagePrefix or id instead.
  String get storageKey => '$storagePrefix$id';

  /// Convert state to JSON
  Map<String, dynamic> toJson();

  /// Restore state from JSON
  void fromJson(Map<String, dynamic> json);

  /// Hydrate synchronously from memory cache
  void _hydrateSync() {
    final raw = StatePulseStorage.read(storageKey);
    if (raw != null) {
      fromJson(jsonDecode(raw));
    }
  }

  /// Persist state (async but fire-and-forget)
  Future<void> _persist() async {
    await StatePulseStorage.write(
      storageKey,
      jsonEncode(toJson()),
    );
  }

  @override
  void notifyListeners() {
    _persist(); // persist first
    super.notifyListeners();
  }

  /// Clear persisted state
  Future<void> clear() async {
    await StatePulseStorage.remove(storageKey);
    fromJson({});
    super.notifyListeners();
  }
}
