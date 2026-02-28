## 1.1.1

- Removed `storageKey` override from basic examples

- Simplified beginner setup (no need to override storage key manually)

- Updated example project to reflect new best practices

## 1.1.0

- Added `MultiStatePulseProvider` for providing multiple stores at once.

- Added `MultiStatePulseListener` for listening to multiple stores in a single widget.

- Introduced multi-instance persistence support via `id` override.

- Added `storagePrefix` override for customizable and obfuscation-safe storage namespaces.

## 1.0.0

- Fixed extra rebuild occurring on initial app launch.

- `HydratedStatePulse` converted from mixin to abstract class.

- `WidgetsFlutterBinding.ensureInitialized()` and `StatePulse.initialize()` are now required before `runApp()`.

- Internal imports refactored to use proper local file references instead of package: paths.

- Bumped `shared_preferences` dependency to `2.5.4`.

## 0.0.8

- Cleaned up documentation for better maintainability.

## 0.0.7

- Refactor code.

## 0.0.6

- Refactored README for better clarity and better examples.
- Improved internal consistency in documentation comments.

## 0.0.5

- Added `StatePulseSelector` (fine-grained rebuilds)
- Added `StatePulseListener` for side-effects
- Added `StatePulseConsumer` (builder + listener)
- Added local instance support in all widgets
- Added official StatePulse logo + asset support
- Improved documentation and examples
- Minor optimizations & internal clean-ups

## 0.0.4

- Added: `StatePulseProvider.value` method for directly accessing the store without rebuilding.

- Added: Local instance support for `StatePulseBuilder`, enabling easy usage with non-global instances of ChangeNotifier store.

- Improved: `StatePulseBuilder` now accepts an optional local store instance, allowing greater flexibility in state management.

- Fix: Improved error handling for cases where the store is not found in the widget tree.

- Updated: `StatePulseProvider` to allow non-listening access to the store (listen: false option).

## 0.0.3

- Applied `dart format` to fix pub.dev analyzer formatting warning.

## 0.0.2

- Added main public API entry file (`state_pulse.dart`).
- Moved internal implementation to `lib/src/` following Flutter conventions.
- Added complete Flutter example under `/example`.
- Updated README, documentation comments, and metadata.
- Fixed pub.dev warnings for missing example and incorrect exports.
- Cleaned project structure for long-term maintainability.

## 0.0.1

- Initial release of StatePulse.
- Added:
  - `StatePulseProvider` for dependency injection.
  - `StatePulseBuilder` for reactive widget rebuilding.
  - `HydratedStatePulse` mixin for automatic persistence.
- First prototype of reactive + hydrated state management.
