# Clean Architecture in Flutter — Complete Guide
### From zero to fully understanding it, written for a new engineer

---

## The Story First — Why Does This Even Exist?

Imagine you build a Todo app. Everything is in one file — API calls, business rules, UI code, validation. It works. Then:

- Your designer wants to redesign every screen
- Your backend team changes all the API response keys
- You want to add offline support
- A new teammate wants to add a feature

Every change breaks everything else. You spend more time fixing than building.

**Clean Architecture solves this by giving every piece of code exactly one job, and putting it in exactly one place.**

Change the API? Only touch the data layer.  
Redesign the UI? Only touch the presentation layer.  
Add a business rule? Only touch the domain layer.  
Nothing else breaks. Ever.

---

## The Three Layers — The Core Idea

Think of it like a company:

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                │
│   Flutter UI, BLoC, Widgets, Pages          │
│   "The front desk — talks to customers"     │
├─────────────────────────────────────────────┤
│             DOMAIN LAYER                    │
│   Entities, Use Cases, Repository Interface │
│   "Management — makes the decisions"        │
├─────────────────────────────────────────────┤
│              DATA LAYER                     │
│   Models, Repository Impl, DataSources      │
│   "The warehouse — does the actual work"    │
└─────────────────────────────────────────────┘
```

**The golden rule: arrows only point inward.**

- Presentation knows about Domain
- Data knows about Domain
- Domain knows about NOBODY

Domain is the brain. It never imports Flutter. It never imports http. It never talks to a database. It just defines what your app *does* and what the rules *are*.

---

## The Full Folder Structure

```
lib/
├── core/                          ← shared across all features
│   ├── error/
│   │   ├── failures.dart          ← expected problems (ServerFailure, etc.)
│   │   └── exceptions.dart        ← low-level crashes (ServerException, etc.)
│   ├── usecases/
│   │   └── usecase.dart           ← base template all use cases follow
│   └── network/
│       └── network_info.dart      ← checks internet connection
│
├── features/
│   └── todo/
│       ├── domain/                ← PURE DART. No Flutter. No http.
│       │   ├── entities/
│       │   │   └── todo.dart      ← what a Todo IS
│       │   ├── repositories/
│       │   │   └── todo_repository.dart  ← abstract contract
│       │   └── usecases/
│       │       ├── get_todos_usecase.dart
│       │       ├── create_todo_usecase.dart
│       │       └── toggle_todo_usecase.dart
│       │
│       ├── data/                  ← implements domain contracts
│       │   ├── models/
│       │   │   └── todo_model.dart        ← Todo + JSON knowledge
│       │   ├── datasources/
│       │   │   ├── todo_remote_datasource.dart  ← API calls
│       │   │   └── todo_local_datasource.dart   ← cache/SharedPrefs
│       │   └── repositories/
│       │       └── todo_repository_impl.dart    ← implements the contract
│       │
│       └── presentation/          ← Flutter UI lives here
│           ├── bloc/
│           │   ├── todo_bloc.dart
│           │   ├── todo_event.dart
│           │   └── todo_state.dart
│           ├── pages/
│           │   └── todo_page.dart
│           └── widgets/
│               └── todo_tile.dart
│
└── injection_container.dart       ← wires everything together (get_it)
```

---

## CORE — The Shared Toolbox

### `core/error/failures.dart`

Failures are **expected problems** your app knows how to handle. They travel UP through the layers as `Left()` inside `Either`.

```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
```

### `core/error/exceptions.dart`

Exceptions are **low-level crashes** thrown deep in the data layer. Repositories catch them and convert them into Failures. Domain and presentation NEVER see these.

```dart
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
```

**The one rule:**
```
Exceptions → thrown in datasources, caught in repositories, converted to Failures
Failures   → created in repositories, travel up as Left(), handled in BLoC
```

### `core/usecases/usecase.dart`

A template every use case follows. Forces them all to look the same.

```dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Type   = what you RETURN on success
// Params = what INPUT you need
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// When a use case needs no input at all
class NoParams {}
```

The `call()` method is special — it lets you call the object like a function:
```dart
// Instead of:    useCase.call(params)
// You can write: useCase(params)
```

---

## DOMAIN LAYER — The Brain

**Rule: zero Flutter imports. Zero http imports. Pure Dart only.**

Why? Because domain is your business logic. It should work whether your app is Flutter, React Native, a CLI tool, or a backend server. The moment you import Flutter, you chain your business logic to one framework forever.

### `domain/entities/todo.dart`

This is what a Todo *is*. No JSON. No database columns. Just the concept.

```dart
class Todo {
  final String id;
  final String title;
  final bool isDone;

