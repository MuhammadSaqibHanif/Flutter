# Implementation Roadmap - Master Flutter Applications

## 📅 12-Week Implementation Plan

---

## Week 1-2: Foundation & Setup

### Module 1.1: Project Infrastructure (Days 1-3)

#### DevSync Pro Setup
```bash
# Create Flutter project with multi-flavor support
flutter create devsync_pro --org com.devsync --platforms android,ios,web,macos

# Add platforms
cd devsync_pro
flutter create . --platforms web,macos,windows,linux
```

**Files to Create:**
1. `lib/core/constants/`
2. `lib/core/config/`
3. `lib/core/utils/`
4. Flavor configurations
5. Environment configurations

**Topics Covered:**
- ✅ Flutter Flavors (dev, staging, prod)
- ✅ Project structure (Clean Architecture)
- ✅ Dependency Injection setup
- ✅ Build configurations
- ✅ Environment variables

**Deliverable:** Running app with 3 flavors

---

### Module 1.2: CI/CD Pipeline (Days 4-5)

**Files to Create:**
```yaml
.github/workflows/
├── ci.yml                 # Continuous Integration
├── deploy_android.yml     # Android deployment
├── deploy_ios.yml         # iOS deployment
└── release.yml            # Release automation
```

**Pipeline Stages:**
1. **Lint & Format**
   ```yaml
   - name: Analyze code
     run: flutter analyze
   - name: Check formatting
     run: dart format --set-exit-if-changed .
   ```

2. **Testing**
   ```yaml
   - name: Run tests
     run: flutter test --coverage
   - name: Upload coverage
     uses: codecov/codecov-action@v3
   ```

3. **Build**
   ```yaml
   - name: Build APK
     run: flutter build apk --release --flavor prod
   ```

4. **Deploy**
   ```yaml
   - name: Deploy to Play Store
     uses: r0adkll/upload-google-play@v1
   ```

**Topics Covered:**
- ✅ GitHub Actions
- ✅ Fastlane integration
- ✅ Automated testing
- ✅ Code coverage tracking
- ✅ Automated deployment

**Deliverable:** Fully automated CI/CD pipeline

---

### Module 1.3: Core Architecture Setup (Days 6-7)

**Files to Create:**

```
lib/
├── core/
│   ├── di/
│   │   ├── injection.dart
│   │   └── injection.config.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   ├── exceptions.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_interceptor.dart
│   │   └── network_info.dart
│   └── usecases/
│       └── usecase.dart
```

**Code Example - Dependency Injection:**

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

**Code Example - UseCase Base:**

```dart
// lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases
/// 
/// Generic types:
/// - [Type]: Return type of the use case
/// - [Params]: Parameters required by the use case
/// 
/// Returns [Either<Failure, Type>]:
/// - Left: Failure case
/// - Right: Success case
abstract class UseCase<Type, Params> {
  /// Execute the use case
  /// 
  /// This method must be implemented by all concrete use cases.
  /// It encapsulates the business logic and returns a result
  /// wrapped in Either for functional error handling.
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this class when a use case doesn't need parameters
class NoParams {
  const NoParams();
}
```

**Topics Covered:**
- ✅ Dependency Injection (GetIt + Injectable)
- ✅ Clean Architecture layers
- ✅ Error handling pattern
- ✅ UseCase pattern
- ✅ Functional programming (Either)

**Interview Questions:**

**Q1: Why use the UseCase pattern?**
```dart
// Answer:
// 1. Single Responsibility: Each use case does one thing
// 2. Testability: Easy to unit test business logic
// 3. Reusability: Can be called from different parts of the app
// 4. Separation: Business logic separated from presentation

// Example:
class LoginUseCase implements UseCase<User, LoginParams> {
  final IAuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure('Email required'));
    }
    
    // Business logic
    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
```

**Q2: Explain the Either type and why it's useful**
```dart
// Answer:
// Either represents a value that can be one of two types
// - Left: Represents failure/error
// - Right: Represents success/value
// 
// Benefits:
// 1. Type-safe error handling
// 2. Forces error handling (no silent failures)
// 3. Composable (can chain operations)
// 4. No try-catch needed

// Usage:
final result = await loginUseCase(LoginParams(email, password));

result.fold(
  (failure) {
    // Handle error
    if (failure is NetworkFailure) {
      showError('No internet connection');
    }
  },
  (user) {
    // Handle success
    navigateToHome(user);
  },
);
```

