// example/example.dart
//
// Basic usage example of the StatePulse package.
// This example shows:
// ✔ Proper initialization (required in 1.0.0)
// ✔ How to provide a store (StatePulseProvider)
// ✔ How to rebuild UI (StatePulseBuilder)
// ✔ Automatic persistence with HydratedStatePulse

import 'package:flutter/material.dart';
import 'package:state_pulse/state_pulse.dart';

Future<void> main() async {
  // Must be called before runApp()
  WidgetsFlutterBinding.ensureInitialized(); // REQUIRED
  await StatePulse.initialize(); // REQUIRED
  runApp(const MyApp());
}

/// Root widget of the example application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StatePulseProvider(
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
                Text(
                  '${store.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
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

/// Example Store using HydratedStatePulse.
/// State automatically persists between app restarts.
class CounterStore extends HydratedStatePulse {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"value": value};
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    value = json["value"] ?? 0;
  }
}
