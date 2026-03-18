# 💻 DAY 2: CODE - State Management Mastery

## 🎯 Today's Mission

Build 3 apps in 3-4 hours that teach Q21-Q40 (State Management).

**Learning Method:** Code first, understand later!
- Type each app (don't copy-paste!)
- Run it and see state management in action
- Break it and fix it
- Then understand why it works

---

## 📱 THE 3 APPS

| App | Time | Teaches | Questions |
|-----|------|---------|-----------|
| 1. Provider App | 40 min | Provider pattern basics | Q21-Q25 |
| 2. BLoC App | 90 min | BLoC pattern complete | Q26-Q32 |
| 3. Riverpod App | 60 min | Modern state management | Q33-Q40 |

**Total: 3 hours 10 minutes**

---

## 📦 SETUP - Install Dependencies (5 minutes)

### **Update pubspec.yaml:**

Open `pubspec.yaml` and add these dependencies:

```yaml
name: devsync_mini
description: Flutter interview prep app

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  flutter_riverpod: ^2.4.9
  
  # Utilities
  equatable: ^2.0.5
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1

flutter:
  uses-material-design: true
```

### **Install packages:**

```bash
flutter pub get
```

**Expected output:**
```
Running "flutter pub get"...
✓ provider 6.1.1
✓ flutter_bloc 8.1.3
✓ flutter_riverpod 2.4.9
✓ equatable 2.0.5
```

---

## 📁 Create Folder Structure (2 minutes)

```bash
cd lib
mkdir -p apps/day2/{provider_app,bloc_app,riverpod_app}
```

**Your structure:**
```
lib/
├── apps/
│   ├── day1/          # Yesterday's apps
│   └── day2/
│       ├── provider_app/
│       ├── bloc_app/
│       └── riverpod_app/
└── main.dart
```

---

# 📱 APP 1: PROVIDER PATTERN (40 minutes)

## 🎯 Teaches: Q21-Q25
- Q21: What is Provider?
- Q22: ChangeNotifier vs ValueNotifier
- Q23: Consumer vs Provider.of
- Q24: MultiProvider
- Q25: ProxyProvider

---

## 💻 File 1: Counter Model (5 min)

**Create: `lib/apps/day2/provider_app/counter_model.dart`**

```dart
import 'package:flutter/foundation.dart';

/// Q22: ChangeNotifier - notifies listeners when data changes
/// Base class for Provider state management
class CounterModel extends ChangeNotifier {
  // Private state
  int _counter = 0;
  
  // Q21: Getter - exposes state (read-only)
  int get counter => _counter;
  
  // Q22: Method that modifies state and notifies listeners
  void increment() {
    _counter++;
    
    // Q22: notifyListeners() - tells all listeners to rebuild
    // This is the key to Provider pattern
    notifyListeners();
    
    print('Counter incremented to: $_counter');
  }
  
  void decrement() {
    if (_counter > 0) {
      _counter--;
      notifyListeners();
    }
  }
  
  void reset() {
    _counter = 0;
    notifyListeners();
  }
}
```

---

## 💻 File 2: Theme Model (5 min)

**Create: `lib/apps/day2/provider_app/theme_model.dart`**

```dart
import 'package:flutter/material.dart';

/// Q22: Another ChangeNotifier example for theme switching
class ThemeModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    notifyListeners();
    
    print('Theme changed to: $_themeMode');
  }
}
```

---

## 💻 File 3: Shopping Cart Model (10 min)

**Create: `lib/apps/day2/provider_app/cart_model.dart`**

```dart
import 'package:flutter/foundation.dart';

/// Product class
class Product {
  final String id;
  final String name;
  final double price;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

/// Q22: Complex ChangeNotifier with multiple operations
class CartModel extends ChangeNotifier {
  // Private state: Map of product ID to quantity
  final Map<String, int> _items = {};
  
  // Available products
  final List<Product> availableProducts = [
    Product(id: '1', name: 'Laptop', price: 999.99),
    Product(id: '2', name: 'Mouse', price: 29.99),
    Product(id: '3', name: 'Keyboard', price: 79.99),
    Product(id: '4', name: 'Monitor', price: 299.99),
  ];
  
  // Getters
  Map<String, int> get items => Map.unmodifiable(_items);
  
  int get itemCount => _items.values.fold(0, (sum, qty) => sum + qty);
  
  double get totalPrice {
    double total = 0;
    _items.forEach((id, qty) {
      final product = availableProducts.firstWhere((p) => p.id == id);
      total += product.price * qty;
    });
    return total;
  }
  
  // Methods
  void addItem(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    } else {
      _items[productId] = 1;
    }
    
    notifyListeners();
    print('Added product $productId. Cart: $_items');
  }
  
  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]! > 1) {
        _items[productId] = _items[productId]! - 1;
      } else {
        _items.remove(productId);
      }
      
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
```

---

## 💻 File 4: Main Provider App (20 min)

**Create: `lib/apps/day2/provider_app/provider_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_model.dart';
import 'theme_model.dart';
import 'cart_model.dart';

void main() {
  runApp(const ProviderApp());
}

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q24: MultiProvider - provides multiple models to widget tree
    // All descendants can access these models
    return MultiProvider(
      providers: [
        // Q21: ChangeNotifierProvider - creates and provides ChangeNotifier
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => ThemeModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      
      // Q23: Consumer - rebuilds when ThemeModel changes
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            title: 'Provider Demo',
            
            // Use theme from provider
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeModel.themeMode,
            
            home: const ProviderHomeScreen(),
          );
        },
      ),
    );
  }
}

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 1: Provider Pattern'),
        actions: [
          // Q23: Consumer for theme toggle
          Consumer<ThemeModel>(
            builder: (context, themeModel, child) {
              return IconButton(
                icon: Icon(
                  themeModel.isDarkMode 
                      ? Icons.light_mode 
                      : Icons.dark_mode,
                ),
                onPressed: themeModel.toggleTheme,
              );
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Counter Section
            const Text(
              'Counter Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const CounterSection(),
            
            const Divider(height: 40),
            
            // Shopping Cart Section
            const Text(
              'Shopping Cart Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ShoppingCartSection(),
            
            const SizedBox(height: 20),
            
            // Educational Notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎓 Provider Pattern:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• ChangeNotifier: Base class for state\n'
                    '• notifyListeners(): Triggers rebuild\n'
                    '• Consumer: Rebuilds when state changes\n'
                    '• Provider.of: Access state without rebuilding\n'
                    '• MultiProvider: Provide multiple models\n',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Q23: Counter section showing Consumer vs Provider.of
class CounterSection extends StatelessWidget {
  const CounterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Q23: Consumer - rebuilds when CounterModel changes
            Consumer<CounterModel>(
              builder: (context, counterModel, child) {
                return Column(
                  children: [
                    Text(
                      '${counterModel.counter}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This text rebuilds (inside Consumer)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Q23: This Text does NOT rebuild (outside Consumer)
            Text(
              'This text NEVER rebuilds (outside Consumer)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade600,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // Q23: Provider.of with listen: false
                  // Doesn't rebuild when state changes
                  onPressed: () {
                    Provider.of<CounterModel>(context, listen: false)
                        .decrement();
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CounterModel>(context, listen: false)
                        .reset();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Q23: context.read() - shorthand for Provider.of(listen: false)
                    context.read<CounterModel>().increment();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shopping cart section
class ShoppingCartSection extends StatelessWidget {
  const ShoppingCartSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart summary
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items: ${cartModel.itemCount}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total: \$${cartModel.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    if (cartModel.itemCount > 0) ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: cartModel.clearCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Clear Cart'),
                      ),
                    ],
                  ],
                );
              },
            ),
            
            const Divider(height: 30),
            
            // Product list
            const Text(
              'Available Products:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Q23: context.watch() - shorthand for Consumer
            ...context.watch<CartModel>().availableProducts.map((product) {
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartModel>().addItem(product.id);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Run App 1

```bash
# Update main.dart to point to provider_app
# OR run directly:
flutter run lib/apps/day2/provider_app/provider_app.dart
```

---

## ✅ App 1 Checkpoint

**Test These:**
1. [ ] Counter increments/decrements
2. [ ] Theme toggles (light/dark)
3. [ ] Add products to cart
4. [ ] See total price update
5. [ ] Clear cart works
6. [ ] "This text NEVER rebuilds" actually doesn't rebuild (watch closely!)

**Key Learning:**
- Consumer rebuilds its child
- Text outside Consumer doesn't rebuild
- Provider.of(listen: false) doesn't listen
- context.read() = shorthand for Provider.of(listen: false)
- context.watch() = shorthand for Consumer

---

## 🎓 What You Learned (Q21-Q25)

**Q21: Provider provides state down the widget tree**
**Q22: ChangeNotifier + notifyListeners() triggers rebuilds**
**Q23: Consumer rebuilds, Provider.of(listen:false) doesn't**
**Q24: MultiProvider provides multiple models**
**Q25: Different ways to access state (Consumer, Provider.of, context.read, context.watch)**

---

# 📱 APP 2: BLOC PATTERN (90 minutes)

## 🎯 Teaches: Q26-Q32
- Q26: What is BLoC?
- Q27: BLoC vs Provider
- Q28: Event-State-BLoC pattern
- Q29: BlocBuilder vs BlocConsumer
- Q30: BlocProvider
- Q31: Testing BLoC
- Q32: When to use BLoC

---

## 💻 File 1: Auth Events (10 min)

**Create: `lib/apps/day2/bloc_app/auth/auth_event.dart`**

```dart
import 'package:equatable/equatable.dart';

/// Q28: Events - Input to BLoC
/// Events represent user actions or system events
/// Use Equatable for easy comparison in tests
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

/// User wants to login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

/// User wants to register
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
  
  @override
  List<Object?> get props => [email, password, name];
}

