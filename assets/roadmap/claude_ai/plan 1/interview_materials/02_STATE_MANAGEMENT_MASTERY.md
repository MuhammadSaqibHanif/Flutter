# State Management Mastery: BLoC vs Riverpod vs Provider

## Complete Interview Guide with Real 2024-2025 Questions

Based on actual interviews at Google, Meta, Amazon, Uber, Airbnb

---

## 🎯 Overview

**Most Asked Interview Question:**
"Explain the differences between setState, Provider, Riverpod, and BLoC. When would you choose one over the other?"

This document provides:

- Deep technical comparison
- Production code examples
- Interview questions with answers
- Trade-off analysis
- When to use what

---

## 📋 Quick Comparison Table

| Feature                 | setState    | Provider          | Riverpod          | BLoC       |
| ----------------------- | ----------- | ----------------- | ----------------- | ---------- |
| **Complexity**          | ⭐          | ⭐⭐              | ⭐⭐⭐            | ⭐⭐⭐⭐   |
| **Boilerplate**         | None        | Low               | Medium            | High       |
| **Testability**         | ⭐          | ⭐⭐⭐            | ⭐⭐⭐⭐          | ⭐⭐⭐⭐⭐ |
| **Type Safety**         | ⭐          | ⭐⭐              | ⭐⭐⭐⭐⭐        | ⭐⭐⭐⭐   |
| **Learning Curve**      | Easy        | Easy              | Medium            | Hard       |
| **Best For**            | Local state | Small/Medium apps | Medium/Large apps | Enterprise |
| **Async Support**       | ⭐⭐        | ⭐⭐⭐            | ⭐⭐⭐⭐⭐        | ⭐⭐⭐⭐⭐ |
| **Code Generation**     | No          | No                | Yes (optional)    | No         |
| **Compile-time Safety** | No          | No                | Yes               | Partial    |

---

## 1. setState - The Foundation

### When to Use

- Local widget state
- Simple UI updates
- Form inputs
- Checkboxes, switches
- Small apps (<10 screens)

### Pros

✅ Simple, built-in  
✅ No dependencies  
✅ Fast to implement  
✅ Good for learning

### Cons

❌ State lost on navigation  
❌ No state sharing  
❌ Hard to test  
❌ Doesn't scale

### Production Example

```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  bool _isLoading = false;

  Future<void> _incrementAsync() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _counter++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
          ? CircularProgressIndicator()
          : Text('$_counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementAsync,
      ),
    );
  }
}
```

### Interview Questions

**Q1: "What happens when you call setState()?"**

**Answer:**

```dart
// 1. setState calls markNeedsBuild()
setState(() {
  counter++; // Your state change
});

// 2. Widget marked as "dirty"
// 3. Flutter schedules rebuild
// 4. build() called in next frame
// 5. New widget tree created
// 6. Element tree compares old vs new
// 7. Only changed widgets re-rendered

// Important: setState() is synchronous
// Rebuilds happen asynchronously
```

**Q2: "Common setState() mistakes?"**

**Answer:**

```dart
// ❌ WRONG: Calling setState after dispose
@override
void dispose() {
  super.dispose();
  setState(() {}); // Crash!
}

// ✅ CORRECT: Check mounted
if (mounted) {
  setState(() {});
}

// ❌ WRONG: setState in build()
@override
Widget build(BuildContext context) {
  setState(() {}); // Infinite loop!
  return Container();
}

// ❌ WRONG: Heavy computation in setState
setState(() {
  for (int i = 0; i < 1000000; i++) {} // Blocks UI
});

// ✅ CORRECT: Keep setState lightweight
final result = heavyComputation(); // Do this outside
setState(() {
  data = result; // Just update
});
```

---

## 2. Provider - The Standard

### When to Use

- Small to medium apps
- Need state sharing between widgets
- Don't need complex architecture
- Team familiar with InheritedWidget
- Rapid prototyping

### Pros

✅ Flutter team recommended  
✅ Easy to learn  
✅ Good for most apps  
✅ Decent testing support  
✅ Large community

