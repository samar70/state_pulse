// src/state_pulse_consumer.dart
import 'package:flutter/material.dart';
import 'package:state_pulse/src/state_pulse_provider.dart';

/// A widget that combines both `StatePulseBuilder` and `StatePulseListener`
/// into a single, convenient API.
///
/// This is the StatePulse equivalent of:
/// - `BlocConsumer` (flutter_bloc)
/// - `Consumer + Listener` (provider)
///
/// Use `listener` for side-effects:
/// - Navigation
/// - SnackBars / Toasts
/// - Logging
/// - Analytics
///
/// Use `builder` for UI:
/// - Rebuild only the part of the widget tree that depends on the store.
///
/// ---
/// ## When to Use
/// Use `StatePulseConsumer` when:
/// - You want to rebuild UI *and* handle side effects
/// - You want a single widget to manage both listener + builder
///
/// ---
/// ## Example:
///
/// ```dart
/// StatePulseConsumer<UserStore>(
///   listener: (context, store) {
///     if (store.user != null) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text("Welcome, ${store.user!.name}!")),
///       );
///     }
///   },
///   builder: (context, store) {
///     final user = store.user;
///     return Text(user?.name ?? "No user");
///   },
/// );
/// ```
///
/// ---
/// ## Using a Local Instance
/// ```dart
/// final local = CounterStore();
///
/// StatePulseConsumer<CounterStore>(
///   store: local,
///   listener: (context, s) => print("Updated: ${s.value}"),
///   builder: (_, s) => Text("Value = ${s.value}"),
/// );
/// ```
///
/// ---
/// `T` must extend `ChangeNotifier`.
class StatePulseConsumer<T extends ChangeNotifier> extends StatefulWidget {
  /// Called when the store triggers `notifyListeners()`.
  final void Function(BuildContext context, T store) listener;

  /// Called whenever the UI should rebuild.
  final Widget Function(BuildContext context, T store) builder;

  /// Optional store instance for local-scoped state.
  final T? store;

  const StatePulseConsumer({
    super.key,
    required this.listener,
    required this.builder,
    this.store,
  });

  @override
  State<StatePulseConsumer<T>> createState() => _StatePulseConsumerState<T>();
}

class _StatePulseConsumerState<T extends ChangeNotifier>
    extends State<StatePulseConsumer<T>> {
  late T store;

  @override
  void initState() {
    super.initState();

    // Use local store if provided, otherwise inherit from provider.
    store = widget.store ?? StatePulseProvider.of<T>(context, listen: false);

    // Listen for store updates.
    store.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    // Trigger listener callback.
    widget.listener(context, store);

    // Trigger UI rebuild.
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_onStoreChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, store);
  }
}
