# 💻 DAY 1: CODE - Flutter Fundamentals

## 🎯 Today's Mission

Build 5 mini-apps in 3-4 hours that teach Q1-Q20.

**Learning Method:** Code first, understand later!
- Type each app (don't copy-paste!)
- Run it and see it work
- Break it and fix it
- Then understand why it works

---

## 📱 THE 5 MINI-APPS

| App | Time | Teaches | Questions |
|-----|------|---------|-----------|
| 1. Hello World | 20 min | Flutter basics | Q1-Q5 |
| 2. Counter | 30 min | State & setState | Q6-Q8 |
| 3. Form | 45 min | const, final, validation | Q9-Q10 |
| 4. Navigation | 45 min | Future, async/await | Q11-Q15 |
| 5. List & Async | 60 min | ListView, Stream, MediaQuery | Q16-Q20 |

**Total: 3 hours 20 minutes**

---

# 📱 APP 1: HELLO WORLD (20 minutes)

## 🎯 Teaches: Q1-Q5
- Q1: What is Flutter?
- Q2: Hot reload vs hot restart
- Q3: What is BuildContext?
- Q4: What are Keys?
- Q5: StatelessWidget vs StatefulWidget

---

## 💻 Create File: `lib/apps/day1/app1_hello.dart`

**Type this code** (don't copy-paste for better learning):

```dart
import 'package:flutter/material.dart';

/// Q1: This demonstrates what Flutter is - a UI framework
/// runApp() is the entry point that inflates the widget tree
void main() {
  runApp(HelloWorldApp());
}

/// Q5: StatelessWidget - UI that doesn't change
/// Used when widget doesn't need to maintain state
class HelloWorldApp extends StatelessWidget {
  // Q4: Key - unique identifier for widgets
  // Optional but important for performance
  const HelloWorldApp({Key? key}) : super(key: key);

  /// Q3: BuildContext - handle to location of widget in tree
  /// Provides access to theme, media query, navigation, etc.
  @override
  Widget build(BuildContext context) {
    // Q1: MaterialApp provides Material Design framework
    return MaterialApp(
      title: 'Hello World',
      
      // Q3: Theme accessed via BuildContext
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      
      home: HelloScreen(),
    );
  }
}

/// Separate screen widget following best practices
class HelloScreen extends StatelessWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q3: context provides access to MediaQuery
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      // AppBar at top
      appBar: AppBar(
        title: const Text('App 1: Hello World'),
        elevation: 2,
      ),
      
      // Main content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Q4: Without key, Flutter might reuse widget incorrectly
            const Text(
              'Hello, Flutter!',
              key: ValueKey('hello_text'),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Q3: Using context to access theme
            Text(
              'Screen size: ${size.width.toInt()} x ${size.height.toInt()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 40),
            
            // Q2: Hot Reload Demo Button
            ElevatedButton(
              onPressed: () {
                // Q3: Context used for SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Button pressed! Try hot reload (Ctrl+S)'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Test Hot Reload'),
            ),
            
            const SizedBox(height: 20),
            
            // Q9-Q10 Preview: const vs final
            const Text(
              'const: Compile-time constant',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Run App 1

**Method 1: Update main.dart**
```dart
// Replace lib/main.dart with:
export 'apps/day1/app1_hello.dart';
```

Then run:
```bash
flutter run
```

**Method 2: Direct Run (Better for testing)**
```bash
flutter run lib/apps/day1/app1_hello.dart
```

---

## ✅ App 1 Checkpoint

**You should see:**
- [x] Blue app bar with "App 1: Hello World"
- [x] Large "Hello, Flutter!" text
- [x] Screen size displayed
- [x] "Test Hot Reload" button

**Test Hot Reload (Q2):**
1. Change "Hello, Flutter!" to "Hello, World!"
2. Save file (Ctrl+S)
3. See instant update WITHOUT app restart
4. That's **Hot Reload** ⚡

**Test Hot Restart:**
1. Press `R` in terminal where Flutter is running
2. App fully restarts
3. That's **Hot Restart** (full rebuild)

---

## 🎓 What You Learned

**Q1: What is Flutter?**
- Cross-platform UI framework
- Uses Dart language
- Single codebase for iOS/Android/Web
- Widget-based architecture

**Q2: Hot Reload vs Hot Restart**
- Hot Reload: Injects updated code, keeps state (Ctrl+S)
- Hot Restart: Restarts app, loses state (press R)

**Q3: What is BuildContext?**
- Handle to widget's location in tree
- Used to access: Theme, MediaQuery, Navigator, etc.
- Example: `Theme.of(context)`, `MediaQuery.of(context)`

**Q4: What are Keys?**
- Unique identifiers for widgets
- Help Flutter identify which widgets changed
- Types: ValueKey, ObjectKey, GlobalKey, UniqueKey

**Q5: StatelessWidget**
- Immutable widget (doesn't change)
- No state management
- Rebuilds only when parent rebuilds
- Use for static UI

---

# 📱 APP 2: COUNTER (30 minutes)

## 🎯 Teaches: Q6-Q8
- Q6: What is setState?
- Q7: StatefulWidget lifecycle
- Q8: Widget tree vs Element tree

---

## 💻 Create File: `lib/apps/day1/app2_counter.dart`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CounterScreen(),
    );
  }
}

/// Q6-Q7: StatefulWidget - widget with mutable state
/// Has 2 classes: StatefulWidget + State
class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  // Q7: createState() called when widget first inserted into tree
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

/// Q7: State object - mutable state for StatefulWidget
/// Lifecycle: initState → build → dispose
class _CounterScreenState extends State<CounterScreen> {
  // Q6: Mutable state variable
  int _counter = 0;
  String _lifecycleLog = '';

  // Q7: initState() - called once when State object created
  // Good place for initialization (controllers, listeners, etc.)
  @override
  void initState() {
    super.initState();
    _lifecycleLog = 'initState called';
    print('📱 initState: Counter initialized');
  }

  // Q7: didUpdateWidget() - called when parent rebuilds this widget
  @override
  void didUpdateWidget(CounterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('📱 didUpdateWidget: Widget updated');
  }

  // Q7: dispose() - called when State object removed from tree
  // Clean up resources here (controllers, streams, listeners)
  @override
  void dispose() {
    print('📱 dispose: Counter disposed');
    super.dispose();
  }

  // Q6: setState() - tells Flutter to rebuild this widget
  // CRITICAL: Only call setState() when state actually changes!
  void _incrementCounter() {
    setState(() {
      // Q6: This code runs inside setState
      _counter++;
      _lifecycleLog = 'setState called - counter: $_counter';
    });
    
    print('📱 setState: Counter = $_counter');
    print('📱 build() will be called next');
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _lifecycleLog = 'setState called - counter: $_counter';
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _lifecycleLog = 'Counter reset';
    });
  }

  // Q7: build() - called every time setState() is called
  // MUST be fast! No heavy computation here
  @override
  Widget build(BuildContext context) {
    print('📱 build: Rebuilding UI with counter = $_counter');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 2: Counter (StatefulWidget)'),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Q8: Widget tree - logical structure
            // This Text widget is in widget tree
            const Text(
              'Counter Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Q6: This Text rebuilds when setState called
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Lifecycle log
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _lifecycleLog,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrement',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
                
                const SizedBox(width: 20),
                
                // Reset button
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Text('Reset'),
                ),
                
                const SizedBox(width: 20),
                
                // Increment button
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Educational notes
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                children: [
                  Text(
                    '🎓 Learning Points:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• setState() triggers rebuild\n'
                    '• Only UI dependent on state rebuilds\n'
                    '• Check console for lifecycle logs\n'
                    '• Try hot reload - state persists!',
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
```

---

## 🚀 Run App 2

```bash
flutter run lib/apps/day1/app2_counter.dart
```

**Watch the Console Output:**
```
📱 initState: Counter initialized
📱 build: Rebuilding UI with counter = 0
📱 setState: Counter = 1
📱 build: Rebuilding UI with counter = 1
```

---

## ✅ App 2 Checkpoint

**Test These:**
1. [ ] Press + button → counter increases
2. [ ] Press - button → counter decreases
3. [ ] Press Reset → counter goes to 0
4. [ ] Hot Reload (Ctrl+S) → counter value PERSISTS
5. [ ] Hot Restart (R) → counter resets to 0
6. [ ] Check console for lifecycle logs

**setState Experiment:**
1. Change counter to 5
2. Save file (hot reload)
3. Counter KEEPS value of 5
4. This proves setState maintains state!

---

## 🎓 What You Learned

**Q6: What is setState?**
```dart
setState(() {
  _counter++; // Update state
});
// Tells Flutter: "State changed, rebuild UI"
```
- Marks widget as "dirty"
- Schedules rebuild
- Only this widget and children rebuild
- DON'T call for every frame (performance!)

**Q7: StatefulWidget Lifecycle**
```
1. Constructor →
2. initState() (once) →
3. build() (multiple times) →
4. setState() triggers build() →
5. didUpdateWidget() (when parent changes) →
6. dispose() (cleanup)
```

**Q8: Widget Tree vs Element Tree**
- **Widget tree**: Immutable configuration (what you write)
- **Element tree**: Mutable instances (manages state)
- **Render tree**: Actual painting (layout & paint)

**Key Point:** Widgets are cheap to rebuild, Elements are reused!

---

# 📱 APP 3: FORM WITH VALIDATION (45 minutes)

## 🎯 Teaches: Q9-Q10 + Form Handling
- Q9: What is const?
- Q10: const vs final

---

## 💻 Create File: `lib/apps/day1/app3_form.dart`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Q10: final - runtime constant (assigned once)
  // Can be different for each instance
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Q10: final vs const
  // final: Value known at runtime
  final String submittedAt = DateTime.now().toString();
  
  // Q9: const - compile-time constant
  // Same value for all instances, known at compile time
  static const String appTitle = 'User Registration';
  static const int minNameLength = 3;
  
  String _submittedName = '';
  String _submittedEmail = '';

  @override
  void dispose() {
    // Q7: Always dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Q9: const constructor - all fields must be final
  // Widget can be created at compile time
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < minNameLength) {
      return 'Name must be at least $minNameLength characters';
    }
    return null; // Valid
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    
    // Q9: const - email regex pattern is compile-time constant
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(emailPattern);
    
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _submitForm() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submittedName = _nameController.text;
        _submittedEmail = _emailController.text;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Q9: const Text - doesn't change, can be compile-time constant
        title: const Text('App 3: Form (const vs final)'),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20), // Q9: const EdgeInsets
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Q9: const widgets for static content
              const Text(
                appTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30), // Q9: const SizedBox
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 20),
              
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              
              const SizedBox(height: 30),
              
              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Display submitted data
              if (_submittedName.isNotEmpty) ...[
                // Q10: Container with final variables
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submitted Data:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Name: $_submittedName'),
                      const SizedBox(height: 5),
                      Text('Email: $_submittedEmail'),
                      const SizedBox(height: 5),
                      // Q10: final - runtime value
                      Text(
                        'Submitted at: $submittedAt',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 30),
              
              // Educational notes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎓 const vs final:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'const:\n'
                      '• Compile-time constant\n'
                      '• Same for all instances\n'
                      '• Can only use other const values\n'
                      '• Example: const Text("Hello")\n',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'final:\n'
                      '• Runtime constant\n'
                      '• Can be different per instance\n'
                      '• Assigned once, never changed\n'
                      '• Example: final now = DateTime.now()\n',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
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

## 🚀 Run App 3

```bash
flutter run lib/apps/day1/app3_form.dart
```

---

## ✅ App 3 Checkpoint

**Test These:**
1. [ ] Try submitting empty form → See validation errors
2. [ ] Enter name "Jo" (too short) → See error
3. [ ] Enter invalid email "test" → See error
4. [ ] Enter valid data → See success message
5. [ ] Check submitted data display

**const/final Experiment:**
- Look at code: Which uses `const`? Which uses `final`?
- `const EdgeInsets` - same for all widgets
- `final _formKey` - different per instance

---

## 🎓 What You Learned

**Q9: What is const?**
```dart
// const: Compile-time constant
const text = 'Hello';              // Known at compile time
const widget = Text('Hello');      // Widget created once
const padding = EdgeInsets.all(8); // Same instance reused

// When to use const:
const SizedBox(height: 20);  // ✅ Always same
const Icon(Icons.person);    // ✅ Always same
const Text('Static text');   // ✅ Always same
```

**Benefits:**
- Performance (widget reused, not rebuilt)
- Memory efficient (single instance)

**Q10: const vs final**
```dart
// const: Must know value at compile time
const pi = 3.14159;           // ✅ Compile-time constant
const name = 'Flutter';       // ✅ Compile-time constant

// final: Value known at runtime
final now = DateTime.now();   // ✅ Runtime value
final userInput = getInput(); // ✅ Runtime value
final controller = TextEditingController(); // ✅ Created at runtime

// Can't do this:
const now = DateTime.now();   // ❌ Not compile-time
```

**Key Difference:**
- `const`: Value must be known when writing code
- `final`: Value known when code runs

---

# 📱 APP 4: NAVIGATION & ASYNC (45 minutes)

## 🎯 Teaches: Q11-Q15
- Q11: What is Future?
- Q12: What is async/await?
- Q13: What is Stream?
- Q14: FutureBuilder
- Q15: StreamBuilder (preview)

---

## 💻 Create File: `lib/apps/day1/app4_navigation.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const NavigationApp());
}

