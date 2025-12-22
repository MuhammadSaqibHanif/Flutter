# Mobile System Design Interview Guide

## Complete FAANG Preparation with Real Questions

Based on actual interviews at Google (L4-L6), Meta (E4-E6), Amazon, Uber

---

## 🎯 Overview

**What is Mobile System Design?**
The process of designing mobile applications and features at scale, considering:

- Client architecture
- API design
- Data flow
- Offline support
- Performance
- Scalability

**Why It Matters:**

- Required for Senior+ positions (L5/E5+)
- Tests architectural thinking
- Shows production experience
- Evaluates trade-off analysis

---

## 📋 The DACE Framework (Use This!)

Every system design interview should follow this structure:

```
D - Define Requirements
A - API/Architecture Design
C - Core Components
E - Edge Cases & Optimization
```

### Time Management (45-60 min interview)

- **D (10 min)**: Clarify scope, requirements
- **A (10 min)**: High-level architecture, APIs
- **C (20 min)**: Deep dive into components
- **E (10 min)**: Edge cases, optimizations

---

## 🏗️ Standard Mobile Architecture Template

Use this as starting point for ANY mobile app:

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │   UI     │  │  BLoC    │  │ViewModel │              │
│  │ Widgets  │  │  State   │  │          │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ Use Cases│  │ Entities │  │Repository│              │
│  │          │  │          │  │Interface │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                          │
│  ┌────────────────┐  ┌──────────────────┐              │
│  │  Local Storage │  │  Remote Service  │              │
│  │  • SQLite      │  │  • REST/GraphQL  │              │
│  │  • Hive        │  │  • WebSocket     │              │
│  │  • SharedPrefs │  │  • gRPC          │              │
│  └────────────────┘  └──────────────────┘              │
└─────────────────────────────────────────────────────────┘
```

---

## 1. Design WhatsApp (Most Common!)

### Requirements Gathering

**Interviewer:** "Design WhatsApp"

**Your Response:**

```
"Let me clarify the scope:

1. **Core Features:**
   - 1:1 messaging? YES
   - Group chat? YES (limit scope to 100 members)
   - Media sharing? TEXT only for now
   - Voice/Video calls? NO (out of scope)
   - Stories? NO

2. **Scale:**
   - How many users? Let's say 100M users
   - Messages per day? 1B messages
   - Average message size? 1KB
   - Peak QPS? ~12K messages/second

3. **Platform:**
   - iOS and Android
   - Single codebase (Flutter)

4. **Non-functional:**
   - Real-time delivery (<1s latency)
   - Offline support
   - End-to-end encryption
   - 99.9% availability

Is this scope reasonable for our interview?"
```

### High-Level Architecture

```
Mobile App (Flutter)
      ↓
  WebSocket Connection
      ↓
Load Balancer
      ↓
┌─────────────────────────────────────┐
│  Chat Servers (Stateful)            │
│  • Maintain WS connections          │
│  • Route messages                   │
└─────────────────────────────────────┘
      ↓
┌─────────────────────────────────────┐
│  Message Queue (Kafka)              │
│  • Decouple read/write              │
│  • Handle spikes                    │
└─────────────────────────────────────┘
      ↓
┌─────────────────────────────────────┐
│  Database (Cassandra)               │
│  • Store messages                   │
│  • High write throughput            │
└─────────────────────────────────────┘
```

### Mobile Client Architecture

```dart
// 1. Define Message Entity
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status; // sent, delivered, read

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.status,
  });
}

enum MessageStatus {
  sending,     // Local, not sent yet
  sent,        // Acknowledged by server
  delivered,   // Delivered to recipient
  read,        // Read by recipient
  failed,      // Failed to send
}

// 2. API Design
abstract class ChatApi {
  // REST APIs
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessages(String conversationId, {int limit, String? cursor});

  // WebSocket
  Stream<Message> messageStream();
  Future<void> sendMessage(Message message);
  Future<void> markAsRead(String messageId);
}

// 3. Local Storage (Drift/SQLite)
@DriftDatabase(tables: [Messages, Conversations])
class ChatDatabase extends _$ChatDatabase {
  ChatDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insert message
  Future<void> insertMessage(Message message) {
    return into(messages).insert(message);
  }

