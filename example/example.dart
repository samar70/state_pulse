// example/example.dart
//
// Basic usage example of the StatePulse package.
// This example shows:
// ✔ How to provide a store (StatePulseProvider)
// ✔ How to listen to it (StatePulseBuilder)
// ✔ How to persist state using HydratedStatePulse
// ✔ A minimal Flutter counter app that hydrates automatically

import 'package:flutter/material.dart';
import 'package:state_pulse/state_pulse.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the example application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StatePulseProvider(
      // Provide the CounterStore so the entire app can access it.
      store: CounterStore(),
      child: MaterialApp(
        title: 'StatePulse Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'StatePulse Counter Example'),
      ),
    );
  }
}

/// Simple home page demonstrating StatePulseBuilder.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return StatePulseBuilder<CounterStore>(
      // Builder gives access to the store and rebuilds automatically on changes.
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button this many times:'),
                // Store value updates automatically thanks to StatePulseBuilder.
                Text(
                  '${store.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),

          // Increment button
          floatingActionButton: FloatingActionButton(
            onPressed: store.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

/// Example Store that uses HydratedStatePulse to persist state automatically.
class CounterStore extends ChangeNotifier with HydratedStatePulse {
  int value = 0;

  /// Increments the counter and triggers UI updates.
  void increment() {
    value++;
    notifyListeners();
  }

  /// Unique key for saving this store's data in SharedPreferences.
  @override
  String get storageKey => 'counter_store';

  /// Convert store state to JSON for persistence.
  @override
  Map<String, dynamic> toJson() {
    return {"value": value};
  }

  /// Restore store state from JSON.
  @override
  void fromJson(Map<String, dynamic> json) {
    value = json["value"] ?? 0;
  }
}