### Cons

❌ Runtime errors  
❌ Not compile-time safe  
❌ Requires BuildContext  
❌ Hard to scope providers  
❌ Testing requires widget tests

### Production Example

```dart
// 1. Create ChangeNotifier
class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;

  int get counter => _counter;
  bool get isLoading => _isLoading;

  Future<void> increment() async {
    _isLoading = true;
    notifyListeners(); // Notify UI

    await Future.delayed(Duration(seconds: 1));

    _counter++;
    _isLoading = false;
    notifyListeners(); // Notify UI again
  }

  @override
  void dispose() {
    // Clean up
    super.dispose();
  }
}

// 2. Provide at app level
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

// 3. Consume in widgets
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Watch rebuilds when notifyListeners called
    final counter = context.watch<CounterProvider>().counter;
    final isLoading = context.watch<CounterProvider>().isLoading;

    // Read doesn't rebuild
    final provider = context.read<CounterProvider>();

    return Scaffold(
      body: Center(
        child: isLoading
          ? CircularProgressIndicator()
          : Text('$counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.increment(),
      ),
    );
  }
}

// 4. Selective rebuilds with Consumer
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    // Only this rebuilds
    return Text('${provider.counter}');
  },
)

// 5. Multiple providers
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ProxyProvider<AuthProvider, CartProvider>(
      update: (_, auth, __) => CartProvider(auth),
    ),
  ],
  child: MyApp(),
);
```

### Interview Questions

**Q3: "Provider - watch() vs read() vs select()?"**

**Answer:**

```dart
// watch() - Rebuilds when value changes
final counter = context.watch<CounterProvider>().counter;
// Use in build() method

// read() - Doesn't rebuild, just gets value
context.read<CounterProvider>().increment();
// Use in callbacks (onPressed, etc.)

// select() - Rebuilds only when selected value changes
final isEven = context.select<CounterProvider, bool>(
  (provider) => provider.counter % 2 == 0,
);
// More efficient than watch()

// ❌ WRONG: read() in build
@override
Widget build(BuildContext context) {
  final counter = context.read<CounterProvider>().counter; // Won't update!
  return Text('$counter');
}

// ❌ WRONG: watch() in callback
ElevatedButton(
  onPressed: () {
    context.watch<CounterProvider>().increment(); // Error!
  },
)
```

**Q4: "How do you test Provider?"**

**Answer:**

```dart
testWidgets('Counter increments', (tester) async {
  // Create provider
  final provider = CounterProvider();

  // Wrap in provider
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        home: CounterPage(),
      ),
    ),
  );

  // Verify initial state
  expect(find.text('0'), findsOneWidget);

  // Tap button
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pump();

  // Verify updated state
  expect(find.text('1'), findsOneWidget);
});

// Unit test ChangeNotifier
test('CounterProvider increments', () {
  final provider = CounterProvider();

  expect(provider.counter, 0);

  provider.increment();

  expect(provider.counter, 1);
});
```

---

## 3. Riverpod - The Modern Choice

### When to Use

- Medium to large apps
- Need compile-time safety
- Complex dependency injection
- Advanced testing requirements
- Team values type safety
- When Provider limitations hit

### Pros

✅ Compile-time safe  
✅ No BuildContext needed  
✅ Easy testing (no widgets)  
✅ Better scoping  
✅ Auto-dispose  
✅ Family modifier  
✅ AsyncValue for loading states

### Cons

❌ Steeper learning curve  
❌ More concepts to learn  
❌ Code generation (optional)  
❌ Less mature than Provider

### Production Example

