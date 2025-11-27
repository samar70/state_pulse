// src/state_pulse_provider.dart
import 'package:flutter/material.dart';

class StatePulseProvider<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  /// A custom [InheritedNotifier] that provides a [ChangeNotifier] (the store) to
  /// the widget tree. It allows descendant widgets to access and listen to the
  /// store for state changes.
  ///
  /// - [T]: The type of the `ChangeNotifier` store. This is the class that contains
  /// the state that you want to manage. It must extend `ChangeNotifier`.
  /// - [store]: The instance of the `ChangeNotifier` store that holds your app's state.
  /// - [child]: The widget subtree that will have access to the store.
  const StatePulseProvider({super.key, required T store, required super.child})
      : super(notifier: store);

  /// A static method that allows descendant widgets to access the [store]
  /// using [BuildContext]. It searches the widget tree for the nearest
  /// [StatePulseProvider] of the correct type and returns its notifier (the store).
  ///
  /// - Throws an error if no [StatePulseProvider] of type [T] is found in the widget tree.
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<StatePulseProvider<T>>()
        ?.widget as StatePulseProvider<T>?;

    if (provider == null) {
      throw FlutterError("StoreProvider<$T> not found in widget tree");
    }

    return provider.notifier!;
  }
}
