// src/multi_state_pulse_provider.dart
import 'package:flutter/widgets.dart';
import 'state_pulse_provider.dart';

class MultiStatePulseProvider extends StatelessWidget {
  final List<Widget> stores;
  final Widget child;

  const MultiStatePulseProvider({
    super.key,
    required this.stores,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return stores.reversed.fold<Widget>(
      child,
      (previous, provider) {
        if (provider is StatePulseProvider) {
          return provider.copyWith(child: previous);
        }
        return provider;
      },
    );
  }
}