  const Todo({
    required this.id,
    required this.title,
    required this.isDone,
  });
}
```

### `domain/repositories/todo_repository.dart`

An **abstract contract** — says "I need these things" without saying how to get them. The data layer will answer that.

```dart
import 'package:dartz/dartz.dart';
import '../entities/todo.dart';
import '../../core/error/failures.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> createTodo(String title);
  Future<Either<Failure, Todo>> toggleTodo(String id);
  Future<Either<Failure, void>> deleteTodo(String id);
}
```

### `domain/usecases/get_todos_usecase.dart`

One use case = one business rule.

```dart
import 'package:dartz/dartz.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

//                          Type         Params
class GetTodosUseCase implements UseCase<List<Todo>, NoParams> {

  final TodoRepository repository;
  GetTodosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) {
    return repository.getTodos();
  }
}
```

### `domain/usecases/create_todo_usecase.dart`

Use cases with input need a Params class:

```dart
// Define params for this use case
class CreateTodoParams {
  final String title;
  const CreateTodoParams({required this.title});
}

class CreateTodoUseCase implements UseCase<Todo, CreateTodoParams> {
  final TodoRepository repository;
  CreateTodoUseCase(this.repository);

  @override
  Future<Either<Failure, Todo>> call(CreateTodoParams params) {
    // Business rules live HERE — not in BLoC, not in repository
    if (params.title.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('Title cannot be empty')));
    }
    if (params.title.length > 100) {
      return Future.value(Left(ValidationFailure('Title too long — max 100 characters')));
    }
    return repository.createTodo(params.title);
  }
}
```

**Why BLoC calls use cases instead of the repository directly:**

If BLoC called the repository directly, every BLoC that creates a todo would have to copy the validation logic. Change the rule once = hunt down every BLoC. With a use case in the middle, the rule lives in exactly one place and every caller gets it automatically.

---

## DATA LAYER — The Warehouse

### `data/models/todo_model.dart`

`TodoModel` = `Todo` + JSON knowledge. It extends `Todo` so it IS a `Todo` — can be used anywhere a `Todo` is expected.

```dart
import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.isDone,
  });

  // JSON → TodoModel
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id:     json['id']      as String,
      title:  json['title']   as String,
      isDone: json['is_done'] as bool,
    );
  }

  // TodoModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id':      id,
      'title':   title,
      'is_done': isDone,
    };
  }
}
```

**Todo vs TodoModel:**
- `Todo` answers: "What is a todo?" — pure concept, no JSON
- `TodoModel` answers: "How do I create a todo from an API response?" — the translator

If your API changes `is_done` to `completed`, you change one line in `fromJson()`. The rest of the app never notices.

### `data/datasources/todo_remote_datasource.dart`

Does the actual HTTP work. Throws Exceptions when things go wrong.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';
import '../../core/error/exceptions.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> createTodo(String title);
  Future<TodoModel> toggleTodo(String id);
  Future<void> deleteTodo(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;
  static const baseUrl = 'https://api.example.com';

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((j) => TodoModel.fromJson(j)).toList();
    } else {
      throw ServerException('Failed to load todos: ${response.statusCode}');
    }
  }

  @override
  Future<TodoModel> createTodo(String title) async {
    final response = await client.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'is_done': false}),
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to create todo');
    }
  }

  @override
  Future<TodoModel> toggleTodo(String id) async {
    final response = await client.patch(Uri.parse('$baseUrl/todos/$id/toggle'));

    if (response.statusCode == 200) {
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to toggle todo');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/todos/$id'));
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete todo');
    }
  }
}
```