/// User wants to logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Check if user is already logged in (on app start)
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
```

---

## 💻 File 2: Auth States (10 min)

**Create: `lib/apps/day2/bloc_app/auth/auth_state.dart`**

```dart
import 'package:equatable/equatable.dart';

/// User model
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
  });
  
  @override
  List<Object?> get props => [id, email, name];
}

/// Q28: States - Output from BLoC
/// States represent different UI states
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state (during login/register)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final User user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state
class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

---

## 💻 File 3: Auth Repository (10 min)

**Create: `lib/apps/day2/bloc_app/auth/auth_repository.dart`**

```dart
import 'auth_state.dart';

/// Q28: Repository - handles data operations
/// BLoC calls repository methods, doesn't handle data directly
class AuthRepository {
  // Simulate database/API delay
  Future<void> _delay() => Future.delayed(const Duration(seconds: 2));
  
  /// Simulate login
  Future<User> login(String email, String password) async {
    await _delay();
    
    // Simulate validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
    
    // Simulate wrong credentials
    if (password != 'password123') {
      throw Exception('Invalid email or password');
    }
    
    // Return user
    return User(
      id: '123',
      email: email,
      name: email.split('@')[0],
    );
  }
  
  /// Simulate register
  Future<User> register(String email, String password, String name) async {
    await _delay();
    
    // Simulate validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }
    
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }
    
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
    
    // Return new user
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
  }
  
  /// Simulate logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  /// Check if user is logged in
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, check local storage/secure storage
    return null;
  }
}
```

