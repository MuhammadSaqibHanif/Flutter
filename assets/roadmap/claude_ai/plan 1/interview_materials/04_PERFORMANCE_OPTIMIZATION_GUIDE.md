# Flutter Performance Optimization & Memory Management

## Complete Interview Guide with Real-World Scenarios

Based on actual performance interviews at Google, Meta, Amazon

---

## 🎯 Overview

**Why This Matters:**

- Performance questions test deep Flutter knowledge
- Common in Senior+ interviews (L5/E5+)
- Shows production experience
- Differentiates good from great developers

**Key Topics:**

1. Memory Management & Leaks
2. Build Optimization
3. Rendering Performance
4. Startup Time Optimization
5. Network & I/O Performance
6. Battery Optimization

---

## 1. Memory Management

### Interview Question: "How do you detect and fix memory leaks in Flutter?"

**Answer Framework:**

```dart
// 1. COMMON MEMORY LEAKS

// ❌ LEAK 1: Not disposing controllers
class _MyState extends State<MyWidget> {
  final controller = TextEditingController();

  // Missing dispose() - MEMORY LEAK!
}

// ✅ FIX: Always dispose
@override
void dispose() {
  controller.dispose();
  super.dispose();
}

// ❌ LEAK 2: Not canceling subscriptions
class _MyState extends State<MyWidget> {
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = stream.listen((data) {});
    // Missing cancel() - MEMORY LEAK!
  }
}

// ✅ FIX: Cancel in dispose
@override
void dispose() {
  subscription.cancel();
  super.dispose();
}

// ❌ LEAK 3: Global event listeners
class _MyState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    eventBus.on<MyEvent>().listen(_handleEvent);
    // Never removed - MEMORY LEAK!
  }
}

// ✅ FIX: Store and cancel
late StreamSubscription _eventSubscription;

@override
void initState() {
  super.initState();
  _eventSubscription = eventBus.on<MyEvent>().listen(_handleEvent);
}

@override
void dispose() {
  _eventSubscription.cancel();
  super.dispose();
}

// ❌ LEAK 4: Holding BuildContext in long-lived objects
class MyService {
  BuildContext? context; // MEMORY LEAK!

  void save(BuildContext context) {
    this.context = context; // Holds entire widget tree
  }
}

// ✅ FIX: Never store BuildContext, or use weak reference
class MyService {
  WeakReference<BuildContext>? contextRef;

  void save(BuildContext context) {
    contextRef = WeakReference(context);
  }

  void use() {
    final context = contextRef?.target;
    if (context != null && context.mounted) {
      // Use context
    }
  }
}

// ❌ LEAK 5: Closures capturing 'this'
class _MyState extends State<MyWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {}); // Captures 'this' - potential leak
    });
  }
}

// ✅ FIX: Cancel timer
@override
void dispose() {
  timer.cancel();
  super.dispose();
}
```

### Detection Tools

```dart
// 1. Use Flutter DevTools Memory Profiler
// - Track allocations
// - Take snapshots
// - Compare memory before/after navigation

// 2. Use leak_tracker package
import 'package:leak_tracker/leak_tracker.dart';

void main() {
  LeakTracking.start();
  runApp(MyApp());
}

// 3. Custom leak detector
class LeakDetector {
  static final _activeWidgets = <String, int>{};

  static void track(String widget) {
    _activeWidgets[widget] = (_activeWidgets[widget] ?? 0) + 1;
    print('Active: $_activeWidgets');
  }

  static void untrack(String widget) {
    _activeWidgets[widget] = (_activeWidgets[widget] ?? 1) - 1;
    if (_activeWidgets[widget]! <= 0) {
      _activeWidgets.remove(widget);
    }
    print('Active: $_activeWidgets');
  }
}

// Usage
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    LeakDetector.track('MyWidget');
  }

  @override
  void dispose() {
    LeakDetector.untrack('MyWidget');
    super.dispose();
  }
}
```

### Memory Optimization Checklist