### `data/repositories/todo_repository_impl.dart`

The KEY file. Catches raw exceptions from datasource, converts them into typed Failures, returns Either. This is where domain meets data.

```dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/todo_remote_datasource.dart';
import '../datasources/todo_local_datasource.dart';
import '../../core/network/network_info.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource  localDataSource;
  final NetworkInfo          networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    if (await networkInfo.isConnected) {
      try {
        final todos = await remoteDataSource.getTodos();
        await localDataSource.cacheTodos(todos); // save for offline
        return Right(todos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // No internet — serve from cache
      try {
        final cached = await localDataSource.getCachedTodos();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo(String title) async {
    try {
      final model = await remoteDataSource.createTodo(title);
      return Right(model); // TodoModel IS a Todo, works perfectly
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodo(String id) async {
    try {
      final model = await remoteDataSource.toggleTodo(id);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await remoteDataSource.deleteTodo(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

---

## EITHER — The Box That Forces You to Handle Errors

`Either<Failure, Data>` is a box with exactly two states. Never both, never neither.

```
Left(failure)  →  something went wrong  →  ServerFailure, NetworkFailure, etc.
Right(data)    →  here's your data      →  List<Todo>, Todo, etc.
```

**Why Either instead of try/catch?**

Old way — caller can forget error handling:
```dart
final todos = await getTodos(); // crashes if something went wrong, no warning
```

Either way — compiler forces you to handle both:
```dart
final result = await getTodosUseCase(NoParams());
result.fold(
  (failure) => // you MUST handle this
  (todos)   => // you MUST handle this
);
```

**fold() — the only way to open the box:**

```dart
result.fold(
  (failure) {
    // runs ONLY if Left
    if (failure is NetworkFailure) {
      emit(TodoError('No internet. Check your connection.'));
    } else if (failure is ServerFailure) {
      emit(TodoError('Server error. Try again later.'));
    } else {
      emit(TodoError(failure.message));
    }
  },
  (todos) {
    // runs ONLY if Right
    emit(TodoLoaded(todos));
  },
);
```

**Other useful Either methods:**
```dart
result.isLeft();   // true if failure
result.isRight();  // true if success

// Map success value (Left passes through untouched)
result.map((todos) => todos.where((t) => !t.isDone).toList());

// Default if Left
result.getOrElse(() => []);
```

---

## PRESENTATION LAYER — The Flutter UI

### `presentation/bloc/todo_event.dart`

```dart
abstract class TodoEvent {}

class GetTodosEvent extends TodoEvent {}

class CreateTodoEvent extends TodoEvent {
  final String title;
  CreateTodoEvent(this.title);
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  ToggleTodoEvent(this.id);
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent(this.id);
}
```

### `presentation/bloc/todo_state.dart`

```dart
import '../../domain/entities/todo.dart';

abstract class TodoState {}

class TodoInitial  extends TodoState {}
class TodoLoading  extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}

class TodoCreating extends TodoState {
  final List<Todo> todos; // keep showing existing list while creating
  TodoCreating(this.todos);
}
```

### `presentation/bloc/todo_bloc.dart`

BLoC has ONE job: translate events into states. No validation. No business rules. Just call the use case and react to the result.

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/create_todo_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../core/usecases/usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase    getTodosUseCase;
  final CreateTodoUseCase  createTodoUseCase;
  final ToggleTodoUseCase  toggleTodoUseCase;

  TodoBloc({
    required this.getTodosUseCase,
    required this.createTodoUseCase,
    required this.toggleTodoUseCase,
  }) : super(TodoInitial()) {
    on<GetTodosEvent>(_onGetTodos);
    on<CreateTodoEvent>(_onCreateTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
  }

  Future<void> _onGetTodos(GetTodosEvent event, Emitter emit) async {
    emit(TodoLoading());
    final result = await getTodosUseCase(NoParams());
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos)   => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onCreateTodo(CreateTodoEvent event, Emitter emit) async {
    final currentTodos = state is TodoLoaded ? (state as TodoLoaded).todos : <Todo>[];
    emit(TodoCreating(currentTodos));

    final result = await createTodoUseCase(CreateTodoParams(title: event.title));
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (newTodo)  => emit(TodoLoaded([...currentTodos, newTodo])),
    );
  }

  Future<void> _onToggleTodo(ToggleTodoEvent event, Emitter emit) async {
    if (state is! TodoLoaded) return;
    final currentTodos = (state as TodoLoaded).todos;

    final result = await toggleTodoUseCase(ToggleTodoParams(id: event.id));
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (updated) {
        final newList = currentTodos.map(
          (t) => t.id == updated.id ? updated : t
        ).toList();
        emit(TodoLoaded(newList));
      },
    );
  }
}
```

