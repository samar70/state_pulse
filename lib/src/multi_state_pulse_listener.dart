// src/multi_state_pulse_listener.dart
import 'package:flutter/widgets.dart';
import 'state_pulse_listener.dart';

class MultiStatePulseListener extends StatelessWidget {
  final List<StatePulseListener> stores;
  final Widget child;

  const MultiStatePulseListener({
    super.key,
    required this.stores,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return stores.reversed.fold<Widget>(
      child,
      (previous, listener) => listener.copyWith(child: previous),
    );
  }
}
