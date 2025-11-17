# WHAT I NEED FROM YOU

## Mission

Create a comprehensive Master App (iOS, Android) (or multiple apps if necessary) that implements ALL topics in this roadmap document through practical, master/professional/expert-level Flutter code.

## Requirements

### 1. App Architecture

- Analyze this roadmap and design one master Flutter application (or multiple if one app cannot realistically cover all topics)
- The app must be a **real, functional application** - not a demo or tutorial collection
- Each feature should demonstrate multiple related concepts from the roadmap
- Use production-grade architecture (Clean Architecture + BLoC/Riverpod)

### 2. Step-by-Step Implementation Guide

For each feature/module, provide:

**a) Planning Phase:**

- Which roadmap topics this feature covers
- Why this approach was chosen
- Architecture diagram for the feature

**b) Implementation Phase:**

- File structure to create (exact paths)
- Complete code for each file
- Line-by-line explanation of complex parts
- How this code demonstrates the specific topics

**c) Concept Explanation:**

- Deep dive into the underlying concepts
- Common interview questions about this topic
- Best practices and anti-patterns
- Performance considerations

**d) Testing:**

- Unit tests, widget tests, integration tests
- How to verify it works correctly

### 3. Interview Readiness

After completing each module, provide:

- 5-10 interview questions about the concepts used
- Expected answers with code examples
- Common follow-up questions interviewers ask
- Live coding scenarios related to this topic

### 4. Code Quality Standards

- Production-ready code (not simplified examples)
- Proper error handling and edge cases
- Performance optimizations implemented
- Comments explaining "why" not just "what"
- Follows Flutter/Dart best practices

### 5. Coverage Verification

- Track which roadmap topics have been covered
- Ensure no topic is missed
- Show connections between related topics

## Output Format

For each feature, structure your response as:

```
## Feature: [Name]
### Topics Covered: [List from roadmap]
### Architecture Overview: [Diagram/explanation]
### Files to Create:
#### File: lib/features/[feature]/[file].dart
[Complete code with explanations]
### Concept Deep Dive:
[Detailed explanation of concepts]
### Interview Prep:
[Questions and answers]
### Testing:
[Test code and verification steps]
```

## Success Criteria

After completing this master app, I should be able to:

1. ✅ Implement any feature from scratch without looking at references
2. ✅ Explain the underlying concepts clearly in interviews
3. ✅ Answer advanced Flutter questions with code examples
4. ✅ Pass live coding rounds at FAANG companies
5. ✅ Justify architectural decisions with trade-offs

## Deliverables

1. **Master App(s)** - Complete, runnable Flutter application(s)
2. **Implementation Guide** - Step-by-step instructions with explanations
3. **Concept Documentation** - Deep dives into each topic
4. **Interview Preparation** - Questions, answers, and coding scenarios
5. **Testing Suite** - Comprehensive tests for all features

## Important Notes

- Prioritize **understanding over completion speed**
- Each topic should be implemented the way a Senior/Staff engineer would do it
- Code should be production-ready, not tutorial-quality
- Assume I want to learn **expert-level patterns**, not beginner shortcuts
- When there are multiple approaches, explain trade-offs and pick the best one

---

**START BY:**

1. Analyzing the entire roadmap
2. Proposing an app architecture that can cover all topics naturally
3. Breaking it down into logical modules/features
4. Getting my approval before starting implementation

---

```
Condider above as a text and below as a file when submit to AI
```

---

# Mission: Transform into a Top 1% Flutter Developer & Land $200K-$500K+ Silicon Valley Offers

## 🎯 Core Objective

Create a master mobile App (Android and iOS)
I suggest one app but if you suggest that in one app all these topics can not cover so do it in more than one app.

---

## 📊 Current Profile

**Experience:**

- 6+ years mobile development (5 years Flutter, 1.5 years React Native)
- Senior Flutter Developer & Project Lead
- Managing 6-person engineering team + production servers
- Delivered 10+ apps including 1M+ user app (Quranly)
- Full-stack capabilities: Flutter, Rails, DevOps
- Location: Karachi, Pakistan

---

# PART 1: MASTERY ROADMAP - Technical Deep Dives

## 1. Widget System & Rendering Pipeline

### Widget Fundamentals Deep Dive

**Study Topics:**

