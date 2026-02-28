<p align="center">
  <img src="https://raw.githubusercontent.com/samar70/state_pulse/c57198b3abdfee1c8bcca163210d130c74422497/assets/statepulse_logo.png" width="72"/>
</p>

<h1 align="center">StatePulse</h1>

<p align="center">
A lightweight, reactive, hydrated state-management library for Flutter — inspired by <b>Provider</b> + <b>Hydrated Bloc</b>, but <i>10× simpler</i>.
</p>

<p align="center">
  <img src="https://img.shields.io/pub/v/state_pulse.svg?color=0288D1" />
  <img src="https://img.shields.io/badge/platform-flutter-blue" />
  <img src="https://img.shields.io/badge/state--management-reactive-4CAF50" />
  <img src="https://img.shields.io/badge/hydrated-yes-2196F3" />
  <img src="https://img.shields.io/badge/null--safety-%E2%9C%85-success" />
</p>

---

## 🚀 Features

- 🌊 **Simple API** — only a few core classes
- 🔥 **Ultra-fast UI updates** (InheritedNotifier + AnimatedBuilder)
- 💾 **Built-in hydration** using `HydratedStatePulse`
- 🎯 **Selectors**, **Listeners**, and **Consumers** (like Bloc/Provider)
- 🧩 Supports **local store instances** (per-widget state)
- ⚡ **Zero boilerplate**
- 🟦 **Zero dependencies** (only `shared_preferences` for persistence)
- 🧠 Designed for **small → large production apps**

---

## 📦 Install

```yaml
dependencies:
  state_pulse: ^1.1.0
```

---

## 🔄 Migration Guide (0.0.8 → 1.0.0)

### Before (0.0.8)

```dart
class CounterStore extends ChangeNotifier with HydratedStatePulse {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  @override
  String get storageKey => 'counter_store';

  @override
  Map<String, dynamic> toJson() => {'value': value};

  @override
  void fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? 0;
  }
}
```

### Now Breaking Change(1.0.0)

1. Required initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // REQUIRED
  await StatePulse.initialize(); // REQUIRED
  runApp(MyApp());
}
```

2. Store inheritance change

```dart
class CounterStore extends HydratedStatePulse {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  @override
  String get storageKey => 'counter_store';

  @override
  Map<String, dynamic> toJson() => {'value': value};

  @override
  void fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? 0;
  }
}
```

---

## 🧩 Quick Start Example

### Create a Store

```dart
  class CounterStore extends HydratedStatePulse {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  @override
  String get storageKey => 'counter_store';

  @override
  Map<String, dynamic> toJson() => {'value': value};

  @override
  void fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? 0;
  }
}
```

### Provide the Store

```dart
   StatePulseProvider(
      store: CounterStore(),
      child: MyApp(),
    );
```

### Use With Builder

```dart
StatePulseBuilder<CounterStore>(
      builder: (_, store) => Text('${store.value}'),
    );
```

### 🎯 Selector Example (High Performance Rebuilds)

Only rebuilds when the selected value changes.

```dart
StatePulseSelector<CounterStore, int>(
      selector: (store) => store.value,
      builder: (_, value) => Text('$value'),
    );
```

### 👂 Listener Example (Side-effects — No UI Rebuild)

```dart
StatePulseListener<CounterStore>(
      listener: (_, store) {
        if (store.value == 10) {
          print("Reached 10!");
        }
      },
      child: SomeWidget(),
    );
```

### 🔀 Consumer Example (Listener + Builder)

```dart
StatePulseConsumer<CounterStore>(
      listener: (_, store) => print("Changed!"),
      builder: (_, store) => Text("${store.value}"),
    );
```

### 🧪 Local Store Instance (Widget-Scoped State)

Each widget has its own isolated store:

```dart
 final localStore = CounterStore();

    return StatePulseBuilder<CounterStore>(
      store: localStore,
      builder: (_, store) => Text("${store.value}"),
    );
```

### 🔧 Advanced Example — Hydrated User Store

```dart
class UserStore extends HydratedStatePulse {
  UserModel? user;
  bool loading = false;

  Future<void> fetchUser() async {
    loading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    user = UserModel(id: "1", name: "Alex", email: "alex@mail.com");
    loading = false;
    notifyListeners();
  }

  @override
  String get storageKey => "user_store";

  @override
  Map<String, dynamic> toJson() => user == null ? {} : {"user": user!.toJson()};

  @override
  void fromJson(Map<String, dynamic> json) {
    if (json["user"] != null) {
      user = UserModel.fromJson(json["user"]);
    }
  }
}
```
