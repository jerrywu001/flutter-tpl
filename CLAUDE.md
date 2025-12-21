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
- `lib/pages/` - Nested pages accessible via named routes (DetailPage, EditPasswordPage)
- `lib/widgets/` - Reusable widgets (`BottomNav`, `SvgIcon`)
- `lib/utils/tools.dart` - Shared utility functions (`showConfirm`, `showToast`, `formatDate`, `isValidEmail`, `debounce`)
- `assets/` - Static assets referenced in `pubspec.yaml`

### Tab Navigation Pattern

The main app uses a tab-based layout managed by `MyHomePageState`:
- `_selectedIndex` tracks the current active tab (0=Home, 1=Messages, 2=Mine)
- `_screens` list contains the three screen widgets
- `onItemTapped(int index)` updates the state and triggers a rebuild with the selected screen

Each screen widget (HomeScreen, MessageScreen, MineScreen) imports `BottomNav` and passes its own `currentIndex`. The `BottomNav` widget handles the navigation bar UI and calls `MyHomePageState.onItemTapped()` via `context.findAncestorStateOfType<MyHomePageState>()`.

### Status Bar Style Management

Use `AnnotatedRegion<SystemUiOverlayStyle>` to manage status bar appearance for specific pages:

```dart
return AnnotatedRegion<SystemUiOverlayStyle>(
  value: const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,  // Brightness.light for light icons
  ),
  child: Scaffold(...),
);
```

For pages with dynamic status bar styling (e.g., DetailPage with scrolling), update the AppBar's `systemOverlayStyle` property instead:

```dart
appBar: AppBar(
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarIconBrightness: _calculateBrightness(),
  ),
),
```

### Reusable Widgets

**SvgIcon** - Simplified SVG icon component that renders a square icon with 1:1 aspect ratio:
```dart
SvgIcon(
  icon: 'assets/home/icon-user.svg',
  size: 20,
  color: Color(0xFF333333),  // Optional, defaults to Color(0xFFA28071)
)
```

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

## Material Interactions

Use `Material` widget as a parent for `InkWell` to enable proper ink splash effects on colored backgrounds:

```dart
Material(
  color: Colors.white,
  borderRadius: BorderRadius.circular(6),
  child: InkWell(
    onTap: () { /* ... */ },
    splashColor: Colors.grey.withValues(alpha: 0.1),
    child: Padding(...),
  ),
)
```

Without `Material` as a parent, the ink effect from `InkWell` will be invisible on opaque backgrounds.