**Deliverable:** Core architecture with DI, error handling, and base classes

---

## Week 2: Authentication Module (Complete Implementation)

### Module 2.1: Domain Layer (Days 8-9)

**Complete File Structure:**
```
lib/features/authentication/
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── i_auth_repository.dart
│   └── usecases/
│       ├── login.dart
│       ├── register.dart
│       ├── logout.dart
│       └── get_current_user.dart
```

**COMPLETE CODE:**

```dart
// lib/features/authentication/domain/entities/user.dart

/// Domain entity representing a User
/// 
/// Why this is an entity (not a model):
/// 1. Business logic layer - no dependencies on data layer
/// 2. Immutable - represents business rules
/// 3. Framework agnostic - can be used in pure Dart
/// 
/// Interview Q: Difference between Entity and Model?
/// - Entity: Domain layer, business rules, immutable
/// - Model: Data layer, serialization, mutable (can be)
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
  });
  
  /// Business logic example: Check if user is new (< 7 days)
  bool get isNewUser {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }
  
  /// Copy with method for creating modified copies
  /// (maintaining immutability)
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}
```

**Line-by-line Explanation:**

```dart
// Line 1-5: Documentation
/// Using triple-slash for documentation
/// This generates documentation in IDEs and docs

// Line 13-19: Constructor
/// Why 'const'? 
/// - Compile-time constant
/// - Saves memory (reuses instances)
/// - Better performance
/// Interview Q: When to use const?
/// - When object doesn't change
/// - When you want compile-time optimization

// Line 21-26: Computed property (getter)
/// Why getter instead of method?
/// - Cleaner syntax: user.isNewUser vs user.isNewUser()
/// - Represents a property of the object
/// - Can be used in filters: users.where((u) => u.isNewUser)

// Line 28-42: copyWith pattern
/// Why copyWith?
/// - Maintain immutability
/// - Create modified copies
/// - Common in functional programming
/// Example: 
///   final updatedUser = user.copyWith(name: 'New Name');

// Line 44-48: Equality operator
/// Why override ==?
/// - For comparing objects by value
/// - Used in lists, sets, maps
/// - Widget rebuilds depend on this
/// Interview Q: What happens if you don't override this?
/// - Objects compared by reference (memory address)
/// - user1 == user2 would be false even with same data

// Line 50-52: hashCode
/// Why override hashCode?
/// - Must override when overriding ==
/// - Used in HashMap, HashSet
/// - Affects performance of collections
```

**Now the Repository Interface:**

```dart
// lib/features/authentication/domain/repositories/i_auth_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Authentication Repository Interface
/// 
/// Why an interface?
/// 1. Dependency Inversion Principle (SOLID)
///    - Domain layer doesn't depend on data layer
///    - Can swap implementations (REST, GraphQL, Mock)
/// 
/// 2. Testability
///    - Easy to mock for tests
///    - No real network calls in tests
/// 
/// 3. Flexibility
///    - Multiple implementations (production, testing, offline)
/// 
/// Interview Q: Why use Either<Failure, Success>?
/// - Type-safe error handling
/// - No exceptions thrown
/// - Forces handling both success and failure cases
abstract class IAuthRepository {
  /// Login with email and password
  /// 
  /// Returns:
  /// - Left(Failure): If login fails
  /// - Right(User): If login succeeds
  /// 
  /// Possible Failures:
  /// - NetworkFailure: No internet connection
  /// - ServerFailure: Server error (500)
  /// - ValidationFailure: Invalid credentials
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  /// Register new user
  /// 
  /// Additional validation in use case:
  /// - Email format
  /// - Password strength
  /// - Name length
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });
  
  /// Logout current user
  /// 
  /// Returns:
  /// - Left(Failure): If logout fails
  /// - Right(void): If logout succeeds
  Future<Either<Failure, void>> logout();
  
  /// Get currently logged in user
  /// 
  /// Returns:
  /// - Left(Failure): If no user or error
  /// - Right(User): Current user
  /// 
  /// Use case: Check auth status on app start
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Stream of authentication state changes
  /// 
  /// Emits:
  /// - User: When user logs in
  /// - null: When user logs out
  /// 
  /// Why stream?
  /// - Real-time updates across app
  /// - Reactive programming
  /// - Auto-refresh UI on auth changes
  /// 
  /// Interview Q: Stream vs Future?
  /// Future: Single value, completes once
  /// Stream: Multiple values over time
  Stream<User?> get authStateChanges;
}
```