class NavigationApp extends StatelessWidget {
  const NavigationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation & Async',
      theme: ThemeData(primarySwatch: Colors.orange),
      // Named routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Q11: Future - represents a potential value or error
  // Future<T> completes with value T eventually
  Future<String> fetchUserData() async {
    // Q12: async marks function as asynchronous
    // Can use await inside
    
    print('📡 Fetching user data...');
    
    // Q12: await pauses execution until Future completes
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));
    
    print('✅ Data fetched!');
    return 'John Doe'; // Future completes with this value
  }

  // Q11: Future with error handling
  Future<int> fetchUserAge() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate random error
    if (DateTime.now().second % 2 == 0) {
      throw Exception('Failed to fetch age');
    }
    
    return 25;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 4: Async & Navigation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Async Operations Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),
            
            // Q14: FutureBuilder - builds UI from Future
            const Text(
              'FutureBuilder Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            FutureBuilder<String>(
              // Q14: future - the Future to listen to
              future: fetchUserData(),
              
              // Q14: builder - called when Future state changes
              builder: (context, snapshot) {
                // Q14: snapshot contains Future state
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Future is still loading
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading user data...'),
                      ],
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  // Future completed with error
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                if (snapshot.hasData) {
                  // Future completed successfully
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'User: ${snapshot.data}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }
                
                // Initial state
                return const Text('Tap button to load');
              },
            ),
            
            const SizedBox(height: 30),
            
            // Manual async/await example
            ElevatedButton(
              onPressed: () async {
                // Q12: async callback
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                try {
                  // Q12: await - waits for Future to complete
                  final name = await fetchUserData();
                  final age = await fetchUserAge();
                  
                  Navigator.pop(context); // Close loading dialog
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name is $age years old'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Fetch with async/await'),
            ),
            
            const SizedBox(height: 30),
            
            // Q18: Navigation
            ElevatedButton(
              onPressed: () {
                // Q18: Navigator.push - navigate to new screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailsScreen(),
                  ),
                );
              },
              child: const Text('Navigate to Details'),
            ),
            
            ElevatedButton(
              onPressed: () {
                // Q18: Navigator.pushNamed - using named routes
                Navigator.pushNamed(context, '/details');
              },
              child: const Text('Navigate (Named Route)'),
            ),
            
            const SizedBox(height: 30),
            
            // Educational notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎓 Async Concepts:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Future: Represents eventual value\n'
                    'async: Marks function as asynchronous\n'
                    'await: Waits for Future to complete\n'
                    'FutureBuilder: Builds UI from Future\n'
                    '\n'
                    'ConnectionState:\n'
                    '• none - not started\n'
                    '• waiting - in progress\n'
                    '• active - streaming (Stream only)\n'
                    '• done - completed\n',
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

