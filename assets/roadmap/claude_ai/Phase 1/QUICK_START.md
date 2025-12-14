# 🚀 QUICK START GUIDE

### 6. Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/network/dio_client_test.dart
```

### 7. Linting & Formatting

```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Fix auto-fixable issues
dart fix --apply
```

### 8. Common Commands

```bash
# Clean build
flutter clean && flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

### 9. Development Workflow

3. **Run code generation**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Write tests**

   - Unit tests for business logic
   - Widget tests for UI
   - Integration tests for flows

5. **Run linting**

   ```bash
   flutter analyze
   ```

6. **Format code**

   ```bash
   flutter format .
   ```

### 10. Troubleshooting

```bash
# Update dependencies
flutter pub upgrade --major-versions
```

#### Issue: Platform-specific errors (Android)

```bash
cd android
./gradlew clean
cd ..
flutter run
```

#### Issue: Platform-specific errors (iOS)

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

#### Issue: "Waiting for another flutter command to release the startup lock"

```bash
# Delete lock file
rm -rf ~/flutter/bin/cache/lockfile
```

### 11. Environment Setup (Future)

When we implement Flutter flavors (Phase 8), you'll run:

```bash
# Development environment
flutter run --flavor dev --dart-define=BASE_URL=https://dev.api.com

# Staging environment
flutter run --flavor staging --dart-define=BASE_URL=https://staging.api.com

# Production environment
flutter run --flavor prod --dart-define=BASE_URL=https://api.com
```

### 12. Useful VS Code Extensions

- Dart
- Flutter
- Flutter Bloc (for BLoC snippets)
- Error Lens (inline errors)
- GitLens (git history)
- Better Comments (comment highlighting)

### 13. Debugging

```bash
# Run with DevTools
flutter run --start-paused
# Then open DevTools URL

# Run with verbose logging
flutter run -v

# Attach to running app
flutter attach
```

### 14. Performance Profiling

```bash
# Run in profile mode
flutter run --profile

# Then use DevTools to analyze:
# - Frame rendering
# - Memory usage
# - Network requests
# - CPU usage
```

### 15. Building Release APK/IPA

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

---
