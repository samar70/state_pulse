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