- StatelessWidget vs StatefulWidget lifecycle (not just basics - memory implications)
- InheritedWidget and data propagation patterns
- Widget vs Element vs RenderObject tree structure
- BuildContext: what it really is and why it matters
- Keys: GlobalKey, ValueKey, ObjectKey, UniqueKey (when and why)

**Hands-on Exercise:**
Build a custom complex widget that demonstrates lifecycle management. Create a widget that:

- Manages multiple child states
- Implements custom shouldRebuild logic
- Uses keys effectively for list reordering

**Resources:**

- Flutter source code: `framework/lib/src/widgets/framework.dart`
- "Flutter Internals" by Didier Boelens
- Flutter Widget of the Week (all episodes)

### RenderObject, Rendering Pipeline & Custom Painting

**Study Topics:**

- RenderObject lifecycle: layout, paint, hit testing
- Constraints: understanding BoxConstraints, tight vs loose
- Custom RenderBox creation
- Multi-child layout protocols (RenderFlex, RenderStack patterns)
- Painting optimization: Master repaint boundaries, layers

**Hands-on Exercise:**
Create 3 custom render objects:

1. Custom layout (like a Pinterest-style masonry grid)
2. Custom painter with complex clipping and effects
3. Interactive render object with gesture handling

**Deep Dive Questions to Master:**

- What happens when you call setState()?
- Explain the three-tree architecture (Widget/Element/RenderObject)
- When does Flutter create new widgets vs reusing elements?
- How does Flutter decide what needs repainting?

### Flutter Engine Internals & Performance

**Study Topics:**

- Dart VM and AOT compilation
- Skia graphics engine basics
- Platform channels architecture
- Concurrency, Isolates and background computation
- GPU/CPU performance profiling

**Hands-on Exercise:**

- Profile a complex app using DevTools
- Identify and fix 5 performance bottlenecks
- Create comparison benchmarks (before/after)
- Write custom DevTools timeline events

**Tools to Master:**

- Flutter DevTools (Performance, Memory, Network tabs)
- Observatory
- Chrome DevTools for Flutter Web
- Xcode Instruments / Android Profiler

---

## 2. State Management at Scale

### BLoC Pattern Mastery

**Advanced Topics:**

- Event transformation (debounce, throttle, switch)
- Complex state trees and nested BLoCs
- BLoC to BLoC communication patterns
- Testing strategies for BLoCs
- Error handling and recovery
- BLoC lifecycle management

**Project:**
Build a complex feature using BLoC:

- Real-time search with debouncing
- Paginated data loading with caching
- Optimistic updates and rollback
- Multiple concurrent operations

**Anti-patterns to Avoid:**

- BLoC in BLoC creation
- Tight coupling between BLoCs
- Not disposing streams
- Overly complex event hierarchies

### Riverpod Deep Dive

**Advanced Topics:**

- Provider composition patterns
- Auto-dispose vs manual lifecycle
- Family modifiers and parametrized providers
- AsyncValue handling patterns
- Provider overrides for testing
- Code generation with riverpod_generator

**Project:**
Migrate part of a BLoC app to Riverpod:

- Compare approaches
- Document trade-offs
- Measure performance differences
- Create migration guide

### State Architecture Decision Matrix

**Create comprehensive guide:**

| Scenario                | Recommended Approach | Why                     |
| ----------------------- | -------------------- | ----------------------- |
| Small app (<10 screens) | Provider / Riverpod  | Simple, built-in        |
| Large app (enterprise)  | BLoC + Repository    | Testability, separation |
| Real-time features      | BLoC with streams    | Natural fit             |
| Form-heavy app          | Riverpod + Freezed   | Less boilerplate        |
| Multi-platform team     | Redux                | Familiar pattern        |

**State Restoration:**

- Implement state restoration in 3 different patterns
- Handle process death scenarios
- Persist navigation state

---

## 3. Architecture & Design Patterns

### Clean Architecture for Flutter

**Layers to Master:**

1. **Presentation Layer:**

   - UI (Widgets)
   - State Management (BLoC/Riverpod)
   - View Models

2. **Domain Layer:**

   - Entities
   - Use Cases (Interactors)
   - Repository Interfaces

3. **Data Layer:**
   - Repository Implementations
   - Data Sources (Remote, Local)
   - Models and Mappers

**Project Structure:**

```
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── utils/
│   └── usecases/
├── features/
│   ├── feature_1/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
```

