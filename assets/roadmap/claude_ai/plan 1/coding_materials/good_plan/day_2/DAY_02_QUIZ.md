# 🧠 DAY 2: QUIZ - State Management Test

## 🎯 Purpose

Test your knowledge of Q21-Q40 (Provider, BLoC, Riverpod) before moving to Day 3.

**Time: 1 hour**
- Theory Quiz: 30 minutes (20 questions)
- Coding Challenges: 30 minutes (3 challenges)

**Scoring:**
- 18-20 correct: Excellent! Ready for Day 3 ✅
- 15-17 correct: Good! Review weak areas
- <15 correct: Review theory again before Day 3

---

## 📝 PART 1: THEORY QUESTIONS (20 questions)

**Answer these WITHOUT looking at your notes:**

### **Q21-Q25: Provider**

**1. What does `notifyListeners()` do in a ChangeNotifier?**
- A) Deletes all listeners
- B) Tells all listening widgets to rebuild ✅
- C) Notifies the server
- D) Creates new listeners

**2. When should you use `context.read()` vs `context.watch()`?**
- A) They're the same thing
- B) read() in build(), watch() in callbacks
- C) watch() in build(), read() in callbacks ✅
- D) Always use watch()

**3. What is the purpose of MultiProvider?**
- A) Provides internet connection
- B) Provides multiple providers without deep nesting ✅
- C) Multiplies provider values
- D) Required for Provider to work

**4. What's the difference between ChangeNotifier and ValueNotifier?**
- A) No difference
- B) ChangeNotifier is for complex objects, ValueNotifier for single values ✅
- C) ValueNotifier is deprecated
- D) ChangeNotifier is faster

**5. Which is TRUE about Provider?**
- A) Requires BuildContext ✅
- B) Provides compile-time safety
- C) Better than Riverpod in all cases
- D) Can't be used with BLoC

---

### **Q26-Q32: BLoC**

**6. In BLoC pattern, what do Events represent?**
- A) UI widgets
- B) User actions or system occurrences ✅
- C) Error messages
- D) Database queries

**7. What's the main difference between BlocBuilder and BlocConsumer?**
- A) BlocBuilder is faster
- B) BlocConsumer can perform side effects via listener ✅
- C) BlocBuilder is deprecated
- D) They're identical

**8. How does BLoC enforce separation of concerns?**
- A) UI can only dispatch events, can't call methods directly ✅
- B) UI can call any method
- C) BLoC contains UI code
- D) No separation

**9. Why is BLoC highly testable?**
- A) It's not testable
- B) Pure function: Event → States, no UI dependencies ✅
- C) Has built-in test framework
- D) Requires no mocking

**10. When should you use BLoC over Provider?**
- A) Never
- B) Always
- C) For complex business logic requiring strict patterns ✅
- D) Only for simple apps

---

### **Q33-Q40: Riverpod**

**11. What's the main advantage of Riverpod over Provider?**
- A) Faster performance
- B) No BuildContext needed, compile-time safety ✅
- C) Less code
- D) Easier to learn

**12. When should you use StateProvider vs StateNotifierProvider?**
- A) StateProvider for complex state, StateNotifierProvider for simple
- B) StateProvider for simple values, StateNotifierProvider for complex logic ✅
- C) Always use StateNotifierProvider
- D) They're the same

**13. What is FutureProvider used for?**
- A) Predicting the future
- B) Handling asynchronous operations returning a Future ✅
- C) Only for API calls
- D) Same as StreamProvider

**14. What is AsyncValue?**
- A) A type of provider
- B) A sealed union representing loading/error/data states ✅
- C) A widget
- D) A testing tool

**15. When should you use ref.watch()?**
- A) In callbacks only
- B) In build() method to listen to provider changes ✅
- C) Never
- D) For side effects

**16. When should you use ref.read()?**
- A) In build() method
- B) In callbacks/actions where you don't want to listen ✅
- C) For side effects only
- D) Always instead of watch

