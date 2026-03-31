# 💻 DAY 3: CODE - Clean Architecture & Advanced Patterns

## 🎯 Today's Mission

Build 2 comprehensive apps in 3-4 hours that teach Q41-Q60 (Clean Architecture, Advanced Patterns).

**Learning Method:** Code first, understand architecture!
- Type each layer (domain, data, presentation)
- See how layers connect
- Understand dependency flow
- Then grasp the "why" behind architecture

---

## 📱 THE 2 APPS

| App | Time | Teaches | Questions |
|-----|------|---------|-----------|
| 1. Clean Architecture Todo | 120 min | Clean Architecture layers | Q41-Q50 |
| 2. Advanced Features App | 60 min | Performance & optimization | Q51-Q60 |

**Total: 3 hours**

---

## 📦 SETUP - Install Dependencies (5 minutes)

### **Update pubspec.yaml:**

```yaml
name: devsync_mini
description: Flutter interview prep app

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management (from Day 2)
  provider: ^6.1.1
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  flutter_riverpod: ^2.4.9
  equatable: ^2.0.5
  
  # NEW - Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # NEW - Network & Data
  dio: ^5.4.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # NEW - Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # NEW - Utils
  dartz: ^0.10.1  # For Either<Failure, Success>
  connectivity_plus: ^5.0.2
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
  
  # NEW - Code Generation
  build_runner: ^2.4.6
  injectable_generator: ^2.4.1
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
```

### **Install packages:**

```bash
flutter pub get
```

---

## 📁 Create Folder Structure (3 minutes)

```bash
cd lib
mkdir -p apps/day3/clean_todo/{domain,data,presentation}
mkdir -p apps/day3/clean_todo/domain/{entities,repositories,usecases}
mkdir -p apps/day3/clean_todo/data/{models,repositories,datasources}
mkdir -p apps/day3/clean_todo/presentation/{bloc,pages,widgets}
mkdir -p apps/day3/advanced_features
mkdir -p core/{error,network,usecases}
```

**Your structure:**
```
lib/
├── apps/
│   └── day3/
│       ├── clean_todo/
│       │   ├── domain/          # Business logic (no Flutter!)
│       │   │   ├── entities/    # Pure Dart models
│       │   │   ├── repositories/# Abstract contracts
│       │   │   └── usecases/    # Business rules
│       │   ├── data/            # Implementation details
│       │   │   ├── models/      # Data models (JSON)
│       │   │   ├── repositories/# Repository implementations
│       │   │   └── datasources/ # API, Database
│       │   └── presentation/    # UI layer
│       │       ├── bloc/        # State management
│       │       ├── pages/       # Screens
│       │       └── widgets/     # UI components
│       └── advanced_features/
└── core/
    ├── error/                   # Error handling
    ├── network/                 # Network utilities
    └── usecases/                # Base use case
```

---

# 📱 APP 1: CLEAN ARCHITECTURE TODO (120 minutes)

## 🎯 Teaches: Q41-Q50
- Q41: What is Clean Architecture?
- Q42: Domain, Data, Presentation layers
- Q43: Entities vs Models
- Q44: Repository Pattern
- Q45: Use Cases / Interactors
- Q46: Dependency Rule
- Q47: Dependency Injection
- Q48: Either<Failure, Success>
- Q49: Testing Clean Architecture
- Q50: When to use Clean Architecture

---

## 🏗️ ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                         │
│  (UI, BLoC, Pages, Widgets)                            │
│  Depends on: Domain                                     │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN                             │
│  (Entities, UseCases, Repository Interfaces)           │
│  Depends on: NOTHING (Pure Dart)                       │
└────────────────────┬────────────────────────────────────┘
                     ↑
                     │
┌─────────────────────────────────────────────────────────┐
│                       DATA                              │
│  (Models, Repository Impl, DataSources)                │
│  Depends on: Domain                                     │
└─────────────────────────────────────────────────────────┘
```

---

## 💻 LAYER 1: CORE (15 min)

### **File 1: Base Use Case**

**Create: `lib/core/usecases/usecase.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Q45: Base UseCase that all use cases extend
/// Type-safe way to handle success/failure
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't need parameters
class NoParams {}
```

---

### **File 2: Failures**

**Create: `lib/core/error/failures.dart`**

```dart
import 'package:equatable/equatable.dart';

/// Q48: Failure classes for error handling
/// Using Either<Failure, Success> pattern
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Q48: Specific failure types
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}
```

---

### **File 3: Exceptions**

**Create: `lib/core/error/exceptions.dart`**

```dart
/// Q48: Exceptions that get converted to Failures
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
}
```

---

## 💻 LAYER 2: DOMAIN (20 min)

### **File 1: Todo Entity**

**Create: `lib/apps/day3/clean_todo/domain/entities/todo.dart`**

```dart
import 'package:equatable/equatable.dart';