```dart
// 1. Define providers (outside classes)
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  Future<void> increment() async {
    state = state + 1;
  }
}

// 2. No need to wrap app
void main() {
  runApp(
    ProviderScope( // Just this wrapper
      child: MyApp(),
    ),
  );
}

// 3. Consume with ConsumerWidget
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch - rebuilds on change
    final counter = ref.watch(counterProvider);

    return Scaffold(
      body: Center(
        child: Text('$counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Read - doesn't rebuild
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}

// 4. Advanced: AsyncNotifierProvider
@riverpod
class Users extends _$Users {
  @override
  Future<List<User>> build() async {
    return await fetchUsers();
  }

  Future<void> addUser(User user) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final users = [...state.value!, user];
      await saveUsers(users);
      return users;
    });
  }
}

// 5. Consume async data
class UsersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      data: (users) => ListView(
        children: users.map((u) => UserTile(u)).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

// 6. Provider families (parametrized providers)
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return await fetchUser(userId);
});

// Usage
final user = ref.watch(userProvider('user_123'));

// 7. Provider dependencies
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

final profileProvider = FutureProvider<Profile>((ref) async {
  final user = ref.watch(authProvider);
  if (user == null) throw Exception('Not logged in');
  return await fetchProfile(user.id);
});
```

### Interview Questions

**Q5: "Riverpod vs Provider - Why switch?"**

**Answer:**

```dart
// Provider problems Riverpod solves:

// 1. Runtime errors
// Provider:
final value = Provider.of<MyProvider>(context); // Error at runtime if missing

// Riverpod:
final value = ref.watch(myProvider); // Compile error if wrong type

// 2. Testing requires widgets
// Provider:
testWidgets('test', (tester) async {
  await tester.pumpWidget(
    Provider(create: (_) => MyProvider(), child: MyWidget()),
  );
});

// Riverpod:
test('test', () {
  final container = ProviderContainer();
  final value = container.read(myProvider);
  // No widgets needed!
});

// 3. BuildContext dependency
// Provider:
void someMethod(BuildContext context) {
  final value = Provider.of<MyProvider>(context); // Need context
}

// Riverpod:
void someMethod(WidgetRef ref) {
  final value = ref.read(myProvider); // No context needed
}

// 4. Provider scope issues
// Provider:
// Hard to have different instances for different subtrees

// Riverpod:
ProviderScope(
  overrides: [myProvider.overrideWithValue(differentValue)],
  child: SubTree(),
);
```

**Q6: "Explain ref.watch vs ref.read vs ref.listen?"**

**Answer:**

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch() - Rebuilds when provider changes
    final counter = ref.watch(counterProvider);
    // Use: In build method for reactive UI

    // read() - Gets value once, no rebuild
    return FloatingActionButton(
      onPressed: () {
        ref.read(counterProvider.notifier).increment();
        // Use: In callbacks, one-time reads
      },
    );
  }
}

// listen() - Side effects without rebuild
@override
void initState() {
  super.initState();
  ref.listen(counterProvider, (prev, next) {
    if (next >= 10) {
      showDialog(...);
    }
    // Use: Navigation, dialogs, snackbars
  });
}
```

---

## 4. BLoC - The Enterprise Solution

### When to Use

- Large enterprise apps
- Complex business logic
- Team needs strict structure
- Heavy async operations
- Need predictable state
- Regulatory/testing requirements

### Pros

✅ Clear separation of concerns  
✅ Highly testable  
✅ Predictable state  
✅ Great for large teams  
✅ Stream-based (reactive)  
✅ Well-documented pattern  
✅ Great for complex flows

### Cons

❌ High boilerplate  
❌ Steep learning curve  
❌ Overkill for simple apps  
❌ More files per feature  
❌ Slower initial development

### Production Example

```dart
// 1. Define Events
abstract class CounterEvent {}

class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class LoadCounter extends CounterEvent {}

// 2. Define States
abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterLoading extends CounterState {}

class CounterLoaded extends CounterState {
  final int counter;
  CounterLoaded(this.counter);
}

class CounterError extends CounterState {
  final String message;
  CounterError(this.message);
}