// Details Screen
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
        // Q18: Back button automatically added
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Details Screen',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Q18: Navigator.pop - go back
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Q18: Navigator.pop with result
                Navigator.pop(context, 'Data from Details');
              },
              child: const Text('Go Back with Result'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Run App 4

```bash
flutter run lib/apps/day1/app4_navigation.dart
```

**Watch Console:**
```
📡 Fetching user data...
(2 seconds pass)
✅ Data fetched!
```

---

## ✅ App 4 Checkpoint

**Test These:**
1. [ ] FutureBuilder shows loading spinner
2. [ ] After 2 seconds, shows user name
3. [ ] "Fetch with async/await" button works
4. [ ] Navigation button goes to details screen
5. [ ] Back button returns to home
6. [ ] Console shows async logs

---

## 🎓 What You Learned

**Q11: What is Future?**
```dart
// Future<T> - value that arrives later
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data'; // Returns Future<String>
}

// Using Future
fetchData().then((data) {
  print(data); // Prints after 2 seconds
});
```

**Q12: What is async/await?**
```dart
// async: Makes function return Future
// await: Pauses until Future completes

Future<void> example() async {
  print('Start');
  
  // Wait for Future to complete
  final result = await fetchData();
  
  print('Result: $result'); // Runs after fetchData completes
}

// Without async/await:
void example() {
  print('Start');
  fetchData().then((result) {
    print('Result: $result');
  });
}
```

**Q13: What is Stream?** (Preview - covered in App 5)
- Future: Single value eventually
- Stream: Multiple values over time

**Q14: FutureBuilder**
```dart
FutureBuilder<String>(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (snapshot.hasData) {
      return Text('Data: ${snapshot.data}');
    }
    return Text('No data');
  },
)
```

---

# 📱 APP 5: LIST & STREAM (60 minutes)

## 🎯 Teaches: Q16-Q20
- Q16: ListView vs ListView.builder
- Q17: SingleChildScrollView vs ListView
- Q18: Navigator (continued)
- Q19: MaterialApp vs CupertinoApp
- Q20: MediaQuery

---

## 💻 Create File: `lib/apps/day1/app5_list_async.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ListApp());
}