  // Get messages for conversation
  Stream<List<Message>> watchMessages(String conversationId) {
    return (select(messages)
      ..where((m) => m.conversationId.equals(conversationId))
      ..orderBy([(m) => OrderingTerm(expression: m.timestamp)]))
      .watch();
  }
}

// 4. Repository Pattern
class ChatRepository {
  final ChatApi _api;
  final ChatDatabase _database;
  final NetworkInfo _networkInfo;

  ChatRepository(this._api, this._database, this._networkInfo);

  // Send message (Offline-first)
  Future<void> sendMessage(Message message) async {
    // 1. Save to local DB immediately
    await _database.insertMessage(message.copyWith(
      status: MessageStatus.sending,
    ));

    // 2. Send to server
    try {
      await _api.sendMessage(message);

      // 3. Update status
      await _database.updateMessage(message.copyWith(
        status: MessageStatus.sent,
      ));
    } catch (e) {
      // 4. Mark as failed, queue for retry
      await _database.updateMessage(message.copyWith(
        status: MessageStatus.failed,
      ));

      await _offlineQueue.add(message);
    }
  }

  // Load messages (Cache-first)
  Stream<List<Message>> getMessages(String conversationId) {
    // 1. Return cached data immediately
    final cachedStream = _database.watchMessages(conversationId);

    // 2. Fetch from server in background
    if (await _networkInfo.isConnected) {
      _syncMessages(conversationId);
    }

    return cachedStream;
  }

  Future<void> _syncMessages(String conversationId) async {
    final lastMessage = await _database.getLastMessage(conversationId);
    final newMessages = await _api.getMessages(
      conversationId,
      since: lastMessage?.timestamp,
    );

    for (final message in newMessages) {
      await _database.insertMessage(message);
    }
  }
}

// 5. WebSocket Manager
class WebSocketManager {
  WebSocketChannel? _channel;
  StreamController<Message> _messageController = StreamController.broadcast();

  void connect(String userId, String token) {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://api.whatsapp.com/ws?user=$userId&token=$token'),
    );

    _channel!.stream.listen(
      (data) {
        final message = Message.fromJson(jsonDecode(data));
        _messageController.add(message);

        // Save to local DB
        _database.insertMessage(message);

        // Send acknowledgment
        _sendAck(message.id);
      },
      onError: (error) {
        // Reconnect logic
        _reconnect();
      },
    );
  }

  Future<void> _reconnect() async {
    await Future.delayed(Duration(seconds: 2)); // Exponential backoff
    connect(_userId, _token);
  }

  Stream<Message> get messages => _messageController.stream;
}

// 6. Offline Queue Manager
class OfflineQueueManager {
  final ChatApi _api;
  final ChatDatabase _database;

  Future<void> processPendingMessages() async {
    final pendingMessages = await _database.getPendingMessages();

    for (final message in pendingMessages) {
      try {
        await _api.sendMessage(message);
        await _database.updateMessageStatus(message.id, MessageStatus.sent);
      } catch (e) {
        // Retry later
      }
    }
  }
}

// 7. BLoC for Chat
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await emit.forEach(
      _repository.getMessages(event.conversationId),
      onData: (messages) => ChatLoaded(messages),
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    await _repository.sendMessage(event.message);
  }
}
```

### Database Schema

```sql
-- Messages table
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  receiver_id TEXT NOT NULL,
  content TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  status TEXT NOT NULL,
  is_synced INTEGER DEFAULT 0,
  INDEX(conversation_id, timestamp)
);

-- Conversations table
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL, -- '1:1' or 'group'
  participants TEXT NOT NULL, -- JSON array
  last_message_id TEXT,
  unread_count INTEGER DEFAULT 0,
  last_updated INTEGER NOT NULL
);

-- Offline queue
CREATE TABLE offline_queue (
  message_id TEXT PRIMARY KEY,
  retry_count INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL
);
```

### API Endpoints

```dart
// REST APIs
GET  /conversations
     Response: List<Conversation>

GET  /conversations/{id}/messages?limit=50&cursor={cursor}
     Response: { messages: List<Message>, next_cursor: string }