// 3. BLoC Implementation
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository _repository;

  CounterBloc(this._repository) : super(CounterInitial()) {
    on<LoadCounter>(_onLoadCounter);
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
  }

  Future<void> _onLoadCounter(
    LoadCounter event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());

    try {
      final counter = await _repository.getCounter();
      emit(CounterLoaded(counter));
    } catch (e) {
      emit(CounterError(e.toString()));
    }
  }

  Future<void> _onIncrement(
    Increment event,
    Emitter<CounterState> emit,
  ) async {
    final currentState = state;
    if (currentState is CounterLoaded) {
      final newValue = currentState.counter + 1;
      await _repository.saveCounter(newValue);
      emit(CounterLoaded(newValue));
    }
  }

  Future<void> _onDecrement(
    Decrement event,
    Emitter<CounterState> emit,
  ) async {
    final currentState = state;
    if (currentState is CounterLoaded) {
      final newValue = currentState.counter - 1;
      await _repository.saveCounter(newValue);
      emit(CounterLoaded(newValue));
    }
  }
}

// 4. Provide BLoC
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(
        CounterRepository(),
      )..add(LoadCounter()), // Initial event
      child: MaterialApp(
        home: CounterPage(),
      ),
    );
  }
}

// 5. Consume in UI
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is CounterLoading) {
            return CircularProgressIndicator();
          }

          if (state is CounterError) {
            return Text('Error: ${state.message}');
          }

          if (state is CounterLoaded) {
            return Text('${state.counter}');
          }

          return Container();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(Increment());
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(Decrement());
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

// 6. Listen for side effects
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: CounterPage(),
);

// 7. Advanced: Event transformers
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    // Debounce search events
    on<SearchEvent>(
      _onSearch,
      transformer: debounce(Duration(milliseconds: 300)),
    );

    // Throttle location updates
    on<LocationUpdate>(
      _onLocationUpdate,
      transformer: throttle(Duration(seconds: 1)),
    );
  }
}
```

### Interview Questions

**Q7: "When would you choose BLoC over Riverpod?"**

**Answer:**

```dart
// Choose BLoC when:

// 1. Large team needs strict structure
// ✅ BLoC: Every developer knows where business logic goes
// ❌ Riverpod: More flexible, easier to make mistakes

// 2. Complex async workflows
// ✅ BLoC: Stream transformers (debounce, throttle, switchMap)
// ❌ Riverpod: Possible but less elegant

// 3. Need to replay events
// ✅ BLoC: Events are explicit, can log/replay
// ❌ Riverpod: Method calls, harder to track

// 4. Existing BLoC codebase
// ✅ BLoC: Consistency
// ❌ Riverpod: Mixing patterns confusing

// Choose Riverpod when:

// 1. Faster development important
// ✅ Riverpod: Less boilerplate
// ❌ BLoC: More files, more code

// 2. Team values type safety
// ✅ Riverpod: Compile-time safety
// ❌ BLoC: Runtime errors possible

// 3. Simpler state management
// ✅ Riverpod: Direct state updates
// ❌ BLoC: Events → States overhead

// 4. Modern Flutter patterns
// ✅ Riverpod: Latest patterns
// ❌ BLoC: More traditional
```

**Q8: "How do you test BLoC?"**

**Answer:**

```dart
void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;
    late MockCounterRepository repository;

    setUp(() {
      repository = MockCounterRepository();
      bloc = CounterBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is CounterInitial', () {
      expect(bloc.state, isA<CounterInitial>());
    });

    blocTest<CounterBloc, CounterState>(
      'emits [Loading, Loaded] when LoadCounter succeeds',
      build: () {
        when(() => repository.getCounter())
            .thenAnswer((_) async => 5);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCounter()),
      expect: () => [
        isA<CounterLoading>(),
        isA<CounterLoaded>()
            .having((s) => s.counter, 'counter', 5),
      ],
      verify: (_) {
        verify(() => repository.getCounter()).called(1);
      },
    );

    blocTest<CounterBloc, CounterState>(
      'emits [Loading, Error] when LoadCounter fails',
      build: () {
        when(() => repository.getCounter())
            .thenThrow(Exception('Failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCounter()),
      expect: () => [
        isA<CounterLoading>(),
        isA<CounterError>()
            .having((s) => s.message, 'message', contains('Failed')),
      ],
    );
  });
}
```

---

## 5. Decision Matrix

### By App Size

```dart
// Small app (<10 screens)
// Choice: setState or Provider
// Why: Simple, fast to build