class ListApp extends StatelessWidget {
  const ListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q19: MaterialApp - Material Design
    return MaterialApp(
      title: 'List & Stream',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ListScreen(),
    );
    
    // Q19: CupertinoApp - iOS Design
    // return CupertinoApp(
    //   title: 'List & Stream',
    //   theme: CupertinoThemeData(),
    //   home: ListScreen(),
    // );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // Q13: Stream - multiple values over time
  // StreamController manages a stream
  final _messageController = StreamController<String>();
  
  // List for ListView demo
  final List<String> _items = List.generate(20, (i) => 'Item ${i + 1}');
  
  int _messageCount = 0;

  @override
  void initState() {
    super.initState();
    
    // Q13: Simulate real-time messages
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      _messageCount++;
      // Q13: Add data to stream
      _messageController.add('Message $_messageCount at ${DateTime.now().second}s');
    });
  }

  @override
  void dispose() {
    // Q13: Always close stream controllers
    _messageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Q20: MediaQuery - device information
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final orientation = MediaQuery.of(context).orientation;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 5: List & Stream'),
      ),
      
      body: Column(
        children: [
          // Q20: MediaQuery info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MediaQuery Info:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Screen: ${size.width.toInt()} x ${size.height.toInt()}'),
                Text('Orientation: $orientation'),
                Text('Top padding: ${padding.top.toInt()}px (status bar)'),
                Text('Bottom padding: ${padding.bottom.toInt()}px (nav bar)'),
              ],
            ),
          ),
          
          // Q15: StreamBuilder - builds UI from Stream
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'StreamBuilder (Real-time Messages):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                StreamBuilder<String>(
                  // Q15: stream to listen to
                  stream: _messageController.stream,
                  
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Waiting for messages...');
                    }
                    
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    
                    if (snapshot.hasData) {
                      // Q15: Gets called every time stream emits data
                      return Text(
                        '📨 ${snapshot.data}',
                        style: const TextStyle(color: Colors.green),
                      );
                    }
                    
                    return const Text('No messages yet');
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'ListView.builder Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          
          // Q16: ListView.builder - builds items on demand
          // More efficient than ListView for large lists
          Expanded(
            child: ListView.builder(
              // Q16: itemCount - number of items
              itemCount: _items.length,
              
              // Q16: itemBuilder - called for each visible item
              // Only builds what's on screen (lazy loading)
              itemBuilder: (context, index) {
                print('Building item $index'); // See lazy loading
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(_items[index]),
                  subtitle: Text('Index: $index'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Q18: Navigate with data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailView(
                          item: _items[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Add new item
            _items.add('Item ${_items.length + 1}');
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item added! Scroll to bottom'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Detail view for list item
class DetailView extends StatelessWidget {
  final String item;
  final int index;
  
  const DetailView({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Q20: MediaQuery for responsive UI
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail: $item'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                // Q20: Responsive icon size
                size: isSmallScreen ? 80 : 120,
                color: Colors.teal,
              ),
              const SizedBox(height: 20),
              Text(
                item,
                style: TextStyle(
                  // Q20: Responsive text size
                  fontSize: isSmallScreen ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Index: $index'),
              const SizedBox(height: 30),
              
              // Q17: SingleChildScrollView example
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  // Q17: Use when content might overflow
                  // Unlike ListView, renders all children
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'SingleChildScrollView Demo\n\n'
                    'This is a scrollable text container.\n'
                    'Unlike ListView, it renders all content at once.\n'
                    'Use ListView.builder for large lists.\n'
                    'Use SingleChildScrollView for forms or small content.\n\n'
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.\n\n'
                    'More text here to demonstrate scrolling...\n'
                    'Keep scrolling...\n'
                    'Almost there...\n'
                    'End of content!',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
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

## 🚀 Run App 5

```bash
flutter run lib/apps/day1/app5_list_async.dart
```

**Watch Console:**
```
Building item 0
Building item 1
Building item 2
...
(Only visible items built!)
```

---

## ✅ App 5 Checkpoint

**Test These:**
1. [ ] Stream shows messages every 2 seconds
2. [ ] MediaQuery displays screen info
3. [ ] ListView shows 20 items
4. [ ] Scroll list - console shows lazy loading
5. [ ] Tap item - navigates to detail view
6. [ ] Detail view has scrollable text
7. [ ] + button adds new item

**Scroll Experiment:**
- Scroll slowly and watch console
- Only builds items as they come into view
- This is ListView.builder efficiency!

---

## 🎓 What You Learned

**Q15: StreamBuilder**
```dart
// Like FutureBuilder but for Stream
// Rebuilds every time stream emits data

StreamBuilder<String>(
  stream: messageStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!);
    }
    return CircularProgressIndicator();
  },
)
```

**Q16: ListView vs ListView.builder**
```dart
// ListView - builds all items immediately
ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    // ... 1000 items (ALL built immediately)
  ],
)

// ListView.builder - builds on demand (EFFICIENT!)
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    // Only called for visible items
    return ListTile(title: Text('Item $index'));
  },
)
```

**When to use which:**
- Small list (<20): `ListView`
- Large list: `ListView.builder`
- Infinite scroll: `ListView.builder`

**Q17: SingleChildScrollView vs ListView**
```dart
// SingleChildScrollView: Use for forms, small content
SingleChildScrollView(
  child: Column(
    children: [
      TextField(),
      TextField(),
      Button(),
    ],
  ),
)

// ListView: Use for large lists
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(),
)
```

**Q19: MaterialApp vs CupertinoApp**
```dart
// MaterialApp - Android/Material Design
MaterialApp(
  home: Scaffold(), // Material widgets
)

// CupertinoApp - iOS Design
CupertinoApp(
  home: CupertinoPageScaffold(), // Cupertino widgets
)
```

**Q20: MediaQuery**
```dart
// Get device information
final size = MediaQuery.of(context).size;
final padding = MediaQuery.of(context).padding;
final orientation = MediaQuery.of(context).orientation;

// Responsive UI
if (size.width < 600) {
  return MobileLayout();
} else {
  return TabletLayout();
}
```

---

## 🎉 DAY 1 COMPLETE!

### **What You Built:**
- ✅ 5 Working Apps
- ✅ 60+ minutes of coding
- ✅ 1500+ lines of code
- ✅ Covers Q1-Q20

### **What You Can Now Explain:**
- [x] Q1-Q5: Flutter basics, BuildContext, Keys
- [x] Q6-Q8: setState, StatefulWidget lifecycle
- [x] Q9-Q10: const vs final
- [x] Q11-Q15: Future, async/await, FutureBuilder, StreamBuilder
- [x] Q16-Q20: ListView, ScrollView, Navigation, MediaQuery

---

## 📚 NEXT STEP

**Now open: `DAY_01_THEORY.md`**

This afternoon you'll:
- Read the theory behind what you coded
- Answer interview questions using YOUR code
- Practice explaining concepts
- Take a quiz

**Total Day 1 Time: 6-8 hours**
- Morning: 3-4 hours coding ✅
- Afternoon: 2-3 hours theory
- Evening: 1 hour practice

---

## 🐛 Troubleshooting

**Problem: "Package not found"**
```bash
flutter pub get
```

**Problem: "setState called after dispose"**
- Check your dispose() methods
- Use `if (mounted)` before setState

**Problem: "RenderBox overflow"**
- Wrap in SingleChildScrollView
- Or use ListView

**Problem: "Null check error"**
- Add null checks: `value?.method()`
- Or use `!` if you're sure: `value!.method()`

---

**Congratulations! Move to DAY_01_THEORY.md** 🎓
