
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


## Day 3 App 2

WidgetsBinding.instance.addPostFrameCallback((_) {

Tips for image optimization


## From Revision

Dart is an object oriented language because every value is an object. Objects are simply data structures in memory.

Profile Mode

Debugging tools