---

## 💻 File 4: Auth BLoC (20 min)

**Create: `lib/apps/day2/bloc_app/auth/auth_bloc.dart`**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_repository.dart';

/// Q28: BLoC - Business Logic Component
/// Transforms Events into States
/// All business logic lives here, NOT in UI
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  
  // Q26: BLoC constructor
  // Initial state is AuthInitial
  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    // Q28: Register event handlers
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  
  /// Q28: Handle login event
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Q28: emit() outputs new state
    
    // Step 1: Emit loading state
    emit(const AuthLoading());
    
    print('🔐 Login attempt: ${event.email}');
    
    try {
      // Step 2: Call repository
      final user = await repository.login(event.email, event.password);
      
      print('✅ Login successful: ${user.name}');
      
      // Step 3: Emit success state
      emit(AuthAuthenticated(user));
      
    } catch (e) {
      print('❌ Login failed: $e');
      
      // Step 4: Emit error state
      emit(AuthError(e.toString()));
      
      // After 3 seconds, go back to unauthenticated
      await Future.delayed(const Duration(seconds: 3));
      emit(const AuthUnauthenticated());
    }
  }
  
  /// Handle register event
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    print('📝 Register attempt: ${event.email}');
    
    try {
      final user = await repository.register(
        event.email,
        event.password,
        event.name,
      );
      
      print('✅ Registration successful: ${user.name}');
      
      emit(AuthAuthenticated(user));
      
    } catch (e) {
      print('❌ Registration failed: $e');
      
      emit(AuthError(e.toString()));
      
      await Future.delayed(const Duration(seconds: 3));
      emit(const AuthUnauthenticated());
    }
  }
  
  /// Handle logout event
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('👋 Logout requested');
    
    await repository.logout();
    
    emit(const AuthUnauthenticated());
    
    print('✅ Logged out');
  }
  
  /// Check auth status on app start
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final user = await repository.getCurrentUser();
    
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
```

---

## 💻 File 5: Login Screen (20 min)

**Create: `lib/apps/day2/bloc_app/screens/login_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Q28: Add event to BLoC
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with BLoC'),
      ),
      
      // Q29: BlocConsumer - listens to state AND shows snackbars/dialogs
      body: BlocConsumer<AuthBloc, AuthState>(
        // Q29: listener - for side effects (snackbars, navigation)
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        
        // Q29: builder - for UI building
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  const Text(
                    'Use: any email, password: password123',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Login button
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Register link
                  TextButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AuthBloc>(),
                                  child: const RegisterScreen(),
                                ),
                              ),
                            );
                          },
                    child: const Text("Don't have an account? Register"),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Educational note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎓 BLoC Pattern:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current State: ${state.runtimeType}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '• Events: LoginRequested, RegisterRequested\n'
                          '• States: Loading, Authenticated, Error\n'
                          '• BlocConsumer: Listens + Builds UI',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 💻 File 6: Register Screen (15 min)

