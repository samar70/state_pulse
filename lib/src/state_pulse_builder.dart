// src/state_pulse_builder.dart
import 'package:flutter/material.dart';
import 'package:state_pulse/src/state_pulse_provider.dart';

class StatePulseBuilder<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T store) builder;

  /// A builder widget that listens to a `ChangeNotifier` store and rebuilds
  /// the UI when the state changes. This is part of the StatePulse package.
  ///
  /// - [T]: The type of the `ChangeNotifier` store. This should be a class that
  /// extends `ChangeNotifier` and represents the state you want to manage.
  /// - [builder]: A function that takes the current `BuildContext` and the `store`
  /// (the `ChangeNotifier`) as parameters and returns a widget to be built based
  /// on the current state.
  ///
  /// `StatePulseBuilder` listens to the `ChangeNotifier` store and triggers a
  /// rebuild of its child widget whenever the state changes. It uses `AnimatedBuilder`
  /// to smoothly update the UI.
  const StatePulseBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final store = StatePulseProvider.of<T>(context);

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => builder(context, store),
    );
  }
}