**Now the Use Cases:**

```dart
// lib/features/authentication/domain/usecases/login.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

/// Login Use Case
/// 
/// Responsibility:
/// - Validate input
/// - Execute login business logic
/// - Return result
/// 
/// Single Responsibility Principle:
/// - Only handles login logic
/// - Doesn't know about UI or data sources
@injectable
class Login implements UseCase<User, LoginParams> {
  final IAuthRepository _repository;
  
  const Login(this._repository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validation (Business Rules)
    if (params.email.isEmpty) {
      return Left(ValidationFailure('Email is required'));
    }
    
    if (params.password.isEmpty) {
      return Left(ValidationFailure('Password is required'));
    }
    
    if (!_isValidEmail(params.email)) {
      return Left(ValidationFailure('Invalid email format'));
    }
    
    if (params.password.length < 6) {
      return Left(ValidationFailure('Password too short'));
    }
    
    // Execute repository method
    return await _repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }
  
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

/// Login Parameters
/// 
/// Why separate class?
/// - Type safety
/// - Clear contract
/// - Easy to extend (add "remember me", etc.)
class LoginParams {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
}
```

**Interview Questions for Domain Layer:**

**Q1: Why separate Domain layer from Data layer?**
```dart
// Answer with code example:

// ❌ BAD: Domain depends on Data
class LoginUseCase {
  final Dio dio; // Direct dependency on HTTP client!
  
  Future<User> call(String email, String password) {
    final response = await dio.post('/login'); // Tight coupling!
  }
}

// ✅ GOOD: Domain depends on abstraction
class Login {
  final IAuthRepository repository; // Interface dependency
  
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(...); // Loose coupling!
  }
}

// Benefits:
// 1. Can change from REST to GraphQL without touching UseCase
// 2. Easy to test (mock the repository)
// 3. Business logic stays pure
```

**Q2: When would you NOT use Clean Architecture?**
```dart
// Answer:
// Don't use Clean Architecture when:
// 1. Very simple app (<5 screens)
// 2. Prototype/MVP
// 3. No team collaboration
// 4. Short-lived project

// Example of simpler architecture for small app:
class LoginScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Direct API call - fine for simple apps
        final user = await FirebaseAuth.instance.signIn(...);
      },
    );
  }
}

// Use Clean Architecture when:
// 1. Team > 3 people
// 2. Long-term project
// 3. Complex business logic
// 4. Multiple data sources
// 5. Testability is critical
```

**Deliverable:** Complete Domain layer with tests

---

### Module 2.2: Data Layer (Days 10-11)

**Complete File Structure:**
```
lib/features/authentication/
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart
│   │   └── auth_remote_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── auth_response_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
```

**COMPLETE CODE:**

```dart
// lib/features/authentication/data/models/user_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data Transfer Object for User
/// 
/// Why Freezed?
/// 1. Immutability
/// 2. Code generation (toJson, fromJson)
/// 3. copyWith, equality, toString
/// 4. Union types for sealed classes
/// 
/// Interview Q: Model vs Entity?
/// Model: Data layer, knows about JSON, database
/// Entity: Domain layer, pure business logic
@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;
  
  /// From JSON factory
  /// 
  /// Called when parsing API response:
  /// ```dart
  /// final json = {'id': '123', 'email': 'user@example.com', ...};
  /// final user = UserModel.fromJson(json);
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  /// Convert Model to Domain Entity
  /// 
  /// Why separate?
  /// - Domain shouldn't know about JSON
  /// - Data layer converts to domain objects
  /// 
  /// Interview Q: Why this conversion?
  /// Separation of concerns:
  /// - BLoC works with User (domain)
  /// - Repository works with UserModel (data)
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
  
  /// Convert Domain Entity to Model
  /// 
  /// Used when sending data to API:
  /// ```dart
  /// final user = User(...);
  /// final model = UserModel.fromEntity(user);
  /// await api.updateUser(model.toJson());
  /// ```
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
```

**Data Sources:**

```dart
// lib/features/authentication/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