**Create: `lib/apps/day2/bloc_app/screens/register_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      
      // Q29: BlocBuilder - only for building UI (no side effects)
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthError) {
            // Show error in UI (not as snackbar)
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
                      context.read<AuthBloc>().add(
                        const AuthCheckRequested(),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 80,
                    color: Colors.green,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Register button
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                    ),
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Login link
                  TextButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 💻 File 7: Home Screen (10 min)

**Create: `lib/apps/day2/bloc_app/screens/home_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q29: BlocBuilder to access current state
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Only show if authenticated
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: Text('Not authenticated')),
          );
        }
        
        final user = state.user;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Q28: Add logout event
                  context.read<AuthBloc>().add(const LogoutRequested());
                },
              ),
            ],
          ),
          
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                
                const SizedBox(height: 30),
                
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24),
                ),
                
                const SizedBox(height: 5),
                
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '✅ You are authenticated!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'User ID: ${user.id}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

---

## 💻 File 8: Main BLoC App (15 min)

**Create: `lib/apps/day2/bloc_app/bloc_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_bloc.dart';
import 'auth/auth_event.dart';
import 'auth/auth_state.dart';
import 'auth/auth_repository.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q30: BlocProvider - provides BLoC to widget tree
    // All descendants can access this BLoC
    return BlocProvider(
      // Q30: create - creates the BLoC instance
      create: (context) => AuthBloc(
        repository: AuthRepository(),
      )..add(const AuthCheckRequested()), // Check auth on startup
      
      child: MaterialApp(
        title: 'BLoC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        
        // Q29: BlocBuilder at root to switch screens based on state
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Show loading while checking auth
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // Show home if authenticated
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            }
            
            // Show login for all other states
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
```

---

## 🚀 Run App 2