**17. What is ref.listen() used for?**
- A) Rebuilding widgets
- B) Side effects like navigation, snackbars, dialogs ✅
- C) Reading provider values
- D) Creating providers

**18. What's the difference between FutureProvider and StreamProvider?**
- A) No difference
- B) FutureProvider for single async value, StreamProvider for continuous values ✅
- C) StreamProvider is deprecated
- D) FutureProvider is faster

**19. What does .when() do on AsyncValue?**
- A) Sets a timer
- B) Pattern matches loading/error/data states ✅
- C) Waits for completion
- D) Creates a stream

**20. When should you choose Riverpod over BLoC?**
- A) Never
- B) For new projects wanting type safety and modern syntax ✅
- C) Only for small apps
- D) When BLoC is not available

---

## 💻 PART 2: CODING CHALLENGES (30 minutes)

### **Challenge 1: Create a Counter with Provider (10 min)**

```dart
// Create a complete counter app using Provider
// Requirements:
// - CounterModel extending ChangeNotifier
// - Increment, decrement, reset methods
// - Display counter with Consumer
// - Buttons using context.read()

// Your code here:
```

---

### **Challenge 2: Create Auth BLoC (10 min)**

```dart
// Create a simple auth BLoC
// Requirements:
// - LoginEvent with email/password
// - AuthState: Initial, Loading, Authenticated, Error
// - AuthBloc transforming LoginEvent to states
// - Emit Loading → Authenticated (if password == "test123")
// - Emit Loading → Error (if password != "test123")

// Your code here:
```

---

### **Challenge 3: Create User Provider with Riverpod (10 min)**

```dart
// Create a Riverpod FutureProvider for user data
// Requirements:
// - FutureProvider<User> that fetches after 2 seconds
// - ConsumerWidget displaying user with .when()
// - Show loading, error, and data states
// - Refresh button using ref.invalidate()

// Your code here:
```

---

## ✅ ANSWERS

### **Theory Answers:**

1. **B** (Tells all listening widgets to rebuild)
2. **C** (watch() in build(), read() in callbacks)
3. **B** (Provides multiple providers without deep nesting)
4. **B** (ChangeNotifier for complex objects, ValueNotifier for single values)
5. **A** (Requires BuildContext)
6. **B** (User actions or system occurrences)
7. **B** (BlocConsumer can perform side effects via listener)
8. **A** (UI can only dispatch events)
9. **B** (Pure function: Event → States, no UI dependencies)
10. **C** (For complex business logic requiring strict patterns)
11. **B** (No BuildContext needed, compile-time safety)
12. **B** (StateProvider for simple values, StateNotifierProvider for complex logic)
13. **B** (Handling asynchronous operations returning a Future)
14. **B** (A sealed union representing loading/error/data states)
15. **B** (In build() method to listen to provider changes)
16. **B** (In callbacks/actions where you don't want to listen)
17. **B** (Side effects like navigation, snackbars, dialogs)
18. **B** (FutureProvider for single async value, StreamProvider for continuous values)
19. **B** (Pattern matches loading/error/data states)
20. **B** (For new projects wanting type safety and modern syntax)

**Scoring:**
- Count your correct answers
- 18-20: Excellent ✅
- 15-17: Good (review weak areas)
- <15: Review theory again

---

### **Coding Challenge Answers:**

**Challenge 1: Provider Counter**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model
class CounterModel extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners();
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

// App
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Provider Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Consumer - rebuilds when counter changes
              Consumer<CounterModel>(
                builder: (context, counterModel, child) {
                  return Text(
                    '${counterModel.counter}',
                    style: const TextStyle(fontSize: 48),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterModel>().decrement();
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterModel>().reset();
                    },
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterModel>().increment();
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

**Challenge 2: Auth BLoC**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  LoginEvent(this.email, this.password);
  
  @override
  List<Object?> get props => [email, password];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String email;
  
  AuthAuthenticated(this.email);
  
  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  
  AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }
  
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // Emit loading
    emit(AuthLoading());
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check password
    if (event.password == 'test123') {
      emit(AuthAuthenticated(event.email));
    } else {
      emit(AuthError('Invalid password'));
    }
  }
}