part 'auth_remote_datasource.g.dart';

/// Remote Data Source Interface
/// 
/// Why interface for data source?
/// - Easy to swap implementations
/// - Can mock for tests
/// - Can have multiple implementations (REST, GraphQL)
abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  });
  
  Future<void> logout(String token);
  
  Future<UserModel> getCurrentUser(String token);
}

/// Retrofit implementation of remote data source
/// 
/// Why Retrofit?
/// 1. Type-safe API calls
/// 2. Code generation (no manual parsing)
/// 3. Interceptors support
/// 4. Error handling
/// 
/// Interview Q: Retrofit vs manual Dio?
/// Retrofit:
/// - Less boilerplate
/// - Type safe
/// - Generated code
/// 
/// Manual Dio:
/// - More control
/// - Dynamic endpoints
/// - Custom parsing
@injectable
@RestApi(baseUrl: '') // Base URL set in Dio instance
abstract class AuthRemoteDataSource implements IAuthRemoteDataSource {
  @factoryMethod
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;
  
  @override
  @POST('/auth/login')
  Future<AuthResponseModel> login({
    @Field() required String email,
    @Field() required String password,
  });
  
  @override
  @POST('/auth/register')
  Future<AuthResponseModel> register({
    @Field() required String email,
    @Field() required String password,
    @Field() required String name,
  });
  
  @override
  @POST('/auth/logout')
  Future<void> logout(@Header('Authorization') String token);
  
  @override
  @GET('/auth/me')
  Future<UserModel> getCurrentUser(
    @Header('Authorization') String token,
  );
}
```

```dart
// lib/features/authentication/data/datasources/auth_local_datasource.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

/// Local Data Source for caching auth data
/// 
/// Responsibilities:
/// 1. Store/retrieve auth token
/// 2. Cache user data
/// 3. Check if user is logged in
/// 
/// Why Secure Storage?
/// - Encrypted storage
/// - Safe for tokens, passwords
/// - Platform-specific (Keychain/KeyStore)
/// 
/// Interview Q: Secure Storage vs Shared Preferences?
/// Secure Storage:
/// - Encrypted
/// - For sensitive data
/// - Slower
/// 
/// Shared Preferences:
/// - Plain text
/// - For non-sensitive data
/// - Faster
@injectable
class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  
  // Storage keys
  static const _tokenKey = 'auth_token';
  static const _userKey = 'cached_user';
  
  AuthLocalDataSource(this._secureStorage);
  
  /// Save authentication token
  /// 
  /// Called after successful login/register
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }
  
  /// Get saved token
  /// 
  /// Returns null if no token stored
  /// Used to check if user is logged in
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  /// Delete token (logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
  
  /// Cache user data
  /// 
  /// Why cache?
  /// - Offline access
  /// - Faster app start
  /// - Reduce API calls
  Future<void> cacheUser(UserModel user) async {
    final json = user.toJson();
    await _secureStorage.write(
      key: _userKey,
      value: jsonEncode(json),
    );
  }
  
  /// Get cached user
  /// 
  /// Returns null if no cached user
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = await _secureStorage.read(key: _userKey);
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      // If parsing fails, delete corrupted data
      await _secureStorage.delete(key: _userKey);
      return null;
    }
  }
  
  /// Clear all cached data
  Future<void> clearCache() async {
    await _secureStorage.deleteAll();
  }
}
```

**Repository Implementation:**

```dart
// lib/features/authentication/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Authentication Repository Implementation
/// 
/// Responsibility:
/// 1. Coordinate between local and remote data sources
/// 2. Handle errors and convert to Failures
/// 3. Implement caching strategy
/// 4. Convert Models to Entities
/// 
/// Interview Q: Why this layer?
/// - Abstracts data sources from domain
/// - Handles offline/online logic
/// - Converts exceptions to domain failures
@Injectable(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    // Check network connectivity
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      // Call remote data source
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      
      // Cache token and user
      await _localDataSource.saveToken(response.token);
      await _localDataSource.cacheUser(response.user);
      
      // Convert model to entity and return
      return Right(response.user.toEntity());
      
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
      
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
      
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      
      await _localDataSource.saveToken(response.token);
      await _localDataSource.cacheUser(response.user);
      
      return Right(response.user.toEntity());
      
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
      
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
      
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _localDataSource.getToken();
      
      if (token != null && await _networkInfo.isConnected) {
        // Try to logout on server
        await _remoteDataSource.logout('Bearer $token');
      }
      
      // Always clear local data
      await _localDataSource.clearCache();
      
      return const Right(null);
      
    } catch (e) {
      // Even if API fails, clear local data
      await _localDataSource.clearCache();
      return const Right(null);
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get cached user first (offline support)
      final cachedUser = await _localDataSource.getCachedUser();
      
      // If offline, return cached user
      if (!await _networkInfo.isConnected) {
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        return Left(CacheFailure('No cached user'));
      }
      
      // If online, fetch from server
      final token = await _localDataSource.getToken();
      if (token == null) {
        return Left(AuthFailure('No auth token'));
      }
      
      final user = await _remoteDataSource.getCurrentUser('Bearer $token');
      
      // Update cache
      await _localDataSource.cacheUser(user);
      
      return Right(user.toEntity());
      
    } on ServerException catch (e) {
      // If server fails but have cached user, return it
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return Left(ServerFailure(e.message));
      
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Stream<User?> get authStateChanges {
    // Implementation using StreamController
    // Will emit user on login, null on logout
    // (Implementation details in separate file)
  }
}
```

**Interview Questions for Data Layer:**

**Q1: Explain the Model-Entity separation**
```dart
// Entity (Domain Layer)
class User {
  final String id;
  final String name;
  // No JSON, no database concerns
}