// Medium app (10-50 screens)
// Choice: Provider or Riverpod
// Why: Need state sharing, not too complex

// Large app (50+ screens)
// Choice: Riverpod or BLoC
// Why: Need structure, testability

// Enterprise (100+ screens, multiple teams)
// Choice: BLoC
// Why: Need strict structure, predictability
```

### By Team

```dart
// Solo developer / Small team (<3)
// Choice: Riverpod
// Why: Productivity, less boilerplate

// Medium team (3-10)
// Choice: Provider or Riverpod
// Why: Balance of simplicity and structure

// Large team (10+)
// Choice: BLoC
// Why: Need enforced patterns
```

### By Use Case

```dart
// Real-time apps (Chat, Live updates)
// Choice: BLoC
// Why: Stream-based, natural fit

// CRUD apps (Standard business apps)
// Choice: Riverpod
// Why: Simpler, async built-in

// Form-heavy apps
// Choice: Riverpod + Freezed
// Why: Less boilerplate

// Complex async flows
// Choice: BLoC
// Why: Event transformers
```

---

## 6. Migration Strategies

### Provider → Riverpod

```dart
// Provider
class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}

// Equivalent Riverpod
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state = state + 1;
  }
}

// UI changes:
// Provider:
context.watch<CounterProvider>().counter

// Riverpod:
ref.watch(counterProvider)
```

### BLoC → Riverpod

```dart
// BLoC
bloc.add(LoadData());

// Riverpod
ref.read(dataProvider.notifier).load();

// State handling:
// BLoC
BlocBuilder<DataBloc, DataState>(
  builder: (context, state) {
    if (state is Loading) return Loading();
    if (state is Loaded) return Content(state.data);
    if (state is Error) return Error(state.message);
  },
)

// Riverpod
ref.watch(dataProvider).when(
  data: (data) => Content(data),
  loading: () => Loading(),
  error: (err, stack) => Error(err.toString()),
)
```

---

## 7. Real Interview Questions from 2024

### Q9: Meta E5 Interview

"You have a shopping cart app. Users can add items, remove items, apply coupons, and checkout. How would you manage state?"

**Expected Answer:**

```dart
// Analysis:
// - Medium complexity
// - Multiple related states (cart, coupons, checkout)
// - Need persistence
// - Need to share across screens

// Choice: Riverpod (or BLoC for enterprise)

// Why Riverpod:
// 1. Multiple providers can be composed
// 2. AsyncNotifier for network requests
// 3. Easy testing without widgets
// 4. Family for parametrized providers (product details)

// Implementation:
@riverpod
class Cart extends _$Cart {
  @override
  Future<CartState> build() async {
    final savedCart = await _loadCart();
    return savedCart;
  }

  Future<void> addItem(Product product) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value!;
      final updated = current.addProduct(product);
      await _saveCart(updated);
      return updated;
    });
  }
}

@riverpod
class Coupons extends _$Coupons {
  @override
  Future<List<Coupon>> build() async {
    return await fetchCoupons();
  }

  Future<void> apply(String code) async {
    // Apply coupon logic
  }
}

// Dependency between providers
@riverpod
double total(TotalRef ref) {
  final cart = ref.watch(cartProvider).valueOrNull;
  final appliedCoupon = ref.watch(appliedCouponProvider);

  if (cart == null) return 0;

  final subtotal = cart.items.fold<double>(
    0,
    (sum, item) => sum + item.price * item.quantity,
  );

  final discount = appliedCoupon?.discount ?? 0;
  return subtotal * (1 - discount);
}
```

### Q10: Google L5 Interview

"Design state management for a video streaming app with offline support, playlists, and recommendations."

**Expected Answer:**

```dart
// Analysis:
// - Complex async operations
// - Offline queue
// - Multiple data sources
// - Real-time updates
// - Large scale

// Choice: BLoC (Enterprise scale)

// Why BLoC:
// 1. Clear separation for complex logic
// 2. Stream transformers for debouncing search
// 3. Event replay for debugging
// 4. Offline queue as events
// 5. Team coordination