**Exercise:**
Refactor an existing project to Clean Architecture:

- Document all layers
- Create dependency flow diagrams
- Write integration tests across layers

### Advanced Patterns

**MVVM Implementation:**

- ViewModel responsibilities
- Data binding patterns
- Navigation handling

**Repository Pattern:**

- Local and remote data source orchestration
- Caching strategies
- Error handling and retry logic

**Dependency Injection:**

- GetIt setup and best practices
- Injectable code generation
- Testing with DI

**Modularization:**

- Feature modules
- Shared modules
- Plugin architecture
- Dynamic feature modules (code on demand)

---

## 4. Performance Optimization

### Memory Management

**Topics:**

- Memory leak detection with DevTools
- Common leak sources (listeners, streams, controllers)
- Image caching and memory
- Large list handling (ListView.builder vs ListView.separated)
- dispose() patterns

**Optimization Checklist:**

- [ ] All controllers disposed
- [ ] Stream subscriptions cancelled
- [ ] Image cache properly sized
- [ ] No retained references in closures
- [ ] Proper use of const constructors

**Exercise:**
Audit an app for memory leaks:

1. Profile memory usage over time
2. Identify leaks using DevTools
3. Fix all leaks
4. Document before/after metrics

### Build Time & Startup Optimization

**Build Time:**

- Const constructors (understand deeply)
- RepaintBoundary strategic placement
- Widget rebuilding analysis
- shouldRebuild optimization

**Startup Time:**

- Lazy initialization patterns
- Deferred component loading
- Asset preloading strategies
- Native splash screen optimization

**Metrics to Track:**

- Time to first frame
- Time to interactive
- Cold start vs warm start
- Build times in debug vs release

### Animation Performance

**60fps Guarantees:**

- Avoid jank: the 16ms rule
- Rasterization optimization
- Shader compilation jank
- Animation best practices (AnimatedBuilder vs AnimatedWidget)

**Advanced Animation:**

- Custom implicit animations
- Chained animations
- Hero animations with transforms
- Rive/Lottie integration and optimization

**Project:**
Create silky-smooth animations:

- Complex page transitions
- Interactive gestures
- 120fps on supported devices
- Measure with Performance overlay

---

## 5. Platform Integration

### Method Channels Deep Dive

**Topics:**

- MethodChannel, EventChannel, BasicMessageChannel
- Platform-specific implementations (iOS/Android)
- Binary data handling
- Error handling across platform boundaries
- Performance considerations

**Exercise:**
Create 3 platform integrations:

1. Camera with custom controls (MethodChannel)
2. Real-time sensor data (EventChannel)
3. Native UI component wrapper

**Native Code Required:**

- **iOS:** Swift basics, UIKit fundamentals
- **Android:** Kotlin basics, Android SDK

### FFI & Performance Critical Code

**Topics:**

- Dart FFI fundamentals
- C/C++ integration
- When to use FFI vs platform channels
- Memory management in FFI
- Async FFI calls

**Use Cases:**

- Image processing
- Cryptography
- ML model inference
- High-performance computations

**Project:**
Implement a performance-critical feature using FFI:

- Benchmark against pure Dart
- Compare with platform channel approach
- Document trade-offs

---

## 6. Testing & Quality

### Testing Strategy

**Unit Testing:**

- Test-first development approach
- Mocking with Mockito
- Test coverage: aim for 80%+ on business logic
- Testing async code
- Testing streams

**Widget Testing:**

- Finding widgets in tests
- Interaction testing (taps, scrolls, gestures)
- Testing animations
- Golden tests for UI regression
- Testing responsive layouts

**Integration Testing:**

- End-to-end test scenarios
- Testing with real backend (or mock server)
- Performance testing
- Screenshot testing across devices

**Testing Pyramid:**

```
        /\
       /  \    E2E Tests (10%)
      /____\
     /      \  Integration Tests (20%)
    /________\
   /          \ Unit Tests (70%)
  /____________\
```

### CI/CD Pipeline

**Setup:**

- GitHub Actions workflow
- Codemagic configuration
- Automated testing on PR
- Automated deployment (TestFlight, Play Internal Testing)
- Version management and changelog

**Pipeline Stages:**

1. Lint and format check
2. Unit tests
3. Widget tests
4. Integration tests
5. Build (iOS/Android)
6. Deploy to testing tracks
7. Notify team