### `presentation/pages/todo_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(GetTodosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: Column(
        children: [
          _buildInput(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Add a todo...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<TodoBloc>().add(CreateTodoEvent(_controller.text));
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TodoError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () => context.read<TodoBloc>().add(GetTodosEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is TodoLoaded || state is TodoCreating) {
          final todos = state is TodoLoaded
              ? (state as TodoLoaded).todos
              : (state as TodoCreating).todos;

          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet!'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) =>
                      context.read<TodoBloc>().add(ToggleTodoEvent(todo.id)),
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    color: todo.isDone ? Colors.grey : null,
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## DEPENDENCY INJECTION — Wiring It All Together

DI solves one problem: who creates which objects, and how do they find each other?

Without DI:
```dart
// BLoC has to build everything itself — tightly coupled, hard to test
final bloc = TodoBloc(
  getTodosUseCase: GetTodosUseCase(
    TodoRepositoryImpl(
      remoteDataSource: TodoRemoteDataSourceImpl(client: http.Client()),
      localDataSource: TodoLocalDataSourceImpl(...),
      networkInfo: NetworkInfoImpl(...),
    ),
  ),
);
```

With DI (get_it):
```dart
// Register once, anywhere in app just ask for what you need
final bloc = sl<TodoBloc>(); // get_it builds the whole tree automatically
```

### `injection_container.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Presentation
import 'features/todo/presentation/bloc/todo_bloc.dart';
// Domain
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/get_todos_usecase.dart';
import 'features/todo/domain/usecases/create_todo_usecase.dart';
import 'features/todo/domain/usecases/toggle_todo_usecase.dart';
// Data
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/data/datasources/todo_remote_datasource.dart';
import 'features/todo/data/datasources/todo_local_datasource.dart';
// Core
import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // ── BLoC ─────────────────────────────────────────────
  // registerFactory = NEW instance every time
  // BLoC must be Factory — each screen needs its own fresh copy
  sl.registerFactory(
    () => TodoBloc(
      getTodosUseCase:   sl(),
      createTodoUseCase: sl(),
      toggleTodoUseCase: sl(),
    ),
  );

  // ── Use Cases ────────────────────────────────────────
  // registerLazySingleton = created once, reused forever
  // Use cases have no state — safe to share
  sl.registerLazySingleton(() => GetTodosUseCase(sl()));
  sl.registerLazySingleton(() => CreateTodoUseCase(sl()));
  sl.registerLazySingleton(() => ToggleTodoUseCase(sl()));

  // ── Repository ───────────────────────────────────────
  // Register ABSTRACT type, provide CONCRETE implementation.
  // Anyone asking for TodoRepository gets TodoRepositoryImpl
  // but never needs to import the impl directly.
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource:  sl(),
      networkInfo:      sl(),
    ),
  );

  // ── DataSources ──────────────────────────────────────
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ── Core ─────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ── External Packages ────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
```

**The three registration types:**

| Type | When created | Use for |
|------|-------------|---------|
| `registerFactory` | New instance every call | BLoC, Cubit — anything with STATE |
| `registerLazySingleton` | Once on first request | Use cases, repositories, datasources |
| `registerSingleton` | Immediately at registration | Logging, crash reporters |

### `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => di.sl<TodoBloc>()..add(GetTodosEvent()),
        child: const TodoPage(),
      ),
    );
  }
}
```

---

## The Complete Data Flow — One Request, Start to Finish

**Scenario: user taps "Load Todos"**

```
1. UI fires GetTodosEvent into BLoC
   └── TodoPage: context.read<TodoBloc>().add(GetTodosEvent())

