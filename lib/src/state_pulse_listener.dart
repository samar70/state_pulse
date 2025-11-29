// src/state_pulse_listener.dart
import 'package:flutter/material.dart';
import 'package:state_pulse/src/state_pulse_provider.dart';

/// A widget that listens to a `ChangeNotifier` store from StatePulse
/// and triggers a callback whenever the store updates.
///
/// This does **not rebuild the UI**, making it ideal for:
/// - Navigation actions
/// - Showing SnackBars / Toasts
/// - Logging state changes
/// - Triggering side-effects
///
/// Works similarly to:
/// - `BlocListener` in flutter_bloc
/// - `ListenableProvider` + `listen: true` in provider
///
/// The listener is invoked *every time* the store calls `notifyListeners()`.
///
/// ---
/// ## Usage Example:
///
/// ```dart
/// StatePulseListener<UserStore>(
///   listener: (context, store) {
///     if (store.user != null) {
///       print("User logged in: ${store.user!.name}");
///     }
///   },
///   child: HomeScreen(),
/// );
/// ```
///
/// ## Local Store Instance (optional)
/// ```dart
/// final localStore = CounterStore();
///
/// StatePulseListener<CounterStore>(
///   store: localStore,
///   listener: (context, store) {
///     print("Local counter: ${store.value}");
///   },
///   child: Text("Using local instance"),
/// );
/// ```
///
/// ---
/// `T` must extend `ChangeNotifier`.
class StatePulseListener<T extends ChangeNotifier> extends StatefulWidget {
  /// Callback executed when the store triggers `notifyListeners()`.
  ///
  /// This function receives:
  /// - `BuildContext context`
  /// - The store instance of type `T`
  final void Function(BuildContext context, T store) listener;

  /// The widget below this listener in the widget tree.
  ///
  /// This widget **does not rebuild** when the store changes.
  final Widget child;

  /// Optionally provide a local store instance.
  ///
  /// If omitted, it automatically uses the store from the nearest
  /// `StatePulseProvider<T>` above in the widget tree.
  final T? store;

  const StatePulseListener({
    super.key,
    required this.listener,
    required this.child,
    this.store,
  });

  @override
  State<StatePulseListener<T>> createState() => _StatePulseListenerState<T>();
}

class _StatePulseListenerState<T extends ChangeNotifier>
    extends State<StatePulseListener<T>> {
  late T store;

  @override
  void initState() {
    super.initState();

    // Use provided local store if available; otherwise retrieve from provider.
    store = widget.store ?? StatePulseProvider.of<T>(context, listen: false);

    // Subscribe to store updates.
    store.addListener(_onStoreChanged);
  }

  /// Called whenever the store triggers `notifyListeners()`.
  void _onStoreChanged() {
    widget.listener(context, store);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks.
    store.removeListener(_onStoreChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No rebuilding required; simply return the child widget.
    return widget.child;
  }
}