POST /messages
     Body: { receiver_id, content, client_id }
     Response: { message_id, timestamp }

PUT  /messages/{id}/status
     Body: { status: 'read' }

// WebSocket
CONNECT wss://api.whatsapp.com/ws?user={userId}&token={token}

// Incoming messages
{
  "type": "message",
  "data": {
    "id": "msg_123",
    "sender_id": "user_456",
    "content": "Hello",
    "timestamp": 1234567890
  }
}

// Outgoing messages
{
  "type": "send",
  "data": {
    "client_id": "local_123",
    "receiver_id": "user_456",
    "content": "Hello"
  }
}

// Acknowledgments
{
  "type": "ack",
  "message_id": "msg_123",
  "status": "delivered"
}
```

### Optimizations

#### 1. Pagination

```dart
// Load messages in chunks
class MessagePagination {
  static const int PAGE_SIZE = 50;

  Future<List<Message>> loadPage(String conversationId, String? cursor) async {
    return await _api.getMessages(
      conversationId,
      limit: PAGE_SIZE,
      cursor: cursor,
    );
  }
}
```

#### 2. Message Batching

```dart
// Batch multiple messages
class MessageBatcher {
  final List<Message> _batch = [];
  Timer? _timer;

  void addMessage(Message message) {
    _batch.add(message);

    if (_batch.length >= 10) {
      _flush();
    } else {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: 100), _flush);
    }
  }

  void _flush() {
    if (_batch.isEmpty) return;
    _api.sendBatch(_batch);
    _batch.clear();
  }
}
```

#### 3. Connection Management

```dart
// Exponential backoff
class ConnectionManager {
  int _retryCount = 0;

  Duration get retryDelay {
    return Duration(
      seconds: min(pow(2, _retryCount).toInt(), 30),
    );
  }

  Future<void> connect() async {
    try {
      await _websocket.connect();
      _retryCount = 0; // Reset on success
    } catch (e) {
      _retryCount++;
      await Future.delayed(retryDelay);
      connect(); // Retry
    }
  }
}
```

### Edge Cases

**Q: "How do you handle messages sent while offline?"**

```dart
// Solution: Offline queue
class OfflineMessageHandler {
  Future<void> sendMessage(Message message) async {
    // 1. Add to local DB with 'sending' status
    await _db.insertMessage(message.copyWith(
      status: MessageStatus.sending,
    ));

    // 2. Add to offline queue
    await _offlineQueue.add(message);

    // 3. Try to send
    if (await _network.isConnected) {
      await _processQueue();
    }
  }

  Future<void> _processQueue() async {
    final pending = await _offlineQueue.getAll();

    for (final message in pending) {
      try {
        await _api.sendMessage(message);
        await _db.updateStatus(message.id, MessageStatus.sent);
        await _offlineQueue.remove(message.id);
      } catch (e) {
        // Keep in queue, retry later
      }
    }
  }
}

// Listen for network changes
_connectivity.onConnectivityChanged.listen((result) {
  if (result != ConnectivityResult.none) {
    _processQueue();
  }
});
```

**Q: "How do you handle duplicate messages?"**

```dart
// Solution: Idempotency with client-generated IDs
class Message {
  final String id; // Client generates UUID

  Message() : id = Uuid().v4();
}

// Server deduplicates based on ID
// Database constraint: UNIQUE(id)
```

**Q: "How do you show typing indicators?"**

```dart
// Lightweight, don't persist
class TypingIndicator {
  final _typingController = StreamController<Set<String>>.broadcast();
  Timer? _timer;

  void onTyping(String userId) {
    // Send typing event (throttled)
    _websocket.send({
      'type': 'typing',
      'user_id': userId,
    });
  }

  void onStopTyping(String userId) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 3), () {
      _websocket.send({
        'type': 'stop_typing',
        'user_id': userId,
      });
    });
  }
}
```

---

## 2. Design Instagram Feed

### Requirements

```
Core Features:
- Infinite scroll feed
- Image/video posts
- Like, comment, share
- Profile page