**Exercise:**
Set up complete CI/CD for a project:

- Document entire pipeline
- Implement automated releases
- Add badge to README

---

## 7. Advanced Differentiators (Top 1%)

### Accessibility (a11y)

**Why This Matters:**
Companies like Google and Apple care deeply about accessibility. This is a major differentiator.

**Topics:**

- Semantic widgets (Semantics widget)
- Screen reader support (TalkBack, VoiceOver)
- Sufficient contrast ratios
- Touch target sizes (minimum 44x44)
- Dynamic text sizing
- Focus management
- Accessibility testing

**Project:**
Make an app fully accessible:

- Audit with accessibility scanner
- Test with screen readers
- Support dynamic font scaling
- Document accessibility features

### Internationalization & Localization

**Topics:**

- intl package and ARB files
- Code generation for translations
- RTL support
- Date, number, currency formatting
- Plurals and gender
- Managing translations at scale

**Project:**
Fully localize an app:

- Support 5+ languages including RTL (Arabic)
- Implement language switching
- Handle all date/number formats
- Test in all locales

### Security Best Practices

**Topics:**

- Secure storage (flutter_secure_storage)
- Certificate pinning
- Encryption at rest and in transit
- Obfuscation and code security
- Jailbreak/root detection
- API key management
- OAuth2 implementation
- Biometric authentication

**Exercise:**
Security audit of an app:

- Identify vulnerabilities
- Implement security hardening
- Document security measures
- Penetration testing

### Code Generation & Meta-programming

**Tools:**

- build_runner
- freezed (immutable models)
- json_serializable
- injectable (DI)
- retrofit (API clients)
- Custom code generators

**Why This Matters:**

- Reduces boilerplate
- Catches errors at compile time
- Industry standard in large codebases

**Project:**
Create a project using extensive code generation:

- Freezed for all models
- Injectable for DI
- Retrofit for API
- Document build process

### Multi-Platform (Web & Desktop)

**Topics:**

- Platform-specific widgets
- Responsive design patterns
- Keyboard shortcuts (desktop)
- Mouse hover states
- Window management
- Platform-specific features

**Project:**
Build a cross-platform app:

- Works well on mobile, web, and desktop
- Adaptive UI for each platform
- Platform-specific features
- Single codebase

### Offline-First Architecture

**Topics:**

- Sync strategies (optimistic, pessimistic)
- Conflict resolution
- Local database (Drift/Moor, Hive, Isar)
- Queue-based sync
- Handling network transitions
- Background sync

**Project:**
Build offline-first app:

- Full offline functionality
- Sync when online
- Handle conflicts
- Show sync status

---

# PART 2: SYSTEM DESIGN FOR MOBILE

## Mobile System Design Framework

### The DACE Framework

**D** - Define Requirements  
**A** - API/Architecture Design  
**C** - Core Components  
**E** - Edge Cases & Optimization

## 10 Essential Mobile System Design Questions

### 1. Design WhatsApp/Messaging App

**Functional Requirements:**

- 1:1 messaging
- Group chats
- Media sharing (images, videos)
- Read receipts
- Typing indicators
- Push notifications
- Offline message sending

**Non-Functional Requirements:**

- Low latency (<100ms message delivery)
- High availability
- End-to-end encryption
- Efficient battery usage
- Works on 2G networks

**Mobile Architecture:**

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Chat List, Chat Screen, Compose)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Business Logic Layer        │
│   (Chat Manager, Message Manager,   │
│    Media Manager, Sync Manager)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Data Layer                │
│  ┌────────────┬──────────────────┐  │
│  │ Local DB   │  Remote Service  │  │
│  │ (SQLite)   │  (WebSocket/HTTP)│  │
│  └────────────┴──────────────────┘  │
└─────────────────────────────────────┘
```

**Key Components:**

1. **Message Queue System:**

   - Local queue for offline messages
   - Retry mechanism with exponential backoff
   - Priority queue (messages > media)

2. **WebSocket Connection Manager:**

   - Automatic reconnection
   - Heartbeat mechanism
   - Connection quality monitoring
   - Fallback to HTTP polling

3. **Local Database Schema:**

```dart
Table: messages
- id (primary key)
- conversation_id (foreign key)
- sender_id
- content (encrypted)
- timestamp
- status (sent/delivered/read)
- media_url
- sync_status (pending/synced)