// Model (Data Layer)
@freezed
class UserModel with _$UserModel {
  factory UserModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  
  User toEntity() {...} // Conversion to domain
}

// Why?
// 1. Domain independent of data format
// 2. Can change API without affecting business logic
// 3. Can have multiple models for same entity (REST vs GraphQL)
```

**Q2: How do you handle offline-first architecture?**
```dart
@override
Future<Either<Failure, User>> getCurrentUser() async {
  // Step 1: Check cache
  final cached = await _localDataSource.getCachedUser();
  
  // Step 2: If offline, return cached
  if (!await _networkInfo.isConnected) {
    return cached != null 
      ? Right(cached.toEntity())
      : Left(CacheFailure());
  }
  
  // Step 3: Fetch from network
  try {
    final user = await _remoteDataSource.getCurrentUser();
    
    // Step 4: Update cache
    await _localDataSource.cacheUser(user);
    
    return Right(user.toEntity());
  } catch (e) {
    // Step 5: Fallback to cache if network fails
    return cached != null
      ? Right(cached.toEntity())
      : Left(ServerFailure());
  }
}
```

**Deliverable:** Complete Data layer with unit tests

---

### Module 2.3: Presentation Layer with BLoC (Days 12-14)

**Files:**
```
lib/features/authentication/presentation/
├── bloc/
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   └── auth_state.dart
├── pages/
│   ├── login_page.dart
│   ├── register_page.dart
│   └── splash_page.dart
└── widgets/
    ├── auth_text_field.dart
    ├── auth_button.dart
    └── social_login_buttons.dart
```

**COMPLETE BLoC Implementation:**

```dart
// lib/features/authentication/presentation/bloc/auth_event.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Authentication Events
/// 
/// Why Freezed for events?
/// 1. Union types (one event class with multiple types)
/// 2. Pattern matching
/// 3. Immutability
/// 4. Less boilerplate
/// 
/// Interview Q: Event vs Method?
/// Events:
/// - Declarative (WHAT happened)
/// - Immutable
/// - Can be logged/replayed
/// 
/// Methods:
/// - Imperative (DO this)
/// - Direct calls
@freezed
class AuthEvent with _$AuthEvent {
  /// User initiated login
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = LoginRequested;
  
  /// User initiated registration
  const factory AuthEvent.registerRequested({
    required String email,
    required String password,
    required String name,
  }) = RegisterRequested;
  
  /// User initiated logout
  const factory AuthEvent.logoutRequested() = LogoutRequested;
  