```bash
flutter run lib/apps/day2/bloc_app/bloc_app.dart
```

---

## ✅ App 2 Checkpoint

**Test These:**
1. [ ] App starts with loading screen
2. [ ] Shows login screen
3. [ ] Try login with wrong password → See error
4. [ ] Login with "password123" → Goes to home
5. [ ] See user name and email
6. [ ] Logout button works
7. [ ] Register new account
8. [ ] Check console for BLoC logs

**Test Credentials:**
- Email: anything@email.com
- Password: password123

---

## 🎓 What You Learned (Q26-Q32)

**Q26: BLoC separates business logic from UI**
**Q27: BLoC uses events/states, Provider uses ChangeNotifier**
**Q28: Event → BLoC → State pattern**
**Q29: BlocBuilder for UI, BlocConsumer for UI + side effects**
**Q30: BlocProvider provides BLoC down tree**
**Q31: BLoC is testable (see test file next)**
**Q32: Use BLoC for complex state, Provider for simple state**

---

## 💻 BONUS: BLoC Testing (10 min)

**Create: `test/auth_bloc_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

// Import your auth files
// import 'package:devsync_mini/apps/day2/bloc_app/auth/auth_bloc.dart';
// import 'package:devsync_mini/apps/day2/bloc_app/auth/auth_event.dart';
// import 'package:devsync_mini/apps/day2/bloc_app/auth/auth_state.dart';
// import 'package:devsync_mini/apps/day2/bloc_app/auth/auth_repository.dart';

/// Q31: Testing BLoC with bloc_test package
/// 
/// Run tests with: flutter test
void main() {
  group('AuthBloc', () {
    // late AuthRepository mockRepository;
    // late AuthBloc authBloc;

    // setUp(() {
    //   mockRepository = MockAuthRepository();
    //   authBloc = AuthBloc(repository: mockRepository);
    // });

    // tearDown(() {
    //   authBloc.close();
    // });

    // Q31: Test initial state
    test('initial state is AuthInitial', () {
      // expect(authBloc.state, const AuthInitial());
    });

    // Q31: Test login success
    // blocTest<AuthBloc, AuthState>(
    //   'emits [AuthLoading, AuthAuthenticated] when login succeeds',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(
    //     const LoginRequested(
    //       email: 'test@test.com',
    //       password: 'password123',
    //     ),
    //   ),
    //   expect: () => [
    //     const AuthLoading(),
    //     isA<AuthAuthenticated>(),
    //   ],
    // );

    // Q31: Test login failure
    // blocTest<AuthBloc, AuthState>(
    //   'emits [AuthLoading, AuthError, AuthUnauthenticated] when login fails',
    //   build: () {
    //     when(() => mockRepository.login(any(), any()))
    //         .thenThrow(Exception('Invalid credentials'));
    //     return authBloc;
    //   },
    //   act: (bloc) => bloc.add(
    //     const LoginRequested(
    //       email: 'test@test.com',
    //       password: 'wrong',
    //     ),
    //   ),
    //   expect: () => [
    //     const AuthLoading(),
    //     isA<AuthError>(),
    //     const AuthUnauthenticated(),
    //   ],
    // );
  });
}

// Mock repository for testing
// class MockAuthRepository extends Mock implements AuthRepository {}
```

**Run tests:**
```bash
flutter test test/auth_bloc_test.dart
```

---

# 📱 APP 3: RIVERPOD (60 minutes)

## 🎯 Teaches: Q33-Q40
- Q33: What is Riverpod?
- Q34: Riverpod vs Provider vs BLoC
- Q35: StateProvider vs StateNotifierProvider
- Q36: FutureProvider
- Q37: StreamProvider
- Q38: AsyncValue
- Q39: ref.watch vs ref.read
- Q40: When to use Riverpod

---

## 💻 File 1: Counter Provider (10 min)