```dart
class MemoryOptimizationChecklist {
  // ✅ 1. Dispose all controllers
  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ✅ 2. Cancel all subscriptions
  @override
  void dispose() {
    _streamSubscription.cancel();
    _timerSubscription.cancel();
    super.dispose();
  }

  // ✅ 3. Use const constructors
  const Text('Hello'); // ✅ Created once
  Text('Hello'); // ❌ Created on every build

  // ✅ 4. Optimize images
  CachedNetworkImage(
    imageUrl: url,
    memCacheWidth: 800, // Resize for memory
    memCacheHeight: 600,
  );

  // ✅ 5. Use ListView.builder for long lists
  ListView.builder( // ✅ Lazy loading
    itemCount: 10000,
    itemBuilder: (context, index) => ListTile(),
  );

  // ❌ Don't use ListView with all items
  ListView(
    children: List.generate(10000, (i) => ListTile()), // All in memory!
  );

  // ✅ 6. Dispose large objects
  Uint8List? largeData;

  @override
  void dispose() {
    largeData = null; // Allow GC
    super.dispose();
  }

  // ✅ 7. Use AutomaticKeepAliveClientMixin carefully
  // Only for widgets that MUST stay alive
  class _MyState extends State<MyWidget>
      with AutomaticKeepAliveClientMixin {
    @override
    bool get wantKeepAlive => true; // Keep in memory
  }
}
```

---

## 2. Build Optimization

### Interview Question: "Your app is rebuilding too often. How do you fix it?"

**Answer:**

```dart
// PROBLEM: Entire page rebuilds on every state change

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print('HomePage build'); // This prints on every increment!

    return Column(
      children: [
        ExpensiveWidget1(), // Rebuilds unnecessarily
        ExpensiveWidget2(), // Rebuilds unnecessarily
        Text('$counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
        ),
      ],
    );
  }
}

// SOLUTION 1: Extract stateful widget
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print('CounterWidget build'); // Only this rebuilds now

    return Column(
      children: [
        Text('$counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('HomePage build'); // Builds once

    return Column(
      children: [
        ExpensiveWidget1(), // Builds once
        ExpensiveWidget2(), // Builds once
        CounterWidget(), // Only this rebuilds
      ],
    );
  }
}

// SOLUTION 2: Use const constructors
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget1(), // Won't rebuild!
        const ExpensiveWidget2(), // Won't rebuild!
        Text('$counter'), // Only this rebuilds
        ElevatedButton(
          onPressed: () => setState(() => counter++),
        ),
      ],
    );
  }
}

// SOLUTION 3: Use ValueNotifier + ValueListenableBuilder
class HomePage extends StatelessWidget {
  final counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    print('HomePage build'); // Builds once

    return Column(
      children: [
        ExpensiveWidget1(), // Builds once
        ExpensiveWidget2(), // Builds once
        ValueListenableBuilder<int>(
          valueListenable: counter,
          builder: (context, value, child) {
            print('Counter rebuild'); // Only this rebuilds
            return Text('$value');
          },
        ),
        ElevatedButton(
          onPressed: () => counter.value++,
        ),
      ],
    );
  }
}

// SOLUTION 4: Use RepaintBoundary for complex widgets
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary( // Isolates repainting
          child: ExpensiveWidget(),
        ),
        CounterWidget(),
      ],
    );
  }
}
```

### shouldRebuild Optimization

```dart
// For InheritedWidget
class MyInheritedWidget extends InheritedWidget {
  final int data;

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return data != old.data; // Only notify if data changes
  }
}

// For ListView items
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(post.title),
    );
  }
}

// Use keys for list items
ListView.builder(
  itemCount: posts.length,
  itemBuilder: (context, index) {
    return PostCard(
      key: ValueKey(posts[index].id), // Prevents unnecessary rebuilds
      post: posts[index],
    );
  },
);
```

### Build Performance Checklist