  /// Check if user is already logged in
  /// (Called on app start)
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
}
```

```dart
// lib/features/authentication/presentation/bloc/auth_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Authentication States
/// 
/// Why sealed class (union type)?
/// 1. Exhaustive pattern matching
/// 2. Compiler enforces handling all cases
/// 3. Type-safe state management
/// 
/// Interview Q: Why not just isLoading + user + error?
/// Union types are clearer:
/// - Initial OR Loading OR Success OR Failure
/// - Not all combinations valid
/// - Compiler helps catch bugs
@freezed
class AuthState with _$AuthState {
  /// Initial state (app just started)
  const factory AuthState.initial() = Initial;
  
  /// Loading (API call in progress)
  const factory AuthState.loading() = Loading;
  
  /// Authenticated (user logged in)
  const factory AuthState.authenticated({
    required User user,
  }) = Authenticated;
  
  /// Unauthenticated (no user)
  const factory AuthState.unauthenticated() = Unauthenticated;
  
  /// Error (login/register failed)
  const factory AuthState.error({
    required String message,
  }) = Error;
}
```

```dart
// lib/features/authentication/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
/// 
/// Responsibility:
/// 1. Handle authentication events
/// 2. Call use cases
/// 3. Emit appropriate states
/// 4. Handle errors
/// 
/// Why BLoC?
/// 1. Separation of business logic from UI
/// 2. Testable (unit test without widgets)
/// 3. Reactive (Stream-based)
/// 4. Reusable across platforms
/// 
/// Interview Q: BLoC vs Provider vs Riverpod?
/// BLoC:
/// - Best for complex logic
/// - Stream-based
/// - More boilerplate
/// - Great for large teams
/// 
/// Provider:
/// - Simpler
/// - Good for small apps
/// - Less boilerplate
/// 
/// Riverpod:
/// - Modern Provider
/// - Compile-time safety
/// - Better testability
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;
  
  AuthBloc(
    this._login,
    this._register,
    this._logout,
    this._getCurrentUser,
  ) : super(const AuthState.initial()) {
    // Register event handlers
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  
  /// Handle login event
  /// 
  /// Flow:
  /// 1. Emit loading state
  /// 2. Call login use case
  /// 3. Emit success or error state
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Emit loading (UI shows progress indicator)
    emit(const AuthState.loading());
    
    // Call use case
    final result = await _login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    // Handle result using fold (functional programming)
    result.fold(
      // Left side (failure)
      (failure) {
        emit(AuthState.error(
          message: _mapFailureToMessage(failure),
        ));
      },
      // Right side (success)
      (user) {
        emit(AuthState.authenticated(user: user));
      },
    );
  }
  
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await _register(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthState.error(
        message: _mapFailureToMessage(failure),
      )),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    await _logout(const NoParams());
    
    emit(const AuthState.unauthenticated());
  }
  
  /// Check auth status on app start
  /// 
  /// Flow:
  /// 1. Try to get current user from cache/token
  /// 2. If found, emit authenticated
  /// 3. If not found, emit unauthenticated
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await _getCurrentUser(const NoParams());
    
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }
  
  /// Map domain failures to user-friendly messages
  /// 
  /// Why this method?
  /// - Domain failures are technical
  /// - Users need friendly messages
  /// - Centralized error message logic
  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      network: () => 'No internet connection',
      server: (msg) => msg ?? 'Server error occurred',
      validation: (msg) => msg,
      cache: (msg) => 'Local data error',
      auth: (msg) => msg ?? 'Authentication failed',
      unknown: (msg) => 'An unexpected error occurred',
    );
  }
}
```

**UI Implementation:**

```dart
// lib/features/authentication/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