2. BLoC emits TodoLoading, calls use case
   └── emit(TodoLoading())
   └── await getTodosUseCase(NoParams())

3. UseCase calls repository interface
   └── return repository.getTodos()
   └── (no idea HOW — just calls the contract)

4. Repository checks internet
   └── if connected → call remote datasource
   └── if offline   → call local datasource

5. DataSource makes HTTP call
   └── GET /todos
   └── if 200 → parse JSON → return List<TodoModel>
   └── if error → throw ServerException

6. Repository catches exception, returns Either
   └── on success → return Right(todoModels)
   └── on ServerException → return Left(ServerFailure(...))

7. Either travels back up through UseCase to BLoC
   └── UseCase passes it through untouched

8. BLoC opens box with fold()
   └── Left(failure) → emit(TodoError(failure.message))
   └── Right(todos)  → emit(TodoLoaded(todos))

9. UI reacts to new state
   └── TodoLoading  → show spinner
   └── TodoLoaded   → show list
   └── TodoError    → show error + retry button
```

---

## Quick Reference — What Goes Where

| Thing | Layer | File |
|-------|-------|------|
| `Todo` class (id, title, isDone) | Domain | `domain/entities/todo.dart` |
| `TodoRepository` (abstract) | Domain | `domain/repositories/` |
| `GetTodosUseCase` | Domain | `domain/usecases/` |
| `TodoModel` (Todo + JSON) | Data | `data/models/` |
| API calls (http.get) | Data | `data/datasources/` |
| `TodoRepositoryImpl` | Data | `data/repositories/` |
| `TodoBloc`, events, states | Presentation | `presentation/bloc/` |
| Screens and widgets | Presentation | `presentation/pages/` |
| Failure classes | Core | `core/error/failures.dart` |
| Exception classes | Core | `core/error/exceptions.dart` |
| `UseCase` base class | Core | `core/usecases/usecase.dart` |
| get_it registrations | Root | `injection_container.dart` |

---

## Key Concepts in Plain English

**Entity vs Model**
- `Todo` = what the thing IS (business concept, pure Dart)
- `TodoModel` = what the thing IS + how to translate from/to JSON

**Repository interface vs implementation**
- Interface (domain): "I need a way to get todos" — no code
- Implementation (data): "here's HOW using this API" — actual code

**UseCase vs Repository**
- Repository = get/save data (no rules)
- UseCase = one business rule (validation, logic, combining operations)

**Exception vs Failure**
- Exception = raw crash deep in data layer (ServerException)
- Failure = clean typed error your app reasons about (ServerFailure)

**Either**
- A box that is either Left (failure) or Right (success)
- `fold()` forces you to handle both — compiler won't let you skip errors

**Dependency Injection**
- Register everything once in `injection_container.dart`
- Ask for what you need with `sl<T>()`
- get_it builds the entire dependency tree automatically

---

## Packages You Need

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # state management
  dartz: ^0.10.1            # Either, Option
  get_it: ^7.6.0            # dependency injection
  http: ^1.1.0              # HTTP calls
  internet_connection_checker: ^1.0.0  # network check
  shared_preferences: ^2.2.0           # local cache

dev_dependencies:
  mocktail: ^1.0.0          # mocking for tests
```

---

## The Mental Model — One Sentence Per Layer

```
Domain     = the WHAT  (what is a Todo, what can you do with it)
Data       = the HOW   (how to get it from API, how to save it)
Presentation = the SHOW (how to display it, how to react to input)
Core       = the SHARED (errors and templates used by everyone)
```

Change the API → only touch Data.
Change the UI → only touch Presentation.
Change a business rule → only touch Domain.
Nothing else breaks.

That is the entire point of Clean Architecture.