Non-functional:
- Smooth scrolling (60fps)
- Fast image loading
- Offline viewing of recent feed
```

### Key Components

#### 1. Feed Architecture

```dart
class FeedRepository {
  final FeedApi _api;
  final FeedCache _cache;

  Stream<List<Post>> getFeed({String? cursor}) async* {
    // 1. Emit cached data immediately
    yield await _cache.getFeed();

    // 2. Fetch fresh data
    final freshPosts = await _api.getFeed(cursor: cursor);

    // 3. Update cache
    await _cache.saveFeed(freshPosts);

    // 4. Emit fresh data
    yield freshPosts;
  }
}
```

#### 2. Image Loading Strategy

```dart
class ImageLoadingStrategy {
  // Multi-tier caching
  // 1. Memory cache (fast, limited)
  // 2. Disk cache (medium, larger)
  // 3. Network (slow, unlimited)

  Future<ImageInfo> loadImage(String url) async {
    // Check memory
    if (_memoryCache.contains(url)) {
      return _memoryCache.get(url);
    }

    // Check disk
    if (await _diskCache.contains(url)) {
      final image = await _diskCache.get(url);
      _memoryCache.put(url, image);
      return image;
    }

    // Fetch from network
    final image = await _download(url);
    await _diskCache.put(url, image);
    _memoryCache.put(url, image);
    return image;
  }

  // Preload next images
  void preloadNext(List<String> urls) {
    for (final url in urls.take(3)) {
      loadImage(url); // Load in background
    }
  }
}
```

#### 3. Infinite Scroll

```dart
class InfiniteScrollList extends StatefulWidget {
  @override
  _InfiniteScrollListState createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  final _scrollController = ScrollController();
  final _posts = <Post>[];
  String? _cursor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.8) { // 80% threshold
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoading = true);

    final newPosts = await _repository.getFeed(cursor: _cursor);

    setState(() {
      _posts.addAll(newPosts);
      _cursor = newPosts.last.id;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _posts.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _posts.length) {
          return CircularProgressIndicator();
        }
        return PostCard(post: _posts[index]);
      },
    );
  }
}
```

#### 4. Post Interactions (Optimistic Updates)

```dart
class PostInteractions {
  Future<void> likePost(String postId) async {
    // 1. Update UI immediately
    _updateLocalPost(postId, (post) => post.copyWith(
      isLiked: true,
      likesCount: post.likesCount + 1,
    ));

    // 2. Send to server
    try {
      await _api.likePost(postId);
    } catch (e) {
      // 3. Rollback on failure
      _updateLocalPost(postId, (post) => post.copyWith(
        isLiked: false,
        likesCount: post.likesCount - 1,
      ));

      _showError('Failed to like post');
    }
  }
}
```

### Interview Follow-up Questions

**Q: "How do you handle feed ranking?"**

```dart
// Client receives pre-ranked feed from server
// But can implement client-side sorting
class FeedRanker {
  List<Post> rankPosts(List<Post> posts) {
    // Sort by engagement score
    posts.sort((a, b) {
      final scoreA = _calculateScore(a);
      final scoreB = _calculateScore(b);
      return scoreB.compareTo(scoreA);
    });

    return posts;
  }

  double _calculateScore(Post post) {
    final ageHours = DateTime.now().difference(post.createdAt).inHours;
    final recencyScore = 1.0 / (1.0 + ageHours);
    final engagementScore = (post.likesCount * 1.0 +
                             post.commentsCount * 2.0 +
                             post.sharesCount * 3.0) / 100.0;

    return recencyScore * 0.3 + engagementScore * 0.7;
  }
}
```

---

## 3. General Mobile System Design Patterns

### Pattern 1: Offline-First Architecture

```dart
abstract class OfflineFirstRepository<T> {
  // 1. Always return cached data first
  Stream<T> getData() async* {
    yield await _cache.get();

    if (await _network.isConnected) {
      final fresh = await _api.get();
      await _cache.save(fresh);
      yield fresh;
    }
  }

  // 2. Queue writes when offline
  Future<void> saveData(T data) async {
    await _cache.save(data);

    if (await _network.isConnected) {
      await _api.save(data);
    } else {
      await _syncQueue.add(data);
    }
  }

