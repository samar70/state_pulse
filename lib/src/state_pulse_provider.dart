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
  const StatePulseProvider({
    super.key,
    required T store,
    Widget? child,
  }) : super(
          notifier: store,
          child: child ?? const SizedBox(),
        );

  /// A static method that allows descendant widgets to access the [store]
  /// using [BuildContext]. It searches the widget tree for the nearest
  /// [StatePulseProvider] of the correct type and returns its notifier (the store).
  ///
  /// - Throws an error if no [StatePulseProvider] of type [T] is found in the widget tree.
  static T of<T extends ChangeNotifier>(BuildContext context,
      {bool listen = true}) {
    // Attempt to get the provider element from the context.
    final provider = context
        .getElementForInheritedWidgetOfExactType<StatePulseProvider<T>>()
        ?.widget as StatePulseProvider<T>?;

    // If no provider found, throw an error indicating that the store is missing from the widget tree.
    if (provider == null) {
      throw FlutterError(
          "StatePulseProvider<$T> not found in the widget tree. Ensure that the provider is correctly wrapped in the widget tree.");
    }

    // If listen is true, subscribe to the provider to rebuild the widget on changes.
    if (listen) {
      context.dependOnInheritedWidgetOfExactType<StatePulseProvider<T>>();
    }

    // Return the stored notifier (the instance of the provided store).
    return provider.notifier!;
  }

  /// A static method that allows descendant widgets to directly access the store
  /// without relying on a builder.
  ///
  /// - Returns the store (notifier) from the provider.
  /// - Throws an error if no provider of the correct type is found in the widget tree.
  static T value<T extends ChangeNotifier>(BuildContext context) {
    // Attempt to get the provider element from the context.
    final provider = context
        .getElementForInheritedWidgetOfExactType<StatePulseProvider<T>>()
        ?.widget as StatePulseProvider<T>?;

    // If no provider found, throw an error indicating that the store is missing from the widget tree.
    if (provider == null) {
      throw FlutterError(
          "StatePulseProvider<$T> not found in the widget tree. Ensure that the provider is correctly wrapped in the widget tree.");
    }

    // Return the stored notifier (the instance of the provided store).
    return provider.notifier!;
  }

  /// Creates a copy of this [StatePulseProvider] with a new [child].
  ///
  /// This method is primarily used internally by higher-order widgets
  /// such as `MultiStatePulseProvider` to compose multiple providers
  /// without requiring deeply nested widget trees.
  ///
  /// It preserves:
  /// - the original [store] (notifier)
  /// - the [key]
  ///
  /// Only the [child] subtree is replaced.
  ///
  /// ---
  /// Why this exists:
  ///
  /// Similar to how `MultiBlocProvider` works in flutter_bloc,
  /// multiple providers are combined by wrapping them around
  /// a single child widget. Instead of manually nesting providers,
  /// this method allows safe structural cloning while keeping
  /// the same store instance.
  ///
  /// This method is not typically used directly by application developers.
  StatePulseProvider<T> copyWith({required Widget child}) {
    return StatePulseProvider<T>(
      key: key,
      store: notifier!,
      child: child,
    );
  }
}