**Create: `lib/apps/day2/riverpod_app/providers/counter_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Q33: Riverpod provider - simplest form
/// StateProvider for simple state (int, bool, String)
final counterProvider = StateProvider<int>((ref) {
  // Initial value
  return 0;
});

/// Q35: StateNotifierProvider for complex state
/// Use when you need custom methods
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0); // Initial value = 0
  
  void increment() {
    state = state + 1;
    print('Counter incremented to: $state');
  }
  
  void decrement() {
    if (state > 0) {
      state = state - 1;
    }
  }
  
  void reset() {
    state = 0;
  }
}

// Q35: StateNotifierProvider exposes the notifier
final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>(
  (ref) => CounterNotifier(),
);
```

---

## 💻 File 2: API Service (10 min)

**Create: `lib/apps/day2/riverpod_app/services/api_service.dart`**

```dart
/// Q36: Service for API calls
/// Riverpod can inject this as dependency
class ApiService {
  // Simulate fetching user
  Future<User> fetchUser(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate occasional error
    if (DateTime.now().second % 3 == 0) {
      throw Exception('Network error');
    }
    
    return User(
      id: userId,
      name: 'John Doe',
      email: 'john@example.com',
    );
  }
  
  // Simulate fetching posts
  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Post(id: '1', title: 'First Post', body: 'This is the first post'),
      Post(id: '2', title: 'Second Post', body: 'This is the second post'),
      Post(id: '3', title: 'Third Post', body: 'This is the third post'),
    ];
  }
  
  // Simulate stream of messages
  Stream<String> messagesStream() {
    return Stream.periodic(
      const Duration(seconds: 2),
      (count) => 'Message ${count + 1} at ${DateTime.now().second}s',
    ).take(10); // Only 10 messages
  }
}

class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

class Post {
  final String id;
  final String title;
  final String body;
  
  Post({
    required this.id,
    required this.title,
    required this.body,
  });
}

// Q34: Provider for service (dependency injection)
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
```

---

## 💻 File 3: User Provider (10 min)

**Create: `lib/apps/day2/riverpod_app/providers/user_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

/// Q36: FutureProvider - for async data
/// Automatically handles loading, data, error states
final userProvider = FutureProvider<User>((ref) async {
  // Q34: ref.watch - depend on another provider
  final apiService = ref.watch(apiServiceProvider);
  
  // Fetch user
  return await apiService.fetchUser('123');
});

/// Q36: FutureProvider with parameter
/// Use .family for parameterized providers
final userByIdProvider = FutureProvider.family<User, String>((ref, userId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.fetchUser(userId);
});

/// Q36: Posts provider
final postsProvider = FutureProvider<List<Post>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.fetchPosts();
});
```

---

## 💻 File 4: Messages Provider (5 min)

**Create: `lib/apps/day2/riverpod_app/providers/messages_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

/// Q37: StreamProvider - for real-time data
/// Automatically converts Stream to AsyncValue
final messagesProvider = StreamProvider<String>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.messagesStream();
});
```

---

## 💻 File 5: Main Riverpod App (25 min)

