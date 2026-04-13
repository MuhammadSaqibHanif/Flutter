
Each layer only talks to the layer below it — never skips.

###
The mental model in one picture
main.dart
  └── injection_container.dart  ← wires everything together

presentation/
  └── TodoBloc                  ← calls use cases
         ↓
domain/
  └── GetTodosUseCase           ← calls repository interface
         ↓
  └── TodoRepository (abstract) ← just a contract
         ↓
data/
  └── TodoRepositoryImpl        ← IMPLEMENTS the contract
         ↓
  └── TodoRemoteDataSource      ← actual HTTP calls
The arrows only ever point inward — data layer knows about domain, but domain knows NOTHING about data. That's the whole secret. If you swap your API for a local database, you only rewrite TodoRemoteDataSourceImpl and nothing else in your app changes.
###




```
// ── registerFactory ──────────────────────────────────────
// registerFactory = NEW instance every time it's requested.
// BLoC must be Factory — each screen needs its own fresh copy,
// otherwise state leaks between screens.
// New instance every single time sl<T>() is called.
// Use for: BLoC, Cubit — anything with state that must
// not leak between screens.

  // ── BLoC ────────────────────────────────────────────────
  sl.registerFactory(
    () => TodoBloc(
      getTodos:    sl(),  // sl() looks up GetTodosUseCase automatically
      createTodo:  sl(),
      toggleTodo:  sl(),
      deleteTodo:  sl(),
    ),
  );
```
confusing for me, why this for bloc ?
need stats in every part of the app, so why fresh this or not leak ?
understand me with examples like story


```
How sl() resolves the chain automatically
When main.dart calls di.sl<TodoBloc>(), get_it walks the entire dependency chain on its own:
sl<TodoBloc>()
  needs GetTodosUseCase    → sl() finds it
    needs TodoRepository   → sl() finds TodoRepositoryImpl
      needs RemoteDataSource → sl() finds TodoRemoteDataSourceImpl
        needs http.Client  → sl() finds it ✓
      needs LocalDataSource  → sl() finds TodoLocalDataSourceImpl
        needs SharedPreferences → sl() finds it ✓
      needs NetworkInfo    → sl() finds NetworkInfoImpl
        needs InternetConnectionChecker → sl() finds it ✓
You registered everything once. get_it figures out the whole tree automatically every time.
```
I dont understand it



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Q47: Get BLoC from DI container
      create: (_) => di.sl<TodoBloc>()..add(LoadTodosEvent()),
      child: const TodoView(),
    );
  }
  what if use context. here


      appBar: AppBar(
        title: const Text('Clean Architecture Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TodoBloc>().add(LoadTodosEvent());
            },
          ),
        ],
      ),
      why not use di here


not understanding the usage case of DI
what if di not use


factory TodoModel.fromEntity(Todo todo) {
Todo toEntity() => this;


  final sortedTodos = List<Todo>.from(todos)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));





Your 14-Day Journey:

Day 1: ✅ Q1-Q20 (Fundamentals) ← YOU ARE HERE
Day 2: Q21-Q40 (State Management Deep Dive)
Day 3: Q41-Q60 (BLoC Pattern)
Day 4: Q61-Q80 (Architecture & Performance)
Day 5: Q81-Q100 (Networking & Testing)
Day 6: Q101-Q120 (Advanced Dart)
Day 7: Q121-Q140 (Review & Practice)
Day 8: Q141-Q160 (System Design)
Day 9: Q161-Q180 (Common Mistakes)
Day 10: Q181-Q200 (Behavioral)
Day 11-13: Build complete features
Day 14: Mock interview & polish