// Usage
void main() {
  runApp(
    BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (state is AuthAuthenticated) {
              return Scaffold(
                body: Center(child: Text('Welcome ${state.email}')),
              );
            }
            
            if (state is AuthError) {
              return Scaffold(
                body: Center(child: Text('Error: ${state.message}')),
              );
            }
            
            // AuthInitial
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      LoginEvent('test@test.com', 'test123'),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
```

---

**Challenge 3: Riverpod FutureProvider**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User model
class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
}

// FutureProvider
final userProvider = FutureProvider<User>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 2));
  
  // Return user
  return User(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
  );
});

// App
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserScreen(),
    );
  }
}

// ConsumerWidget
class UserScreen extends ConsumerWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod User')),
      body: Center(
        child: userAsync.when(
          loading: () => const CircularProgressIndicator(),
          
          error: (error, stack) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              Text('Error: $error'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
          
          data: (user) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(user.email),
              const SizedBox(height: 30),
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
```

---

## 📊 FINAL ASSESSMENT

### **Theory Score: 20/20**
### **Coding Score: 3/3**

**Overall Performance:**

**21-23 points: EXCELLENT** 🌟
- You've mastered state management
- Ready for Day 3
- Keep this momentum!

**18-20 points: GOOD** ✅
- You understand most concepts
- Review questions you missed
- Practice coding challenges again
- Ready for Day 3

**15-17 points: FAIR** ⚠️
- You have the basics
- Review theory documents again
- Code the 3 apps again from scratch
- Consider reviewing Day 2 before moving to Day 3

**<15 points: NEEDS WORK** 📚
- Review theory documents thoroughly
- Code all 3 apps again
- Understand WHY, not just HOW
- Retake quiz tomorrow before Day 3

---

## 🎯 BEFORE DAY 3

**Checklist:**
- [✅] Scored 18+ on theory quiz
- [✅] Completed all coding challenges
- [✅] Can explain Provider vs BLoC vs Riverpod
- [✅] Understand when to use each pattern
- [✅] Know ref.watch vs ref.read vs ref.listen
- [✅] Can use AsyncValue.when()

**If all checked:** ✅ Ready for Day 3!

**If not:** Review weak areas before continuing.

---

## 💡 QUICK REVIEW TIPS

**If you struggle with:**

**Provider (Q21-Q25):**
- Re-read App 1 code
- Focus on ChangeNotifier + notifyListeners
- Practice Consumer vs context.read/watch

**BLoC (Q26-Q32):**
- Re-read App 2 code
- Draw Event → BLoC → State flow
- Practice creating events and states

**Riverpod (Q33-Q40):**
- Re-read App 3 code
- Focus on different provider types
- Practice ref.watch vs ref.read
- Master AsyncValue.when()

---

## 🚀 DAY 3 PREVIEW

**Tomorrow you'll learn:**
- Q41-Q60: Clean Architecture deep dive
- Dependency injection
- Repository pattern
- Use cases
- Testing strategies

**Preparation:**
- Get good sleep
- Review clean architecture from interview docs
- Be ready for architectural patterns

---

## 🎉 CONGRATULATIONS!

**You completed Day 2!**

**What you achieved:**
- ✅ Built 3 state management apps
- ✅ Learned Provider, BLoC, and Riverpod
- ✅ Understand Q21-Q40
- ✅ Can choose appropriate pattern for any app
- ✅ Know when to use each approach

**40/200 questions mastered (20%)** 📊

**See you tomorrow for Day 3!** 🚀

---

*Remember: State management is a tool. Choose the right tool for the job. There's no "best" pattern - only the best pattern for YOUR specific needs.*