Table: conversations
- id (primary key)
- type (1:1/group)
- participants
- last_message_id
- unread_count
```

4. **Media Handling:**

   - Thumbnail generation
   - Progressive upload (chunked)
   - Compression before upload
   - CDN for retrieval
   - Local caching strategy

5. **Encryption:**

   - End-to-end encryption (Signal Protocol)
   - Key exchange mechanism
   - Secure key storage

6. **Push Notifications:**
   - FCM/APNS integration
   - Silent notifications for data sync
   - Payload encryption
   - Notification batching

**Performance Optimizations:**

- Pagination (load 50 messages at a time)
- Message virtualization (RecyclerView pattern)
- Image lazy loading
- Background sync with WorkManager
- Differential sync (only new data)

**Edge Cases:**

- What if user changes devices?
- How to handle message deletion?
- How to sync when offline for days?
- Handling time zone differences
- Dealing with spam/abuse

---

### 2. Design Instagram/Photo Sharing App

**Functional Requirements:**

- Photo/video upload
- Feed (infinite scroll)
- Stories
- Likes, comments
- User profiles
- Explore page
- Direct messaging

**Mobile-Specific Challenges:**

- Large media files
- Smooth scrolling feed
- Image loading and caching
- Battery efficiency
- Storage management

**Architecture:**

**Feed System:**

```dart
class FeedManager {
  // Pagination strategy
  Future<List<Post>> loadFeed({
    String? cursor,
    int limit = 20,
  }) async {
    // Check cache first
    final cached = await _cache.getFeed(cursor);
    if (cached.isNotEmpty && !_shouldRefresh()) {
      return cached;
    }

    // Fetch from network
    final posts = await _api.getFeed(cursor, limit);

    // Cache for offline
    await _cache.saveFeed(posts);

    // Preload images
    _preloadImages(posts);

    return posts;
  }

  void _preloadImages(List<Post> posts) {
    for (final post in posts.take(5)) {
      precacheImage(
        NetworkImage(post.imageUrl),
        context,
      );
    }
  }
}
```

**Image Pipeline:**

1. **Upload:**

   - Client-side compression
   - Thumbnail generation
   - Progressive upload (chunked)
   - Background upload service

2. **Storage:**

   - Original: S3/Cloud Storage
   - Processed versions: CDN
   - Multiple resolutions

3. **Download:**
   - Adaptive quality (based on network)
   - Progressive JPEG
   - Caching strategy (LRU)

**Caching Strategy:**

```dart
┌──────────────────────────────────┐
│       Memory Cache (100MB)       │ ← Fast, limited
│  (Recently viewed, current feed) │
└────────────┬─────────────────────┘
             │
┌────────────▼─────────────────────┐
│      Disk Cache (500MB)          │ ← Medium speed
│   (Recent images, thumbnails)    │
└────────────┬─────────────────────┘
             │
┌────────────▼─────────────────────┐
│          Network                 │ ← Slow, unlimited
│      (CDN + Origin Server)       │
└──────────────────────────────────┘
```

**Database Schema:**

```dart
Table: posts
- id
- user_id
- image_url (multiple resolutions)
- caption
- created_at
- likes_count
- comments_count
- is_cached (bool)

Table: feed_cache
- user_id
- post_ids (ordered list)
- cursor
- last_updated
```

**Performance Metrics:**

- Time to first post: <1s
- Scroll FPS: 60fps
- Image load time: <500ms
- Battery drain: <5% per hour

---

### 3. Design Uber/Ride-Sharing App

**Functional Requirements:**

- Real-time location tracking
- Driver matching
- ETA calculation
- Route navigation
- Payment processing
- Ride history

**Mobile Architecture:**

**Location Manager:**

```dart
class LocationManager {
  StreamSubscription? _locationSubscription;

