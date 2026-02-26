// src/state_pulse_selector.dart
import 'package:flutter/material.dart';
import 'state_pulse_provider.dart';

/// {@template state_pulse_selector}
/// A widget that rebuilds only when the selected part of the store changes,
/// similar to `BlocSelector` or `Selector` from Provider.
///
/// `StatePulseSelector` is designed for performance-friendly UI updates.
/// Instead of rebuilding the entire widget tree on every state change,
/// it rebuilds **only when the extracted value (S) changes**.
///
/// This makes it ideal for:
///   • Large widgets
///   • Partial UI updates
///   • Optimized real-time state watching
///
/// The selector compares the previous and new selected value using `!=`.
/// If different → the widget rebuilds.
/// If unchanged → the widget is NOT rebuilt.
///
/// Can also accept an optional local store instance:
///
/// ```dart
/// StatePulseSelector<UserStore, String>(
///   store: customStore,
///   selector: (s) => s.user?.name ?? '',
///   builder: (_, value) => Text(value),
/// );
/// ```
///
/// If `store` is not provided, it automatically pulls from the nearest
/// `StatePulseProvider<T>` in the widget tree.
/// {@endtemplate}
class StatePulseSelector<T extends ChangeNotifier, S> extends StatefulWidget {
  /// Extracts a value of type [S] from the store.
  final S Function(T store) selector;

  /// Builds the widget using the selected value.
  final Widget Function(BuildContext context, S selected) builder;

  /// Optional local override for the store instance.
  /// If not provided, the selector uses the nearest Store from the provider.
  final T? store;

  /// Creates a new [StatePulseSelector].
  const StatePulseSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.store,
  });

  @override
  State<StatePulseSelector<T, S>> createState() =>
      _StatePulseSelectorState<T, S>();
}

class _StatePulseSelectorState<T extends ChangeNotifier, S>
    extends State<StatePulseSelector<T, S>> {
  late T store;
  late S previousValue;
  late Widget cached;

  @override
  void initState() {
    super.initState();

    // Use local store if passed, otherwise use nearest provider.
    store = widget.store ?? StatePulseProvider.of<T>(context, listen: false);

    // Initial selected value + initial built widget.
    previousValue = widget.selector(store);
    cached = widget.builder(context, previousValue);

    // Listen to store state updates.
    store.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    final newValue = widget.selector(store);

    // Only rebuild when selected value changes.
    if (newValue != previousValue) {
      setState(() {
        previousValue = newValue;
        cached = widget.builder(context, newValue);
      });
    }
  }

  @override
  void dispose() {
    store.removeListener(_onStoreChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return cached widget when selection hasn't changed.
    return cached;
  }
}