```dart
// ✅ 1. Use const constructors everywhere possible
const Text('Hello');
const SizedBox(height: 10);
const Icon(Icons.star);

// ✅ 2. Extract widgets to reduce build method size
// Bad: 500 line build method
// Good: Many small widgets

// ✅ 3. Avoid creating objects in build
// ❌ Bad
@override
Widget build(BuildContext context) {
  final style = TextStyle(fontSize: 20); // Created every build!
  return Text('Hello', style: style);
}

// ✅ Good
static const style = TextStyle(fontSize: 20); // Created once

@override
Widget build(BuildContext context) {
  return Text('Hello', style: style);
}

// ✅ 4. Use keys for dynamic lists
ListView(
  children: items.map((item) =>
    ItemWidget(key: ValueKey(item.id), item: item)
  ).toList(),
);

// ✅ 5. Avoid setState in build
// ❌ Bad
@override
Widget build(BuildContext context) {
  setState(() {}); // Infinite loop!
  return Container();
}

// ✅ 6. Use builder methods for conditional widgets
Widget _buildContent() {
  if (isLoading) return CircularProgressIndicator();
  if (hasError) return ErrorWidget();
  return ContentWidget();
}

@override
Widget build(BuildContext context) {
  return _buildContent();
}
```

---

## 3. Rendering Performance (60fps)

### Interview Question: "Your app is janky. How do you debug and fix it?"

**Answer:**

```dart
// STEP 1: Enable Performance Overlay
void main() {
  runApp(
    MaterialApp(
      showPerformanceOverlay: true, // Shows FPS graphs
      home: HomePage(),
    ),
  );
}

// STEP 2: Use Flutter DevTools Timeline
// - Record timeline
// - Look for frames > 16ms
// - Identify expensive operations

// COMMON CAUSES OF JANK:

// ❌ CAUSE 1: Expensive operations in build
@override
Widget build(BuildContext context) {
  final sorted = items.sort(); // Expensive! Runs on every build
  return ListView(children: sorted);
}

// ✅ FIX: Cache expensive computations
late final List<Item> sortedItems;

@override
void initState() {
  super.initState();
  sortedItems = items.sort(); // Once
}

// ❌ CAUSE 2: Synchronous I/O in build
@override
Widget build(BuildContext context) {
  final data = File('data.txt').readAsStringSync(); // BLOCKS UI!
  return Text(data);
}

// ✅ FIX: Use FutureBuilder
@override
Widget build(BuildContext context) {
  return FutureBuilder<String>(
    future: File('data.txt').readAsString(),
    builder: (context, snapshot) {
      if (snapshot.hasData) return Text(snapshot.data!);
      return CircularProgressIndicator();
    },
  );
}

// ❌ CAUSE 3: Opacity animations
AnimatedOpacity( // Expensive!
  opacity: isVisible ? 1.0 : 0.0,
  child: ExpensiveWidget(),
);

// ✅ FIX: Use AnimatedSwitcher or visibility
if (isVisible) ExpensiveWidget();
// Or
Visibility(
  visible: isVisible,
  child: ExpensiveWidget(),
);

// ❌ CAUSE 4: ClipPath/ClipRRect without saveLayer
ClipRRect( // Can be expensive
  borderRadius: BorderRadius.circular(10),
  child: ComplexWidget(),
);

// ✅ FIX: Use Container with decoration
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  child: ComplexWidget(),
);

// ❌ CAUSE 5: Large widget trees
Column(
  children: List.generate(1000, (i) => ListTile()), // All rendered!
);

// ✅ FIX: Use ListView.builder
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(), // Only visible items
);
```

### RepaintBoundary Strategy

```dart
// Use RepaintBoundary to isolate expensive paints
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: Header(), // Won't repaint when body updates
        ),
        RepaintBoundary(
          child: Body(), // Won't repaint when header updates
        ),
      ],
    );
  }
}

// Use for:
// 1. Static content (headers, footers)
// 2. Complex graphics (charts, graphs)
// 3. Animated widgets that don't affect siblings
// 4. List items in long lists

// DON'T overuse:
// - Every widget doesn't need it
// - Has memory overhead
// - Profile before and after
```