/// Q43: Entity - Pure business object
/// No JSON, no database code - just business logic
/// This is what your app ACTUALLY works with
class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });
  
  /// Q43: Entities can have business logic
  bool get isOverdue {
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays;
    return !isCompleted && daysSinceCreation > 7;
  }
  
  String get statusText {
    if (isCompleted) return 'Done ✅';
    if (isOverdue) return 'Overdue ⚠️';
    return 'Pending 📝';
  }
  
  /// Q43: Pure business logic method
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt];
}
```

---

### **File 2: Repository Interface**

**Create: `lib/apps/day3/clean_todo/domain/repositories/todo_repository.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/todo.dart';

/// Q44: Repository Pattern - Abstract contract
/// Domain layer defines WHAT, Data layer defines HOW
/// This is the "contract" that data layer must implement
abstract class TodoRepository {
  /// Get all todos
  /// Q48: Returns Either<Failure, List<Todo>>
  /// Left = Failure, Right = Success
  Future<Either<Failure, List<Todo>>> getTodos();
  
  /// Get single todo by ID
  Future<Either<Failure, Todo>> getTodoById(String id);
  
  /// Create new todo
  Future<Either<Failure, Todo>> createTodo(Todo todo);
  
  /// Update existing todo
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
  
  /// Delete todo
  Future<Either<Failure, void>> deleteTodo(String id);
  
  /// Toggle completion status
  Future<Either<Failure, Todo>> toggleTodo(String id);
}
```

---

### **File 3: Get Todos Use Case**

**Create: `lib/apps/day3/clean_todo/domain/usecases/get_todos.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Q45: Use Case - Single business action
/// Each use case does ONE thing
/// Encapsulates business rules
class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;
  
  GetTodos(this.repository);
  
  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) async {
    // Q45: Can add business logic here
    // Example: Filter, sort, validate, etc.
    
    final result = await repository.getTodos();
    
    // Q45: Business rule - sort by creation date
    return result.fold(
      (failure) => Left(failure),
      (todos) {
        final sortedTodos = List<Todo>.from(todos)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return Right(sortedTodos);
      },
    );
  }
}
```

---

### **File 4: Create Todo Use Case**

**Create: `lib/apps/day3/clean_todo/domain/usecases/create_todo.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Q45: Parameters for CreateTodo use case
class CreateTodoParams {
  final String title;
  final String description;
  
  CreateTodoParams({
    required this.title,
    required this.description,
  });
}

class CreateTodo implements UseCase<Todo, CreateTodoParams> {
  final TodoRepository repository;
  
  CreateTodo(this.repository);
  
  @override
  Future<Either<Failure, Todo>> call(CreateTodoParams params) async {
    // Q45: Business validation in use case
    if (params.title.trim().isEmpty) {
      return const Left(ValidationFailure('Title cannot be empty'));
    }
    
    if (params.title.length < 3) {
      return const Left(ValidationFailure('Title must be at least 3 characters'));
    }
    
    // Create entity
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.title.trim(),
      description: params.description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    
    return await repository.createTodo(todo);
  }
}
```

---

### **File 5: Toggle Todo Use Case**

**Create: `lib/apps/day3/clean_todo/domain/usecases/toggle_todo.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class ToggleTodo implements UseCase<Todo, String> {
  final TodoRepository repository;
  
  ToggleTodo(this.repository);
  
  @override
  Future<Either<Failure, Todo>> call(String todoId) async {
    return await repository.toggleTodo(todoId);
  }
}
```

---

### **File 6: Delete Todo Use Case**

**Create: `lib/apps/day3/clean_todo/domain/usecases/delete_todo.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodo implements UseCase<void, String> {
  final TodoRepository repository;
  
  DeleteTodo(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String todoId) async {
    return await repository.deleteTodo(todoId);
  }
}
```

---

## 💻 LAYER 3: DATA (30 min)

### **File 1: Todo Model**

**Create: `lib/apps/day3/clean_todo/data/models/todo_model.dart`**

```dart
import '../../domain/entities/todo.dart';