// Architecture:
// VideoPlayerBloc - Video playback state
// DownloadBloc - Offline downloads
// PlaylistBloc - Playlist management
// RecommendationBloc - ML-based recommendations
// SearchBloc - Search with debouncing

// Example:
class VideoPlayerBloc extends Bloc<VideoEvent, VideoState> {
  VideoPlayerBloc() : super(VideoInitial()) {
    on<LoadVideo>(_onLoadVideo);
    on<PlayVideo>(_onPlay);
    on<PauseVideo>(_onPause);
    on<SeekVideo>(_onSeek);

    // Offline events queued
    on<SaveProgress>(
      _onSaveProgress,
      transformer: debounce(Duration(seconds: 5)),
    );
  }

  Future<void> _onLoadVideo(
    LoadVideo event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());

    try {
      // Check offline cache first
      final cachedVideo = await _cacheRepo.getVideo(event.id);
      if (cachedVideo != null) {
        emit(VideoLoaded(cachedVideo, source: CacheSource()));
        return;
      }

      // Fetch from network
      final video = await _apiRepo.getVideo(event.id);
      emit(VideoLoaded(video, source: NetworkSource()));

      // Cache for offline
      await _cacheRepo.saveVideo(video);
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
```

---

## 8. Common Mistakes to Avoid

### Mistake 1: Not disposing

```dart
// ❌ WRONG
class _MyState extends State<MyWidget> {
  final controller = TextEditingController();
  final subscription = stream.listen(/*...*/);

  // Missing dispose!
}

// ✅ CORRECT
@override
void dispose() {
  controller.dispose();
  subscription.cancel();
  super.dispose();
}
```

### Mistake 2: Rebuilding too much

```dart
// ❌ WRONG: Entire page rebuilds
ref.watch(userProvider);

// ✅ CORRECT: Only name rebuilds
final name = ref.watch(userProvider.select((user) => user.name));
```

### Mistake 3: Using wrong method

```dart
// ❌ WRONG: watch in callback
onPressed: () {
  context.watch<Provider>().method(); // Error!
}

// ✅ CORRECT: read in callback
onPressed: () {
  context.read<Provider>().method();
}
```

---

## 9. Performance Tips

### 1. Use `const` constructors

```dart
// Prevents rebuilds
const Text('Hello');
const SizedBox(height: 10);
```

### 2. Use `select` for fine-grained updates

```dart
// Only rebuilds when specific field changes
final name = ref.watch(
  userProvider.select((user) => user.name),
);
```

### 3. Use `Consumer` for partial rebuilds

```dart
// Only Consumer rebuilds, not entire page
Consumer<Provider>(
  builder: (context, provider, child) => Text(provider.data),
)
```

### 4. Memoize expensive computations

```dart
@riverpod
List<Product> filteredProducts(FilteredProductsRef ref) {
  final products = ref.watch(productsProvider);
  final filter = ref.watch(filterProvider);

  // Automatically memoized by Riverpod
  return products.where((p) => p.matches(filter)).toList();
}
```

---

## 10. Final Recommendations

### For Your Interview

1. **Know when to use what** - Most important!
2. **Be able to justify your choice**
3. **Know trade-offs of each approach**
4. **Have production examples ready**
5. **Understand testing for each**

### For Production

- **Start simple**: setState → Provider → Riverpod → BLoC
- **Don't over-engineer early**
- **Choose based on team, not hype**
- **Consider migration path**
- **Measure before optimizing**

### Quick Decision Tree

```
Simple app? → setState
Need state sharing? → Provider
Type safety important? → Riverpod
Enterprise complexity? → BLoC
Still unsure? → Riverpod (best default)
```

---

## Resources

- [Riverpod Documentation](https://riverpod.dev)
- [BLoC Library](https://bloclibrary.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [State Management Comparison](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

---

**Good luck with your interviews! 🚀**

Remember: The "best" state management solution is the one that:

1. Your team understands
2. Fits your app's complexity
3. You can maintain long-term