### Animation Performance

```dart
// ❌ BAD: Animating size/position
AnimatedContainer(
  width: isExpanded ? 200 : 100,
  child: ComplexWidget(), // Relayouts on every frame!
);

// ✅ GOOD: Animating transform
Transform.scale(
  scale: isExpanded ? 2.0 : 1.0,
  child: ComplexWidget(), // No relayout!
);

// ❌ BAD: Implicit animations everywhere
AnimatedOpacity(...);
AnimatedPositioned(...);

// ✅ GOOD: Single AnimationController
class _MyState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _position = Tween<Offset>(begin: Offset.zero, end: Offset(1, 0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _position.value,
          child: Opacity(
            opacity: _opacity.value,
            child: ComplexWidget(),
          ),
        );
      },
    );
  }
}

// Use Curves for natural animations
CurvedAnimation(
  parent: _controller,
  curve: Curves.easeInOut, // Smoother than linear
);
```

---

## 4. Startup Time Optimization

### Interview Question: "How do you reduce app startup time?"

**Answer:**

```dart
// MEASURE FIRST
void main() {
  final stopwatch = Stopwatch()..start();

  runApp(MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    print('Startup time: ${stopwatch.elapsedMilliseconds}ms');
  });
}

// OPTIMIZATION STRATEGIES:

// 1. Lazy initialization
class Services {
  // ❌ BAD: Initialize all on app start
  static final database = Database();
  static final analytics = Analytics();
  static final crashReporter = CrashReporter();

  // ✅ GOOD: Lazy initialization
  static Database? _database;
  static Database get database {
    _database ??= Database();
    return _database!;
  }
}

// 2. Deferred loading
import 'package:my_package/my_package.dart' deferred as my_package;

Future<void> loadFeature() async {
  await my_package.loadLibrary();
  my_package.useFeature();
}

// 3. Async initialization in parallel
Future<void> initializeApp() async {
  await Future.wait([
    initDatabase(),
    initAnalytics(),
    initCrashReporter(),
  ]); // All in parallel
}

// 4. Show splash screen immediately
void main() async {
  // Show native splash first
  runApp(SplashScreen());

  // Initialize in background
  await initializeApp();

  // Show real app
  runApp(MyApp());
}

// 5. Reduce initial widget tree size
// ❌ BAD: Load everything on start
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        child: ComplexWidget(
          child: AnotherComplexWidget(), // All loaded on start
        ),
      ),
    );
  }
}

// ✅ GOOD: Lazy load screens
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Simple
      routes: {
        '/home': (context) => HomePage(), // Loaded when needed
      },
    );
  }
}
```

---

## 5. Network & I/O Performance

### Interview Question: "How do you optimize network performance?"

**Answer:**