  Stream<Position> trackLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    // Adaptive accuracy based on battery/network
    final adaptiveAccuracy = _calculateAccuracy();

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: adaptiveAccuracy,
        distanceFilter: 10, // meters
      ),
    );
  }

  // Battery optimization
  LocationAccuracy _calculateAccuracy() {
    final batteryLevel = await Battery().batteryLevel;
    if (batteryLevel < 20) {
      return LocationAccuracy.medium;
    }
    return LocationAccuracy.high;
  }
}
```

**Real-Time Communication:**

- WebSocket for live updates
- MQTT for efficient pub/sub
- Fallback to HTTP polling

**Map Integration:**

- Google Maps SDK / Mapbox
- Custom marker clustering
- Route optimization
- Traffic layer
- Offline maps

**State Management:**

```dart
sealed class RideState {}
class Idle extends RideState {}
class RequestingRide extends RideState {}
class DriverMatched extends RideState {
  final Driver driver;
  final Duration eta;
}
class OnTrip extends RideState {
  final Route route;
  final Position currentPosition;
}
class Completed extends RideState {}
```

**Battery Optimization:**

- Reduce location update frequency when idle
- Batch network requests
- Efficient map rendering
- Background service for active rides only

**Offline Handling:**

- Cache recent trips
- Queue payment processing
- Store route data locally
- Sync when online

---

### 4. Design Twitter/Social Media Feed

**Key Challenges:**

- Real-time updates
- Infinite scroll
- Media-rich content
- Engagement (likes, retweets)

**Feed Architecture:**

**Timeline Generation (Client-Side):**

```dart
class TimelineManager {
  final _posts = <Post>[];
  String? _oldestId;
  String? _newestId;

  Future<void> loadNewer() async {
    final newPosts = await _api.getTimeline(
      since: _newestId,
    );

    _posts.insertAll(0, newPosts);
    if (newPosts.isNotEmpty) {
      _newestId = newPosts.first.id;
    }
  }

  Future<void> loadOlder() async {
    final oldPosts = await _api.getTimeline(
      before: _oldestId,
      limit: 20,
    );

    _posts.addAll(oldPosts);
    if (oldPosts.isNotEmpty) {
      _oldestId = oldPosts.last.id;
    }
  }
}
```

**Pull-to-Refresh Strategy:**

- Check for new posts since last fetch
- Show "X new tweets" banner
- Smooth insertion without disrupting scroll
- Background sync

**Real-Time Updates:**

- WebSocket for new posts
- Optimistic UI updates
- Conflict resolution

---

### 5. Design YouTube/Video Streaming App

**Challenges:**

- Large file sizes
- Bandwidth adaptation
- Offline playback
- Smooth playback

**Video Player Architecture:**

**Adaptive Streaming:**

```dart
class VideoStreamManager {
  Future<void> playVideo(String videoId) async {
    // Get available qualities
    final manifest = await _api.getManifest(videoId);

    // Select initial quality based on network
    final quality = _selectQuality(manifest);

    // Start playback
    await _player.setUrl(quality.url);

    // Monitor network and adapt
    _monitorAndAdapt(manifest);
  }

  VideoQuality _selectQuality(Manifest manifest) {
    final bandwidth = await _networkManager.estimateBandwidth();

    if (bandwidth > 5000) return manifest.quality1080p;
    if (bandwidth > 2500) return manifest.quality720p;
    if (bandwidth > 1000) return manifest.quality480p;
    return manifest.quality360p;
  }
}
```

**Caching Strategy:**

- Prefetch next video in playlist
- Cache video metadata
- Progressive download
- LRU eviction

**Offline Downloads:**

- Background download service
- Resume capability
- Storage management
- DRM for premium content

---

### 6-10: Additional System Designs

**6. Design Spotify/Music Streaming**

- Audio streaming optimization
- Playlist sync
- Offline mode
- Crossfade and gapless playback

**7. Design Airbnb/Booking App**

- Search with filters
- Map-based browsing
- Booking flow
- Calendar availability

**8. Design News Aggregator**

- Multi-source aggregation
- Personalization
- Offline reading
- Push notifications

**9. Design E-Commerce App (Amazon)**

- Product catalog
- Search and filters
- Cart and checkout
- Order tracking

**10. Design Fitness Tracker**

- Sensor data collection
- Background tracking
- Data visualization
- Sync with wearables

---

## Mobile System Design Best Practices

### Always Consider:

1. **Network:**

   - Assume unreliable network
   - Implement retry logic
   - Optimize payload size
   - Handle timeouts gracefully

2. **Battery:**

   - Batch operations
   - Reduce GPS usage
   - Optimize wake locks
   - Background task limits

3. **Storage:**

   - Limited space
   - Efficient data structures
   - Cleanup old data
   - User-controlled storage

4. **Performance:**

   - 60fps UI
   - Fast app launch
   - Responsive interactions
   - Efficient rendering

5. **Platform Differences:**
   - iOS vs Android capabilities
   - Platform-specific optimizations
   - Different lifecycle models

### Decision Framework Template

```
Problem: [State the challenge]