/// Login Page
/// 
/// Responsibilities:
/// 1. Collect user input
/// 2. Dispatch events to BLoC
/// 3. React to state changes
/// 4. Navigate on success
/// 
/// Why StatefulWidget?
/// - Need TextEditingControllers
/// - Need to dispose controllers
/// 
/// Interview Q: When StatefulWidget vs StatelessWidget?
/// Stateful:
/// - Mutable state (controllers, focus nodes)
/// - Lifecycle methods needed
/// - Animation controllers
/// 
/// Stateless:
/// - Immutable
/// - Gets data from parent/BLoC
/// - Most widgets should be stateless
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  
  /// Why late?
  /// - Initialized in initState (not at declaration)
  /// - Non-nullable but can't initialize immediately
  /// - Compiler ensures initialization before use
  
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }
  
  @override
  void dispose() {
    // Critical: Always dispose to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        /// Why BlocConsumer?
        /// - Combines BlocListener + BlocBuilder
        /// - Listen for side effects (navigation, snackbar)
        /// - Build UI based on state
        /// 
        /// vs BlocBuilder:
        /// - Only rebuilds UI
        /// - No side effects
        /// 
        /// vs BlocListener:
        /// - Only side effects
        /// - No UI rebuild
        
        listener: (context, state) {
          // Handle side effects
          state.maybeWhen(
            authenticated: (user) {
              // Navigate to home on success
              Navigator.of(context).pushReplacementNamed('/home');
            },
            error: (message) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red,
                ),
              );
            },
            orElse: () {},
          );
        },
        
        builder: (context, state) {
          // Build UI based on state
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  const FlutterLogo(size: 100),
                  const SizedBox(height: 48),
                  
                  // Title
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Email field
                  AuthTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Move to password field when done
                      _passwordFocus.requestFocus();
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password field
                  AuthTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    labelText: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (!isLoading) _handleLogin();
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  
                  // Login button
                  AuthButton(
                    onPressed: isLoading ? null : _handleLogin,
                    isLoading: isLoading,
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Register link
                  TextButton(
                    onPressed: isLoading ? null : () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _handleLogin() {
    // Unfocus keyboard
    FocusScope.of(context).unfocus();
    
    // Dispatch event to BLoC
    context.read<AuthBloc>().add(
      AuthEvent.loginRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
```

**Interview Questions for Presentation Layer:**

**Q1: Why use BLoC pattern?**
```dart
// Without BLoC:
class LoginPage extends StatefulWidget {
  @override
  Widget build() {
    return ElevatedButton(
      onPressed: () async {
        setState(() => isLoading = true);
        try {
          final user = await api.login(); // ❌ Business logic in UI
          Navigator.push(...);
        } catch (e) {
          showError(e);
        }
        setState(() => isLoading = false);
      },
    );
  }
}

// With BLoC:
class LoginPage extends StatelessWidget {
  Widget build() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) => Navigator.push(...), // ✅ Side effects
          orElse: () {},
        );
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add( // ✅ Just dispatch event
              AuthEvent.loginRequested(...),
            );
          },
        );
      },
    );
  }
}

// Benefits:
// 1. UI is just a presentation
// 2. Logic in BLoC (testable)
// 3. Reusable across platforms
// 4. Clear separation
```

**Q2: BlocConsumer vs BlocBuilder vs BlocListener?**
```dart
// BlocBuilder: Just rebuild UI
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is Loading) return CircularProgressIndicator();
    return LoginForm();
  },
);

// BlocListener: Just side effects (no rebuild)
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Error) showSnackBar(state.message);
    if (state is Authenticated) navigateToHome();
  },
  child: LoginForm(), // This doesn't rebuild
);

// BlocConsumer: Both
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    // UI rebuild
  },
);

// When to use which?
// - BlocBuilder: Just UI changes
// - BlocListener: Navigation, dialogs, snackbars
// - BlocConsumer: Both needed (most common)
```

---

## Coverage Tracking

**Week 1-2 Topics Covered:**
- ✅ Clean Architecture (3 layers)
- ✅ Dependency Injection (GetIt + Injectable)
- ✅ BLoC Pattern
- ✅ UseCase Pattern
- ✅ Repository Pattern
- ✅ Error Handling (Either)
- ✅ Freezed (immutable models)
- ✅ Retrofit (type-safe APIs)
- ✅ Secure Storage
- ✅ Code Generation
- ✅ CI/CD (GitHub Actions)
- ✅ Unit Testing
- ✅ Widget Testing
- ✅ Flutter Flavors

**Remaining Topics:** ~136

**Next Week Focus:** Chat Module (WebSocket, Real-time, Custom Widgets)

---

## Next Steps

This is the complete foundation. Shall I:

1. **Continue with Week 3** (Chat Module - Real-time messaging)?
2. **Deep dive into testing** for what we've built?
3. **Add alternative implementations** (e.g., Riverpod version)?
4. **Create interview prep materials** for these topics?

**Your choice - what would you like to focus on next?**