/// Q43: Model extends Entity
/// Model = Entity + JSON serialization
/// Model knows about data formats, Entity doesn't
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
    required super.createdAt,
  });
  
  /// Q43: From JSON (data layer concern)
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  /// Q43: To JSON (data layer concern)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Q43: From Entity (convert pure entity to model)
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
    );
  }
  
  /// Q43: To Entity (model IS-A entity, so just return this)
  Todo toEntity() => this;
}
```

---

### **File 2: Local Data Source**

**Create: `lib/apps/day3/clean_todo/data/datasources/todo_local_datasource.dart`**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../models/todo_model.dart';

/// Q44: Data Source - Where data comes from
/// This one uses SharedPreferences (local storage)
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> cacheTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const CACHED_TODOS = 'CACHED_TODOS';
  
  TodoLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<List<TodoModel>> getCachedTodos() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_TODOS);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => TodoModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException('Failed to get cached todos');
    }
  }
  
  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    try {
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(CACHED_TODOS, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache todos');
    }
  }
  
  @override
  Future<void> cacheTodo(TodoModel todo) async {
    try {
      final todos = await getCachedTodos();
      
      // Check if todo exists
      final index = todos.indexWhere((t) => t.id == todo.id);
      
      if (index != -1) {
        // Update existing
        todos[index] = todo;
      } else {
        // Add new
        todos.add(todo);
      }
      
      await cacheTodos(todos);
    } catch (e) {
      throw CacheException('Failed to cache todo');
    }
  }
  
  @override
  Future<void> deleteTodo(String id) async {
    try {
      final todos = await getCachedTodos();
      todos.removeWhere((todo) => todo.id == id);
      await cacheTodos(todos);
    } catch (e) {
      throw CacheException('Failed to delete todo');
    }
  }
}
```

---

### **File 3: Repository Implementation**

**Create: `lib/apps/day3/clean_todo/data/repositories/todo_repository_impl.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// Q44: Repository Implementation
/// Implements the contract defined in domain layer
/// Handles data sources and error conversion
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  
  TodoRepositoryImpl({
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      // Q44: Get data from data source
      final todos = await localDataSource.getCachedTodos();
      
      // Q44: Convert models to entities
      return Right(todos);
    } on CacheException catch (e) {
      // Q48: Convert exception to failure
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Todo>> getTodoById(String id) async {
    try {
      final todos = await localDataSource.getCachedTodos();
      final todo = todos.firstWhere(
        (todo) => todo.id == id,
        orElse: () => throw CacheException('Todo not found'),
      );
      return Right(todo);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) async {
    try {
      // Q43: Convert entity to model
      final todoModel = TodoModel.fromEntity(todo);
      
      // Q44: Save to data source
      await localDataSource.cacheTodo(todoModel);
      
      return Right(todoModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      await localDataSource.cacheTodo(todoModel);
      return Right(todoModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await localDataSource.deleteTodo(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Todo>> toggleTodo(String id) async {
    try {
      // Get current todo
      final todosResult = await getTodos();
      
      return todosResult.fold(
        (failure) => Left(failure),
        (todos) async {
          final todo = todos.firstWhere(
            (t) => t.id == id,
            orElse: () => throw CacheException('Todo not found'),
          );
          
          // Toggle completion
          final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
          
          // Save
          return await updateTodo(updatedTodo);
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
```

---

## 💻 LAYER 4: PRESENTATION (35 min)

### **File 1: Todo BLoC Events**

**Create: `lib/apps/day3/clean_todo/presentation/bloc/todo_event.dart`**

```dart
import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class CreateTodoEvent extends TodoEvent {
  final String title;
  final String description;
  
  CreateTodoEvent({
    required this.title,
    required this.description,
  });
  
  @override
  List<Object?> get props => [title, description];
}

class ToggleTodoEvent extends TodoEvent {
  final String todoId;
  
  ToggleTodoEvent(this.todoId);
  
  @override
  List<Object?> get props => [todoId];
}

class DeleteTodoEvent extends TodoEvent {
  final String todoId;
  
  DeleteTodoEvent(this.todoId);
  
  @override
  List<Object?> get props => [todoId];
}
```

---

### **File 2: Todo BLoC States**

**Create: `lib/apps/day3/clean_todo/presentation/bloc/todo_state.dart`**

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  
  TodoLoaded(this.todos);
  
  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;
  
  TodoError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

---

### **File 3: Todo BLoC**

**Create: `lib/apps/day3/clean_todo/presentation/bloc/todo_bloc.dart`**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/toggle_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

/// Q46: Presentation depends on Domain (use cases)
/// BLoC uses use cases, not repository directly
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final CreateTodo createTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;
  
  TodoBloc({
    required this.getTodos,
    required this.createTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<CreateTodoEvent>(_onCreateTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }
  
  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    
    // Q45: Call use case (business logic)
    final result = await getTodos(NoParams());
    
    // Q48: Handle Either<Failure, Success>
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodoLoaded(todos)),
    );
  }
  
  Future<void> _onCreateTodo(
    CreateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    
    final result = await createTodo(CreateTodoParams(
      title: event.title,
      description: event.description,
    ));
    
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        // Reload todos after creation
        add(LoadTodosEvent());
      },
    );
  }
  
  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await toggleTodo(event.todoId);
    
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        // Reload todos after toggle
        add(LoadTodosEvent());
      },
    );
  }
  
  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await deleteTodo(event.todoId);
    
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        // Reload todos after deletion
        add(LoadTodosEvent());
      },
    );
  }
}
```

---

## 💻 DEPENDENCY INJECTION (15 min)

### **File: Service Locator**

**Create: `lib/apps/day3/clean_todo/injection_container.dart`**

```dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/todo_local_datasource.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/get_todos.dart';
import 'domain/usecases/create_todo.dart';
import 'domain/usecases/toggle_todo.dart';
import 'domain/usecases/delete_todo.dart';
import 'presentation/bloc/todo_bloc.dart';

