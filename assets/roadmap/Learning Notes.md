notes for learning

# Run in debug mode

flutter run --debug

# Run in profile mode (for performance testing)

flutter run --profile

# Run in release mode

flutter run --release

# Whenever you modify files with code generation annotations:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on save)
flutter pub run build_runner watch
```

**Generated files:**

- `*.freezed.dart` - Immutable classes with Freezed
- `*.g.dart` - JSON serialization
- `service_locator.config.dart` - Dependency injection

##

Q: "How do you manage package versions?"
✅ "I use version constraints in pubspec.yaml and lock exact versions with pubspec.lock. I regularly check pub.dev for updates and test before upgrading major versions."

Q: "How do you ensure reproducible builds?"
✅ "By committing pubspec.lock to version control, ensuring everyone uses exact same package versions"

Q: "How do you handle breaking changes in dependencies?"
A: "I follow a systematic approach:

Stay Informed: Subscribe to package changelogs, check pub.dev regularly
Plan Updates: Don't update all packages at once, do it incrementally
Read Migration Guides: Always check official guides before updating
Test Thoroughly: Run analyzer, tests, and manual testing
Document Changes: Update team documentation with migration notes
Use Version Control: Create separate branches for major updates

For example, when Dio moved from DioError to DioException in v5.0, I:

Read the changelog
Searched codebase for all usages
Updated error handling code
Ran tests to verify
Documented the change"

When Asked: "How do you handle breaking changes?"
Your Answer:

"I follow a systematic approach:

Check changelogs before any update
Read migration guides thoroughly
Test on separate branch first
Update incrementally, not all at once
Document changes for team

For example, I knew Dio 5.x deprecated DioError in favor of DioException, so I ensured my code used the current API from the start."
