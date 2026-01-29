# 🧠 DAY 1: QUIZ - Test Your Knowledge

## 🎯 Purpose

Test yourself on Q1-Q20 before moving to Day 2.

**Time: 1 hour**
- Theory Quiz: 30 minutes
- Coding Challenges: 30 minutes

**Scoring:**
- 18-20 correct: Excellent! Ready for Day 2 ✅
- 15-17 correct: Good! Review weak areas
- <15 correct: Review theory again before Day 2

---

## 📝 PART 1: THEORY QUESTIONS (20 questions, 2 min each)

**Answer these WITHOUT looking at your notes:**

### **Q1-Q5: Fundamentals**

**1. What is Flutter?**
- A) A programming language
- B) A UI framework
- C) A database
- D) An operating system

**2. What is the difference between Hot Reload and Hot Restart?**
- A) Hot Reload is faster and keeps state
- B) Hot Restart is faster and keeps state
- C) They're the same thing
- D) Hot Reload doesn't work with StatefulWidgets

**3. What is BuildContext used for?**
- A) To build widgets
- B) To access ancestor widgets in the tree
- C) To store widget state
- D) To handle user input

**4. When should you use Keys?**
- A) Always, for every widget
- B) Never, they're not important
- C) In lists where items can be reordered or deleted
- D) Only with StatefulWidgets

**5. What's the main difference between StatelessWidget and StatefulWidget?**
- A) StatelessWidget is faster
- B) StatefulWidget can change its internal state
- C) StatelessWidget can't have children
- D) StatefulWidget is deprecated

---

### **Q6-Q8: State Management**

**6. What does setState() do?**
- A) Changes widget state and schedules a rebuild
- B) Only changes state without rebuilding
- C) Rebuilds the entire app
- D) Sends state to the server

**7. Which lifecycle method is called only ONCE when a StatefulWidget is created?**
- A) build()
- B) setState()
- C) initState()
- D) dispose()

**8. In the three-tree architecture, which tree is immutable?**
- A) Element tree
- B) Widget tree
- C) Render tree
- D) All of them

---

### **Q9-Q10: const and final**

**9. Which is TRUE about const?**
- A) Value must be known at runtime
- B) Value must be known at compile time
- C) Can be different for each instance
- D) Same as final

**10. Which can you use with DateTime.now()?**
- A) const
- B) final
- C) Both
- D) Neither

---

### **Q11-Q15: Async**

**11. What is a Future?**
- A) A value available immediately
- B) A value that will be available eventually
- C) A stream of values
- D) A widget

**12. What does the 'await' keyword do?**
- A) Pauses execution until Future completes
- B) Makes function run faster
- C) Cancels the Future
- D) Creates a new Future

**13. What's the difference between Future and Stream?**
- A) No difference
- B) Future is single value, Stream is multiple values
- C) Future is faster
- D) Stream is deprecated

**14. When does FutureBuilder rebuild?**
- A) Every frame
- B) When the Future completes
- C) Never
- D) Only when setState is called

**15. When does StreamBuilder rebuild?**
- A) Once, when stream starts
- B) Every time the stream emits data
- C) Only when setState is called
- D) Never

---

### **Q16-Q20: Lists & UI**

**16. When should you use ListView.builder instead of ListView?**
- A) Always
- B) Never
- C) When you have a large list (>20 items)
- D) When you have a small list (<5 items)

**17. When should you use SingleChildScrollView?**
- A) For large lists
- B) For forms and small content that might overflow
- C) Never, always use ListView
- D) Only with Column

**18. What does Navigator.pop() do?**
- A) Removes all screens
- B) Goes back to previous screen
- C) Opens a new screen
- D) Closes the app

**19. What's the difference between MaterialApp and CupertinoApp?**
- A) MaterialApp is for Android, CupertinoApp is for iOS design
- B) They're exactly the same
- C) CupertinoApp is deprecated
- D) MaterialApp is faster

**20. What does MediaQuery provide?**
- A) Only screen size
- B) Device and app window information (size, orientation, padding, etc.)
- C) Only orientation
- D) Network status

---

## 💻 PART 2: CODING CHALLENGES (30 minutes)

**Do these from memory, then compare with your morning code:**

### **Challenge 1: Create a Counter (5 min)**

```dart
// Create a StatefulWidget with a counter that:
// - Starts at 0
// - Has a + button to increment
// - Has a - button to decrement
// - Displays the counter value

// Your code here:
```

---

### **Challenge 2: FutureBuilder (5 min)**

```dart
// Create a FutureBuilder that:
// - Fetches data after 2 seconds
// - Shows loading spinner while waiting
// - Shows error message if it fails
// - Shows the data when successful

// Your code here:
```

---

### **Challenge 3: ListView.builder (5 min)**

```dart
// Create a ListView.builder that:
// - Shows 50 items
// - Each item shows "Item X" where X is the index
// - Has a ListTile with leading, title, and trailing

// Your code here:
```

---

### **Challenge 4: const Optimization (5 min)**

```dart
// Optimize this code by adding const where possible:

Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      SizedBox(height: 20),
      Icon(Icons.home),
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('World'),
      ),
    ],
  );
}

// Your optimized code here:
```

