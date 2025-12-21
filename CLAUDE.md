# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run the app on specific device
flutter run -d <device_id>

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
flutter build windows      # Windows

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Format code
dart format .
```

## Architecture

This is a Flutter application with a bottom navigation tab layout for the main app structure.

### Overall Structure

The app uses `MyHomePage` (in `main.dart`) as the root container that manages tab state and switches between different screen widgets. Each screen is a complete `Scaffold` with its own `AppBar`, body content, and `BottomNavigationBar`.

### Project Structure

- `lib/main.dart` - App entry point; contains `MyApp`, `MyHomePage`, and `MyHomePageState` which manages tab switching
- `lib/config/routes.dart` - Centralized route definitions (`AppRoutes` class) for named routes
- `lib/pages/home/` - Bottom nav tab screens (HomeScreen, MessageScreen, MineScreen)
  - `lib/pages/home/widgets/` - Reusable widgets for home screens (e.g., `CustomBottomNavBar`)
- `lib/pages/` - Nested pages accessible via named routes (e.g., DataListPage, DetailPage)
- `lib/utils/tools.dart` - Shared utility functions (`showConfirm`, `showToast`, `formatDate`, `isValidEmail`, `debounce`)
- `assets/` - Static assets referenced in `pubspec.yaml`

### Tab Navigation Pattern

The main app uses a tab-based layout managed by `MyHomePageState`:
- `_selectedIndex` tracks the current active tab (0=Home, 1=Messages, 2=Mine)
- `_screens` list contains the three screen widgets
- `onItemTapped(int index)` updates the state and triggers a rebuild with the selected screen

Each screen widget (HomeScreen, MessageScreen, MineScreen) imports `CustomBottomNavBar` and passes its own `currentIndex`. The `CustomBottomNavBar` widget handles the navigation bar UI and calls `MyHomePageState.onItemTapped()` via `context.findAncestorStateOfType<MyHomePageState>()`.

### Named Route Navigation Pattern

Named routes are defined in `AppRoutes` and registered in `MaterialApp.routes`. Navigate using:
```dart
Navigator.pushNamed(context, AppRoutes.dataList);
```

Named routes provide full-screen navigation that appears above the tab structure (e.g., navigating to a detail page). Use named routes for navigating away from the tab layout; use tab index changes for switching between the three main screens.

## Code Style

Linting is configured in `analysis_options.yaml` with these enforced rules:
- `prefer_const_constructors`
- `prefer_final_fields`
- `prefer_final_locals`
- `prefer_single_quotes`
- `require_trailing_commas`