```dart
// 1. HTTP/2 with connection pooling
final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 10),
  ),
);

// Enable HTTP/2
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    (client) {
  client.connectionTimeout = Duration(seconds: 5);
  return client;
};

// 2. Request deduplication
class RequestDeduplicator {
  final _pending = <String, Future>{};

  Future<T> execute<T>(String key, Future<T> Function() request) {
    if (_pending.containsKey(key)) {
      return _pending[key] as Future<T>;
    }

    final future = request();
    _pending[key] = future;

    future.whenComplete(() => _pending.remove(key));

    return future;
  }
}

// Usage
final user = await deduplicator.execute(
  'user_123',
  () => api.getUser('123'),
); // Multiple calls return same Future

// 3. Request batching
class RequestBatcher {
  final _batch = <String>[];
  Timer? _timer;

  Future<List<User>> getUsers(List<String> ids) async {
    _batch.addAll(ids);

    if (_batch.length >= 10) {
      return await _flush();
    }

    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 100), _flush);

    // Return future that completes when batch sent
    return _completer.future;
  }

  Future<List<User>> _flush() async {
    final ids = _batch.toList();
    _batch.clear();

    return await api.getBatchUsers(ids);
  }
}

// 4. Compression
final dio = Dio();
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Accept-Encoding'] = 'gzip';
      handler.next(options);
    },
  ),
);

// 5. Caching strategy
class CachedApi {
  final _cache = <String, CacheEntry>{};

  Future<T> get<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration ttl = const Duration(minutes: 5),
  }) async {
    final cached = _cache[key];

    if (cached != null && !cached.isExpired) {
      return cached.data as T;
    }

    final data = await fetcher();
    _cache[key] = CacheEntry(data, DateTime.now().add(ttl));

    return data;
  }
}

// 6. Prefetching
class Prefetcher {
  void prefetchNextPage(int currentPage) {
    // Fetch next page in background
    api.getPage(currentPage + 1).then((data) {
      cache.save('page_${currentPage + 1}', data);
    });
  }
}

// 7. Retry with exponential backoff
Future<T> retryWithBackoff<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
}) async {
  int attempt = 0;

  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempt++;

      if (attempt >= maxAttempts) rethrow;

      await Future.delayed(
        Duration(seconds: pow(2, attempt).toInt()),
      );
    }
  }
}
```

---

## 6. Battery Optimization

```dart
// 1. Reduce location updates frequency
StreamSubscription? _locationSubscription;

void startTracking() {
  final batteryLevel = await Battery().batteryLevel;

  LocationSettings settings;
  if (batteryLevel < 20) {
    settings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100, // Only update every 100m
    );
  } else {
    settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
  }

  _locationSubscription = Geolocator.getPositionStream(
    locationSettings: settings,
  ).listen(_onLocationUpdate);
}

// 2. Batch network requests
// Don't: Make request on every change
// Do: Batch changes and send periodically

// 3. Use WorkManager for background tasks
// Don't: Keep app running in background
// Do: Schedule work with constraints

// 4. Reduce animation frame rate
// Don't: 60fps animation when in background
// Do: Pause or reduce fps

// 5. Use efficient image formats
// WebP > PNG > JPEG for most cases
```

---

## 7. Performance Debugging Workflow

```
1. Enable Performance Overlay
   ↓
2. Identify Jank (red bars)
   ↓
3. Use Timeline in DevTools
   ↓
4. Identify Expensive Operations
   ↓
5. Profile Memory Usage
   ↓
6. Implement Fixes
   ↓
7. Measure Again (Compare)
   ↓
8. Repeat
```

### Key Metrics to Track

```dart
// 1. Frame rendering time (Target: <16ms)
// 2. Memory usage (Target: <200MB)
// 3. App startup time (Target: <2s)
// 4. Network request time (Target: <1s)
// 5. Database query time (Target: <100ms)
```

---

## 8. Common Interview Questions & Answers

**Q: "How do you profile memory in Flutter?"**

A: Use Flutter DevTools:

1. Open Memory tab
2. Take snapshot before navigation
3. Navigate and use feature
4. Take snapshot after
5. Compare snapshots
6. Look for objects that should be GC'd
7. Fix leaks by ensuring proper disposal

**Q: "What causes jank in Flutter?"**

A: Main causes:

1. Expensive build methods
2. Synchronous I/O in build
3. Large widget trees without builders
4. Opacity/ClipPath animations
5. Missing RepaintBoundary
6. Not using const constructors

**Q: "How do you optimize ListView performance?"**

A:

1. Use ListView.builder (lazy loading)
2. Use const constructors for items
3. Add RepaintBoundary to complex items
4. Implement cacheExtent for prefetching
5. Use keys for dynamic lists
6. Avoid expensive computations in itemBuilder

---

## Resources

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [DevTools Documentation](https://docs.flutter.dev/tools/devtools)
- [Memory Profiling](https://docs.flutter.dev/tools/devtools/memory)

**Remember:** Always measure before and after optimizations. Don't optimize prematurely!

Good luck! 🚀