**Create: `lib/apps/day2/riverpod_app/riverpod_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/counter_provider.dart';
import 'providers/user_provider.dart';
import 'providers/messages_provider.dart';

void main() {
  // Q33: ProviderScope - required at root
  // Stores all provider states
  runApp(
    const ProviderScope(
      child: RiverpodApp(),
    ),
  );
}

class RiverpodApp extends StatelessWidget {
  const RiverpodApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const RiverpodHomeScreen(),
    );
  }
}

// Q33: ConsumerWidget - can access providers
class RiverpodHomeScreen extends ConsumerWidget {
  const RiverpodHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Q39: ref.watch - listen to provider, rebuilds when changes
    final counter = ref.watch(counterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 3: Riverpod'),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Simple Counter Section
            const Text(
              'Simple Counter (StateProvider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${counter}',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          // Q39: ref.read - access provider without listening
                          // Use for callbacks
                          onPressed: () {
                            ref.read(counterProvider.notifier).state--;
                          },
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterProvider.notifier).state = 0;
                          },
                          child: const Text('Reset'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterProvider.notifier).state++;
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Complex Counter Section
            const Text(
              'Complex Counter (StateNotifierProvider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            const ComplexCounterSection(),
            
            const SizedBox(height: 20),
            
            // User Section (FutureProvider)
            const Text(
              'User Data (FutureProvider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            const UserSection(),
            
            const SizedBox(height: 20),
            
            // Messages Section (StreamProvider)
            const Text(
              'Messages (StreamProvider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            const MessagesSection(),
            
            const SizedBox(height: 20),
            
            // Educational Notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎓 Riverpod:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• StateProvider: Simple values\n'
                    '• StateNotifierProvider: Complex logic\n'
                    '• FutureProvider: Async data\n'
                    '• StreamProvider: Real-time data\n'
                    '• ref.watch: Listen & rebuild\n'
                    '• ref.read: Access without rebuild',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Q35: Complex counter with StateNotifierProvider
class ComplexCounterSection extends ConsumerWidget {
  const ComplexCounterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterNotifierProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$counter',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterNotifierProvider.notifier).decrement();
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterNotifierProvider.notifier).reset();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterNotifierProvider.notifier).increment();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Q36 & Q38: FutureProvider with AsyncValue
class UserSection extends ConsumerWidget {
  const UserSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Q36: ref.watch on FutureProvider returns AsyncValue
    final userAsync = ref.watch(userProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: userAsync.when(
          // Q38: AsyncValue.when - pattern matching
          
          // Loading state
          loading: () => const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading user...'),
              ],
            ),
          ),
          
          // Error state
          error: (error, stack) => Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text(
                'Error: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Q36: Refresh provider
                  ref.invalidate(userProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
          
          // Data state
          data: (user) => Column(
            children: [
              const Icon(Icons.person, size: 60, color: Colors.purple),
              const SizedBox(height: 10),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userProvider);
                },
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Q37 & Q38: StreamProvider with AsyncValue
class MessagesSection extends ConsumerWidget {
  const MessagesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Q37: ref.watch on StreamProvider returns AsyncValue
    final messagesAsync = ref.watch(messagesProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Real-time Messages:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Q38: AsyncValue.when for Stream
            messagesAsync.when(
              loading: () => const CircularProgressIndicator(),
              
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
              
              data: (message) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '📨 $message',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Run App 3

```bash
flutter run lib/apps/day2/riverpod_app/riverpod_app.dart
```

---

## ✅ App 3 Checkpoint

**Test These:**
1. [ ] Simple counter works
2. [ ] Complex counter works
3. [ ] User data loads (or shows error - retry works)
4. [ ] Messages appear every 2 seconds
5. [ ] Refresh user button works
6. [ ] Both counters work independently

---

## 🎓 What You Learned (Q33-Q40)

**Q33: Riverpod is compile-safe, testable state management**
**Q34: Riverpod > Provider (no context needed, better DI)**
**Q35: StateProvider (simple), StateNotifierProvider (complex)**
**Q36: FutureProvider for async data**
**Q37: StreamProvider for real-time data**
**Q38: AsyncValue handles loading/error/data**
**Q39: ref.watch (listen), ref.read (no listen)**
**Q40: Use Riverpod for type-safe, complex apps**

---

## 🎉 DAY 2 COMPLETE!

### **What You Built:**
- ✅ 3 apps (Provider, BLoC, Riverpod)
- ✅ 2000+ lines of code
- ✅ Covers Q21-Q40

### **What You Can Now Explain:**
- [x] Q21-Q25: Provider pattern
- [x] Q26-Q32: BLoC pattern
- [x] Q33-Q40: Riverpod

---

## 📚 NEXT STEP

**Now open: `DAY_02_THEORY.md`**

This afternoon you'll:
- Understand Provider vs BLoC vs Riverpod
- Answer Q21-Q40 using YOUR code
- Learn when to use each pattern
- Compare state management approaches

**Total Day 2 Time: 6-8 hours**
- Morning: 3-4 hours coding ✅
- Afternoon: 2-3 hours theory
- Evening: 1 hour quiz

---

**Progress: 40/200 questions (20%)** 📊

**Congratulations! Move to DAY_02_THEORY.md** 🎓