---

### **Challenge 5: MediaQuery Responsive (10 min)**

```dart
// Create a responsive Container that:
// - On mobile (<600px): width=full, padding=16, font=16
// - On tablet (>=600px): width=80%, padding=32, font=20
// - Shows screen size in the container

// Your code here:
```

---

## ✅ ANSWERS

### **Theory Answers:**

1. B (UI framework)
2. A (Hot Reload is faster and keeps state)
3. B (Access ancestor widgets)
4. C (Lists where items can be reordered)
5. B (StatefulWidget can change state)
6. A (Changes state and rebuilds)
7. C (initState - called once)
8. B (Widget tree is immutable)
9. B (Compile-time constant)
10. B (final only)
11. B (Value eventually available)
12. A (Pauses until complete)
13. B (Future single, Stream multiple)
14. B (When Future completes)
15. B (Every stream emission)
16. C (Large lists >20)
17. B (Forms and small content)
18. B (Goes back)
19. A (Material=Android, Cupertino=iOS)
20. B (Device info: size, orientation, padding, etc.)

**Scoring:**
- Count your correct answers
- 18-20: Excellent ✅
- 15-17: Good (review weak areas)
- <15: Review theory again

---

### **Coding Challenge Answers:**

**Challenge 1: Counter**
```dart
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter--;
                    });
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

**Challenge 2: FutureBuilder**
```dart
class FutureExample extends StatelessWidget {
  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded!';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        
        if (snapshot.hasData) {
          return Center(child: Text(snapshot.data!));
        }
        
        return const Center(child: Text('No data'));
      },
    );
  }
}
```

---

**Challenge 3: ListView.builder**
```dart
class ListExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text('Item $index'),
          trailing: const Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
```

---

**Challenge 4: const Optimization**
```dart
Widget build(BuildContext context) {
  return Column(
    children: const [
      Text('Hello'),
      SizedBox(height: 20),
      Icon(Icons.home),
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('World'),
      ),
    ],
  );
}
```

---

**Challenge 5: MediaQuery Responsive**
```dart
class ResponsiveContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    
    final isMobile = width < 600;
    final containerWidth = isMobile ? width : width * 0.8;
    final padding = isMobile ? 16.0 : 32.0;
    final fontSize = isMobile ? 16.0 : 20.0;
    
    return Center(
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isMobile ? 'Mobile Layout' : 'Tablet Layout',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Screen: ${size.width.toInt()} x ${size.height.toInt()}',
              style: TextStyle(fontSize: fontSize - 2),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 FINAL ASSESSMENT

### **Theory Score: ___/20**
### **Coding Score: ___/5**

**Overall Performance:**

**23-25 points: EXCELLENT** 🌟
- You've mastered Day 1 concepts
- Ready for Day 2
- Keep this momentum!

**20-22 points: GOOD** ✅
- You understand most concepts
- Review questions you missed
- Practice coding challenges again
- Ready for Day 2

**15-19 points: FAIR** ⚠️
- You have the basics
- Review theory document again
- Practice more coding
- Consider reviewing Day 1 before moving to Day 2

**<15 points: NEEDS WORK** 📚
- Review theory document thoroughly
- Code all 5 apps again from scratch
- Understand WHY, not just HOW
- Retake quiz tomorrow before Day 2

---

## 🎯 BEFORE DAY 2

**Checklist:**
- [ ] Scored 18+ on theory quiz
- [ ] Completed all coding challenges
- [ ] Can explain Q1-Q20 in your own words
- [ ] Understand your code from this morning
- [ ] Feel confident with async/await
- [ ] Can use MediaQuery for responsive UI

**If all checked:** ✅ Ready for Day 2!

**If not:** Review weak areas before continuing.

---

## 💡 QUICK REVIEW TIPS

**If you struggle with:**

**State Management (Q6-Q8):**
- Re-read App 2 (Counter)
- Practice creating more counters
- Understand setState flow

**Async (Q11-Q15):**
- Re-read App 4 (Navigation)
- Practice FutureBuilder
- Write your own async functions

**Lists (Q16-17):**
- Re-read App 5
- Build a longer list (100+ items)
- Compare ListView vs ListView.builder

**Responsive (Q20):**
- Experiment with MediaQuery
- Resize your emulator
- Build more responsive layouts

---

## 🚀 DAY 2 PREVIEW

**Tomorrow you'll learn:**
- Q21-Q40: Deep state management
- BLoC pattern
- Riverpod
- Provider
- Advanced widget lifecycle

**Preparation:**
- Get good sleep
- Review BLoC basics from interview docs
- Be ready for more complex state management

---

## 🎉 CONGRATULATIONS!

**You completed Day 1!**

**What you achieved:**
- ✅ Built 5 working apps
- ✅ Wrote 1500+ lines of code
- ✅ Learned Q1-Q20
- ✅ Understand async programming
- ✅ Can build responsive UI

**20/200 questions mastered (10%)** 📊

**See you tomorrow for Day 2!** 🚀

---

*Remember: It's not about speed, it's about understanding. Take time to truly grasp these concepts.*