/// Q47: Dependency Injection Container
/// Manages all dependencies and their lifecycles
final sl = GetIt.instance;

Future<void> init() async {
  // ═══════════════════════════════════════════════════════════
  // PRESENTATION LAYER
  // ═══════════════════════════════════════════════════════════
  
  // BLoC
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      createTodo: sl(),
      toggleTodo: sl(),
      deleteTodo: sl(),
    ),
  );
  
  // ═══════════════════════════════════════════════════════════
  // DOMAIN LAYER - USE CASES
  // ═══════════════════════════════════════════════════════════
  
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  
  // ═══════════════════════════════════════════════════════════
  // DATA LAYER - REPOSITORIES
  // ═══════════════════════════════════════════════════════════
  
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  
  // ═══════════════════════════════════════════════════════════
  // DATA LAYER - DATA SOURCES
  // ═══════════════════════════════════════════════════════════
  
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  
  // ═══════════════════════════════════════════════════════════
  // EXTERNAL DEPENDENCIES
  // ═══════════════════════════════════════════════════════════
  
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
```

---

## 💻 UI LAYER (20 min)

### **File 1: Todo Page**

**Create: `lib/apps/day3/clean_todo/presentation/pages/todo_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_list_item.dart';
import '../widgets/add_todo_dialog.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Q47: Get BLoC from DI container
      create: (_) => di.sl<TodoBloc>()..add(LoadTodosEvent()),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(LoadTodosEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'No todos yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tap + to add one',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return TodoListItem(todo: todo);
              },
            );
          }
          
          return const Center(child: Text('Welcome'));
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TodoBloc>(),
              child: const AddTodoDialog(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

### **File 2: Todo List Item Widget**

**Create: `lib/apps/day3/clean_todo/presentation/widgets/todo_list_item.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  
  const TodoListItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            context.read<TodoBloc>().add(ToggleTodoEvent(todo.id));
          },
        ),
        
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: todo.isCompleted ? Colors.grey : null,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              todo.statusText,
              style: TextStyle(
                fontSize: 12,
                color: todo.isOverdue ? Colors.orange : Colors.grey,
              ),
            ),
          ],
        ),
        
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
          },
        ),
      ),
    );
  }
}
```

---

### **File 3: Add Todo Dialog**

**Create: `lib/apps/day3/clean_todo/presentation/widgets/add_todo_dialog.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({Key? key}) : super(key: key);

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<TodoBloc>().add(
        CreateTodoEvent(
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter todo title',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description (optional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

---

## 💻 MAIN APP (5 min)

**Create: `lib/apps/day3/clean_todo/clean_todo_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'presentation/pages/todo_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Q47: Initialize dependency injection
  await di.init();
  
  runApp(const CleanTodoApp());
}

class CleanTodoApp extends StatelessWidget {
  const CleanTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}
```

---

## 🚀 Run App 1

```bash
flutter run lib/apps/day3/clean_todo/clean_todo_app.dart
```

---

## ✅ App 1 Checkpoint

**Test These:**
1. [ ] App loads with empty state
2. [ ] Add new todo
3. [ ] Toggle todo completion
4. [ ] Delete todo
5. [ ] See "Overdue" status on old todos
6. [ ] Refresh works
7. [ ] Close app and reopen - todos persist!

---

## 🎓 What You Learned (Q41-Q50)

**Q41: Clean Architecture separates concerns into layers**
**Q42: Domain (business), Data (implementation), Presentation (UI)**
**Q43: Entity (pure business) vs Model (with JSON)**
**Q44: Repository pattern abstracts data sources**
**Q45: Use Cases encapsulate business rules**
**Q46: Dependency rule - outer depends on inner**
**Q47: DI makes testing and maintenance easier**
**Q48: Either<Failure, Success> for error handling**
**Q49: Each layer testable independently**
**Q50: Use Clean Architecture for complex, long-term projects**

---

# 📱 APP 2: ADVANCED FEATURES (60 minutes)

*Due to length, creating separate summary file...*

**Say "CONTINUE DAY 3 CODE" for App 2 (Performance & Optimization)!** 📚