  // 3. Sync when online
  Future<void> sync() async {
    final pending = await _syncQueue.getAll();

    for (final item in pending) {
      await _api.save(item);
      await _syncQueue.remove(item);
    }
  }
}
```

### Pattern 2: Retry with Exponential Backoff

```dart
class RetryPolicy {
  Future<T> execute<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
  }) async {
    int attempt = 0;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;

        if (attempt >= maxAttempts) {
          rethrow;
        }

        final delay = Duration(
          seconds: pow(2, attempt).toInt(),
        );

        await Future.delayed(delay);
      }
    }
  }
}
```

### Pattern 3: Request Deduplication

```dart
class RequestDeduplicator {
  final _pending = <String, Future>{};

  Future<T> execute<T>(
    String key,
    Future<T> Function() operation,
  ) {
    if (_pending.containsKey(key)) {
      return _pending[key] as Future<T>;
    }

    final future = operation();
    _pending[key] = future;

    future.whenComplete(() {
      _pending.remove(key);
    });

    return future;
  }
}
```

---

## 4. Common Interview Questions

### Q1: "How do you design a location-based app like Uber?"

**Key Points:**

- Real-time location tracking
- Geospatial queries
- Battery optimization
- Network efficiency

```dart
class LocationTracker {
  StreamSubscription? _subscription;

  void startTracking() {
    _subscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Only update every 10 meters
      ),
    ).listen((position) {
      _sendToServer(position);
    });
  }

  // Battery optimization
  void _optimizeForBattery() {
    final batteryLevel = await Battery().batteryLevel;

    if (batteryLevel < 20) {
      // Reduce accuracy and update frequency
      _updateLocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
      );
    }
  }
}
```

### Q2: "How do you handle large lists efficiently?"

```dart
// Use ListView.builder for virtualization
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, index) {
    // Only builds visible items
    return ListTile(title: Text('Item $index'));
  },
)

// Use const constructors
const ListTile(...);

// Implement item pooling for complex items
class ItemPool {
  final _pool = <Widget>[];

  Widget getItem() {
    if (_pool.isNotEmpty) {
      return _pool.removeLast();
    }
    return _createNewItem();
  }

  void returnItem(Widget item) {
    _pool.add(item);
  }
}
```

---

## 5. Interview Tips

### Do's ✅

1. **Ask clarifying questions** (5-10 min)
2. **Start with high-level** before diving deep
3. **Draw diagrams** (architecture, data flow)
4. **Discuss trade-offs** ("We could do X, but Y because...")
5. **Consider mobile constraints** (battery, network, storage)
6. **Think about offline** (it's mobile, not always connected!)
7. **Talk about testing** and how you'd verify
8. **Mention performance** (60fps, memory, startup time)

### Don'ts ❌

1. **Don't jump to code** immediately
2. **Don't ignore requirements** gathering
3. **Don't overcomplicate** unnecessarily
4. **Don't forget edge cases**
5. **Don't ignore platform differences** (iOS vs Android)
6. **Don't forget about users** (what's the UX impact?)

### Time Management

```
0-10 min: Requirements & Scope
10-20 min: High-level Architecture
20-40 min: Deep Dive Components
40-50 min: Edge Cases & Optimizations
50-60 min: Testing & Questions
```

---

## 6. Practice Problems

1. Design YouTube (video streaming, offline, recommendations)
2. Design Twitter (feed, real-time, notifications)
3. Design Spotify (music streaming, offline, playlists)
4. Design Airbnb (search, booking, payments)
5. Design TikTok (video feed, recording, effects)

For each, practice:

- Requirements (5 min)
- Architecture (10 min)
- Deep dive (20 min)
- Edge cases (5 min)

---

## Resources

- [Mobile System Design GitHub](https://github.com/weeeBox/mobile-system-design)
- [System Design Primer](https://github.com/donnemartin/system-design-primer)
- [Grokking System Design](https://www.educative.io/courses/grokking-the-system-design-interview)

---

**Remember:** System design is about **communication** and **thinking process**, not perfect solutions. Show your thought process, discuss trade-offs, and be open to feedback!

Good luck! 🚀