Options:
1. Option A
   Pros: ...
   Cons: ...
   When to use: ...

2. Option B
   Pros: ...
   Cons: ...
   When to use: ...

Decision: [Chosen option and rationale]
```

---

# More Topics I want to Master

- Flutter flavours.
- Custom routes like using “extends MaterialPageRoute<T>” and “extends PageTransitionsBuilder” etc.
- Advanced level Navigations
- Expanded vs Flexible.
- Advanced and Custom Gestures / gesture detection.
- Slivers / custom scrolling / vertical scroll then inside it horizontal scroll then inside it vertical scroll.
- ScrollController.
- Extension.
- Object vs Dynamic.
- Widget constraints / layout constraints.
- Map<String, int>.from(decodeTranslationObject.cast<String, int>());
- lazy loading.
- Generic <T>.
- abstract.
- abstract factory design pattern.
- WidgetsFlutterBinding.ensureInitialized()
- What is fromjson, tojson, tostring in the Model class?
- integrationDriver()
- compareTo()
- sealed class.
- assert
- Understand Big O notation to analyze time and space complexity
- Observer pattern
- Singleton pattern
- Be proficient in flutter dev tools, Debugging tools.
- Profile mode
- decoupling
- object pooling
- loose coupling
- SDLC
- Platform-specific UI adaptations
- App size optimization strategies
- Accessibility implementation best practices
- Null-safety
- profiler
- Low-level Rendering
- Enterprise Architecture Patterns
  - Microservices integration patterns
- Strong CS fundamentals: data structures & algorithms + coding interviews (leet code , hacker rank like questions preparations).
- Stripe and other payment methods/options used world wide globally for flutter App.
- caching, authentication, scale & data partitioning for mobile apps.
- Performance: frame budgets, 60 fps, jank, profiling (DevTools), image caching, deferred loading, analytics.
- Integration Architecture\*\*
  - Microservices consumption from mobile
  - GraphQL vs REST for mobile
- Master Canvas and CustomPainter.
- Custom Painting / Custom View / Custom Painter API / Canvas API.
- Garbage collection
- Background processing/tasks/jobs handling strategies
- Advanced animation choreography
- Implement complex animations with physics
- test-driven development (TDD)
- Jenkins / Travis CI.

## System Design Preparation

- Understand the basics of system design principles, such as scalability, reliability, and performance.
- Study common system design patterns and practices, like microservices, caching strategies, load balancing, and database design.

## Practice Common Data Structures and Algorithms

- Stacks and Queues
- Hash Tables
- Data Structures: Arrays, strings, Linked Lists, Trees (binary tree, BST), Graphs (BFS/DFS)
- Algorithms: Sorting, Searching, Dynamic Programming.
- Problem-solving skills in a Dart.
- Learn sorting (quick sort, merge sort), searching (binary search), and other algorithms like recursion and dynamic programming.
- hashmaps, two pointers, sliding window, heaps.

---

## Flutter Technical Concepts — validated improvements

- Engine Internals

  - Confirm understanding of Dart VM, AOT compilation, Skia, and isolates.
  - Include concrete references to Flutter engine components and their roles in rendering and scheduling.

- Rendering Pipeline

  - Clarify the widget lifecycle, layout, paint, compositing, and hit-testing stages.
  - Map how widgets map to RenderObjects and how the pipeline affects frame timing.

- Custom Render Objects

  - Provide guidance to implement custom RenderBox, perform painting, layout, and hit-testing.
  - Include patterns for painting optimization and avoiding layout thrash.

- Memory/Performance Profiling (DevTools)

  - Use DevTools Memory, Performance, and Timeline views to identify leaks and jank.
  - Define steps for capturing baselines, tracking allocations, and confirming fixes.

- Platform Channels (Swift/Kotlin)

  - Demonstrate bidirectional communication between Dart and native code for iOS/Android.
  - Include error handling, serialization, and thread-safety considerations.

- Navigator 2.0 & Declarative Routing

  - Implement declarative routing, page-based state, and back/forward handling.
  - Include examples of Router, RouteInformationParser, and Page objects.

- Build/Codegen

  - Leverage build_runner for codegen and Freezed/JsonSerializable for immutable models.
  - Ensure correct build steps in CI and watch modes during development.

- CI/CD (Fastlane, GitHub Actions)

  - Define pipelines for linting, testing, building, and distributing (TestFlight/Play) with automated release notes.
  - Include environment-specific workflows and secret management.

- Testing Matrix

  - Cover unit, widget, integration, and golden tests with clear success criteria.
  - Define a strategy for golden image stability and updating baselines.

- A/B Testing & Analytics

  - Integrate Firebase or Segment for analytics, with event schemas and user property definitions.
  - Plan A/B experiment flow and telemetry to measure impact.

- Crash Reporting (Sentry)
  - Integrate Sentry for crash reporting, with error boundaries and breadcrumbs.

---

## Memory Management & Performance Optimization

- Memory Management

  - Use const constructors where possible.
  - Properly dispose controllers and cancel streams/subscriptions to avoid leaks.

- Performance Profiling

  - Establish repeatable benchmarks before/after optimizations.
  - Track frame rendering time, jank incidents, and CPU/GPU usage.

- Animation Performance
  - Target 60fps where feasible; optimize for animation curves, unnecessary rebuilds, and compositor layers.

---

## CI/CD Pipeline Stages

- Linting & Formatting

  - Enforce style guides and analyzer rules.

- Testing

  - Run unit tests, widget tests, integration tests, and maintain golden baselines.

- Building

  - Build for iOS and Android with proper signing configurations.

- Deployment
  - Deploy to TestFlight/Play Console and automate release notes and notifications.

---

## Advanced Topics Matrix

- Accessibility

  - Semantic widgets, screen reader support, and appropriate touch targets.

- Security

  - Secure storage, certificate pinning, and secure data handling practices.

- Code Generation

  - Use build_runner/Freezed for models; ensure generated code is checked in or generated as part of CI.

- Multi-Platform Design
  - Responsive UI patterns and adaptive design for mobile, web, and desktop.

---

## System Design for Mobile (DACE Framework)

- Define Requirements

  - Capture user goals, non-functional requirements, and constraints.

- API/Architecture Design

  - Design clear API boundaries, data models, and async/error handling contracts.

- Core Components

  - Identify service layers, data sources, caching, and offline strategies.

- Edge Cases & Optimization
  - Plan for latency, intermittent connectivity, and resource limitations; outline performance tuning steps.

---

## Networking Best Practices

1. Techniques for scalable API handling (e.g., Dio/Retrofit patterns)
2. Caching, retries, exponential backoff, and interceptors
3. Pagination, rate limiting, and request deduplication

---

## Error Handling Strategies

1. Global error boundaries and lifecycle error handling
2. Network failure strategies and validation flows
3. Structured error models and logging

---

## Real-time Features

1. WebSockets for live updates (e.g., chat, presence, live feeds)
2. Stream handling and reconnection strategies

---

## Offline-First and Sync

1. Conflict resolution strategies
2. Background sync, queued writes, and delta updates

---

## Testing Depth

1. Mocking/stubbing with Mockito
2. Golden tests for UI
3. Contract tests for APIs and integration layers

---

## Mobile Security

1. Secure storage, key management, and secrets handling
2. API security hardening and penetration testing basics
3. Authentication/authorization best practices

---

## UX Design Principles

1. Accessibility standards
2. Motion/animation principles for usability
3. Information architecture and usability heuristics

---

### **Advanced Networking & Data Management**

1. Detailed API handling techniques using Dio/Retrofit packages
2. Scaling data management for enterprise applications
3. Real-time features implementation with WebSockets
4. Offline data synchronization strategies

### **Enhanced State Management**

5. Redux implementation for Flutter
6. MobX state management patterns
7. Advanced error handling strategies across app lifecycles
8. Network failure and data validation approaches

### **Testing & Quality Assurance**

9. Advanced mocking techniques with Mockito
10. Comprehensive testing best practices
11. Dependency injection testing strategies

### **Security & Production Readiness**

12. Mobile application security considerations
13. Penetration testing methodologies
14. Secure API implementation practices
15. Advanced user authentication systems

### **Professional Development**

16. UX/UI design principles for Flutter
17. App publishing and distribution strategies (App Store & Google Play)
18. Marketing best practices for mobile apps

---

Claude Sonnet 4.5 (Anthropic) PAID
(the GPT-4.1 “developer/coding” model). PAID
