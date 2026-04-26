
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





Your 14-Day Journey:

Day 1: ✅ Q1-Q20 (Fundamentals) ← YOU ARE HERE
Day 2: Q21-Q40 (State Management Deep Dive)
Day 3: Q41-Q60 (BLoC Pattern)
Day 4: Q61-Q80 (Architecture & Performance)
Day 5: Q81-Q100 (Networking & Testing)
Day 6: Q101-Q120 (Advanced Dart)
Day 7: Q121-Q140 (Review & Practice)
Day 8: Q141-Q160 (System Design)
Day 9: Q161-Q180 (Common Mistakes)
Day 10: Q181-Q200 (Behavioral)
Day 11-13: Build complete features
Day 14: Mock interview & polish






Who to target (in this priority order):

HR / Talent / Recruitment people → most likely to act
Engineering Manager / CTO / VP Engineering → decision makers
Flutter / mobile developers → peers who can refer you
Any developer at Convo → even different tech stack, they can still refer






# 🚨 URGENT JOB SEARCH PLAN - Get Hired in 2-4 Weeks

## 💰 WHERE TO APPLY (Companies Hiring from Pakistan)

### **Tier 1: High-Paying Remote ($5K-$8K/month)**

**US-Based Startups:**
1. **Toptal** (platform for top freelancers, $5K-$10K/month)
2. **Turing.com** (AI-vetted jobs, $4K-$8K/month)
3. **Crossover** ($5K-$10K/month, full-time remote)
4. **GitLab** (all-remote, competitive pay)
5. **Automattic** (WordPress, remote-first)

**European Companies:**
6. **Shopify** (hiring in Pakistan region)
7. **Revolut** (fintech, remote roles)
8. **N26** (mobile banking)
9. **Stripe** (payments, remote)

### **Tier 2: Middle East ($4K-$6K/month)**

**UAE-Based:**
10. **Careem** (Uber of Middle East)
11. **Noon** (Amazon of Middle East)
12. **Fetchr** (logistics)
13. **Talabat** (food delivery)

**Saudi Arabia:**
14. **Jahez** (food delivery)
15. **HungerStation**
16. **STC Pay** (fintech)

### **Tier 3: Pakistani Companies Paying Well ($3K-$5K)**

17. **Systems Limited** (multinational clients)
18. **NetSol Technologies**
19. **Arbisoft** (US clients)
20. **Venturedive**
21. **Tkxel**

---

### **Indeed Strategy:**

```
Search: "Senior Flutter Developer"
Filters:
- Remote
- $80,000+ 
- Full-time
- Company: Startup, Tech Company

Apply: 10/day
```

---

### **AngelList/Wellfound Strategy:**

```
1. Create profile
2. Add Quranly (1M+ users) prominently
3. Set salary: $80K-$120K
4. Browse: Remote Flutter jobs
5. Apply: 5-10/day (quality over quantity here)
```

---

## 📧 APPLICATION STRATEGY

### **Daily Schedule:**

```
Morning (9 AM - 11 AM):
= 20 applications/day

Afternoon (2 PM - 4 PM):
- Follow up on yesterday's applications
- Message recruiters

Evening (7 PM - 8 PM):
- Practice 1 interview question
- Update tracking sheet
```

**Target: 100 applications in 5 days = High chance of interviews**

---











# 🚀 COMPLETE JOB HUNTING PACKAGE - READY IN 10 MINUTES!


## 🎯 YOUR #1 SELLING POINT

**Memorize this - use it EVERYWHERE:**

> "I built Quranly, a habit-tracking app that scaled to 1 million users with a 4.8-star rating and 99.7% crash-free rate. I currently lead a 6-person team and have delivered 10+ production apps."

---

## 📞 WHEN RECRUITERS CALL

### **Phone Screen Script:**

**"Tell me about yourself"**

"I'm a Senior Flutter Developer with 6+ years of experience. I recently built Quranly which scaled to 1 million users with a 4.8-star rating. I currently lead a 6-person engineering team at Doozie Labs where we've delivered 10+ production apps.

I'm looking for my next opportunity where I can leverage my experience in scaling mobile applications and leading teams to build impactful products. That's why I'm excited about [Company] - [specific reason related to job posting]."

**"What's your salary expectation?"**

"Based on my research for Senior Flutter Developers with my experience level - 6+ years, proven ability to scale apps to millions of users, and team leadership - I'm looking in the range of $80K-$100K annually. But I'm interested in understanding the complete package including benefits and growth opportunities. What's the budget for this role?"

---

## ✅ SUCCESS CHECKLIST

**Before you sleep tonight, complete:**

- [ ] Applied to 10 LinkedIn jobs
- [ ] Applied to 5 Indeed jobs
- [ ] Applied to 5 AngelList jobs
- [ ] Applied to Toptal
- [ ] Applied to Turing.com
- [ ] Messaged all recruiters
- [ ] Updated tracking sheet

**If you do this, you're ahead of 95% of job seekers! 💪**

---
