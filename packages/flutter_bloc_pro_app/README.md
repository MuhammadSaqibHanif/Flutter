# Flutter BLoC Pro App — Full Example (Production-quality patterns)

A complete Flutter sample app built around **flutter_bloc 9.1.1** showing advanced, professional usage of Bloc & Cubit across a multi-screen app. The goal: after studying this project you'll understand Bloc events/states/transformations, Cubit, BlocListeners, BlocSelector, repository pattern, dependency injection via RepositoryProvider, pagination, optimistic updates, error handling, testing hooks, and best practices for real-world apps.

---

## What this app does (feature highlights)

- Authentication flow (login/logout) using `AuthBloc` (Bloc + events + states).
- Home feed with posts (paginated) using `PostsBloc` with pagination, refresh and error handling.
- Post details screen and ability to like/unlike posts with optimistic updates via `PostsBloc`.
- Theme switching using `ThemeCubit` with saved preference (simulated persistence).
- Global error handling via `BlocListener` and `ScaffoldMessenger`.
- Repository layer separation and test-friendly design.
- Well-structured folder layout (models, repositories, blocs, screens, widgets, utils).

---

## Project structure (important files shown below)

```
lib/
├─ flutter_bloc_pro_app.dart
├─ app_router.dart
├─ models/
│  ├─ user.dart
│  └─ post.dart
├─ repositories/
│  ├─ auth_repository.dart
│  └─ posts_repository.dart
├─ blocs/
│  ├─ auth/
│  │  ├─ auth_bloc.dart
│  │  ├─ auth_event.dart
│  │  └─ auth_state.dart
│  ├─ posts/
│  │  ├─ posts_bloc.dart
│  │  ├─ posts_event.dart
│  │  └─ posts_state.dart
│  ├─ theme/
│  │  └─ theme_cubit.dart
│  └─ search/
│     └─ search_cubit.dart
├─ screens/
│  ├─ splash_screen.dart
│  ├─ login_screen.dart
│  ├─ home_screen.dart
│  └─ post_detail_screen.dart
├─ widgets/
│  ├─ post_list_item.dart
│  └─ infinite_list.dart
└─ utils/
   └─ validators.dart
```

---

## Key concepts & where to find them

- **Bloc vs Cubit**: `AuthBloc` and `PostsBloc` use full Bloc (events -> states). `ThemeCubit` & `SearchCubit` demonstrate Cubit use for simpler state.
- **MultiBlocProvider & RepositoryProvider**: See `main.dart` wiring to provide repositories and blocs at top-level.
- **BlocListener & BlocConsumer**: See `login_screen.dart` and `home_screen.dart` for navigating on auth changes and showing snackbars.
- **BlocSelector**: Used in `post_list_item.dart` to rebuild only the part that needs it (like button state) for performance.
- **Pagination**: `PostsBloc` handles `FetchPosts` with page/limit and `hasReachedMax` logic.
- **Optimistic updates**: Like toggling a post's liked state is updated locally then confirmed by repository; on failure it's reverted.
- **Debounce for search**: `SearchCubit` includes a debounce implementation.

---

## Notes on advanced techniques used

- **Event throttling/debouncing**: Posts `FetchPosts` uses `throttleDroppable` to protect from rapid repeated calls. Search implements debounce in Cubit.
- **Optimistic UI**: `ToggleLikePost` updates UI before repository confirms, then reconciles or reverts.
- **Selective rebuilds**: Use `BlocSelector` or `buildWhen` to prevent full-list rebuilds.
- **RepositoryProvider**: separates data from bloc logic and makes testing easier.
- **Testability**: All repositories are constructor injected. Blocs accept repositories as parameters.

---

## Suggested study plan after you open the code

1. Read `auth_bloc.dart` and `auth_repository.dart` side-by-side to see separation of concerns.
2. Read `posts_bloc.dart` to learn pagination and optimistic updates.
3. Run the app and try login with `test/password`; inspect logs and behavior.
4. Modify `PostsRepository.fetchPosts` to introduce delays or errors and watch Bloc's error states.

---
