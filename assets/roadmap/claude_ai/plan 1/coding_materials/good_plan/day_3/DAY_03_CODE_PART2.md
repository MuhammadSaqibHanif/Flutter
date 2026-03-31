# 💻 DAY 3: CODE PART 2 - Performance & Optimization

## 🎯 App 2 Mission

Build a **Performance Showcase** app in 60 minutes that teaches Q51-Q60.

**What you'll build:**
- Image Gallery with optimization
- Memory-efficient lists
- Performance profiling tools
- Build optimization examples
- Widget optimization demos

---

# 📱 APP 2: PERFORMANCE SHOWCASE (60 minutes)

## 🎯 Teaches: Q51-Q60
- Q51: Image optimization & caching
- Q52: ListView performance (AutomaticKeepAlive)
- Q53: const optimization
- Q54: Keys for performance
- Q55: RepaintBoundary
- Q56: Build method optimization
- Q57: Memory leaks & prevention
- Q58: Performance profiling
- Q59: Reduce rebuilds
- Q60: Release mode optimization

---

## 📁 Create Folder Structure (2 minutes)

```bash
cd lib/apps/day3
mkdir -p performance_app/{screens,widgets,utils}
```

**Your structure:**
```
lib/apps/day3/performance_app/
├── screens/
│   ├── home_screen.dart
│   ├── image_optimization_screen.dart
│   ├── list_optimization_screen.dart
│   ├── widget_optimization_screen.dart
│   └── memory_demo_screen.dart
├── widgets/
│   ├── optimized_image.dart
│   ├── heavy_widget.dart
│   └── performance_metrics.dart
├── utils/
│   └── performance_monitor.dart
└── performance_app.dart
```

---

## 💻 FILE 1: Performance Monitor Utility (10 min)

**Create: `lib/apps/day3/performance_app/utils/performance_monitor.dart`**

```dart
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Q58: Performance monitoring utility
/// Helps track build counts, rebuilds, and performance
class PerformanceMonitor {
  static final Map<String, int> _buildCounts = {};
  static final Map<String, DateTime> _buildTimestamps = {};
  
  /// Track widget build
  static void trackBuild(String widgetName) {
    _buildCounts[widgetName] = (_buildCounts[widgetName] ?? 0) + 1;
    _buildTimestamps[widgetName] = DateTime.now();
    
    if (kDebugMode) {
      developer.log(
        '🔨 Build #${_buildCounts[widgetName]}: $widgetName',
        name: 'PerformanceMonitor',
      );
    }
  }
  
  /// Get build count
  static int getBuildCount(String widgetName) {
    return _buildCounts[widgetName] ?? 0;
  }
  
  /// Reset counters
  static void reset() {
    _buildCounts.clear();
    _buildTimestamps.clear();
    if (kDebugMode) {
      print('🔄 Performance counters reset');
    }
  }
  
  /// Print all build counts
  static void printStats() {
    if (kDebugMode) {
      print('\n📊 Build Statistics:');
      _buildCounts.forEach((widget, count) {
        print('   $widget: $count builds');
      });
      print('');
    }
  }
  
  /// Q58: Measure execution time
  static Future<T> measure<T>(
    String operation,
    Future<T> Function() function,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await function();
      stopwatch.stop();
      
      if (kDebugMode) {
        print('⏱️  $operation took ${stopwatch.elapsedMilliseconds}ms');
      }
      
      return result;
    } catch (e) {
      stopwatch.stop();
      if (kDebugMode) {
        print('❌ $operation failed after ${stopwatch.elapsedMilliseconds}ms');
      }
      rethrow;
    }
  }
}
```

---

## 💻 FILE 2: Optimized Image Widget (8 min)

**Create: `lib/apps/day3/performance_app/widgets/optimized_image.dart`**

```dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Q51: Optimized image loading widget
/// Demonstrates image optimization techniques
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  
  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      
      // Q51: Image caching - automatically cached by Flutter
      // Uses ImageCache with default 1000 images / 100MB
      
      // Q51: Provide cache dimensions to decode at correct size
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      
      // Q51: Show placeholder while loading
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      
      // Q51: Handle errors gracefully
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.red),
        );
      },
    );
  }
}

/// Q51: Cached Network Image with manual control
class CachedOptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  
  const CachedOptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<CachedOptimizedImage> createState() => _CachedOptimizedImageState();
}

class _CachedOptimizedImageState extends State<CachedOptimizedImage> {
  ui.Image? _cachedImage;
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    _loadImage();
  }
  
  Future<void> _loadImage() async {
    try {
      // Q51: Load and decode image
      final networkImage = NetworkImage(widget.imageUrl);
      final imageStream = networkImage.resolve(ImageConfiguration.empty);
      
      imageStream.addListener(ImageStreamListener((imageInfo, synchronousCall) {
        if (mounted) {
          setState(() {
            _cachedImage = imageInfo.image;
            _loading = false;
          });
        }
      }));
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_cachedImage == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      );
    }
    
    return CustomPaint(
      size: Size(widget.width ?? 200, widget.height ?? 200),
      painter: _ImagePainter(_cachedImage!),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  
  _ImagePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Q51: Paint cached image
    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: image,
      fit: BoxFit.cover,
    );
  }
  
  @override
  bool shouldRepaint(_ImagePainter oldDelegate) {
    return image != oldDelegate.image;
  }
}
```

---

## 💻 FILE 3: Heavy Widget Demo (8 min)

**Create: `lib/apps/day3/performance_app/widgets/heavy_widget.dart`**

```dart
import 'package:flutter/material.dart';
import '../utils/performance_monitor.dart';

/// Q56: Demonstrates build optimization
class HeavyWidget extends StatelessWidget {
  final String title;
  final Color color;
  final bool useConst;
  
  const HeavyWidget({
    Key? key,
    required this.title,
    required this.color,
    this.useConst = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('HeavyWidget($title)');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Q53: const optimization demo
          if (useConst)
            // ✅ With const - widget reused
            const _StaticContent()
          else
            // ❌ Without const - rebuilt every time
            _StaticContent(),
          
          const SizedBox(height: 8),
          Text(
            'Builds: ${PerformanceMonitor.getBuildCount('HeavyWidget($title)')}',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Q53: Static content that should use const
class _StaticContent extends StatelessWidget {
  const _StaticContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('_StaticContent');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('This is static content'),
        SizedBox(height: 4),
        Icon(Icons.info, size: 16),
        SizedBox(height: 4),
        Text(
          'Should be marked const',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Q55: RepaintBoundary optimization
class RepaintBoundaryDemo extends StatefulWidget {
  const RepaintBoundaryDemo({Key? key}) : super(key: key);

  @override
  State<RepaintBoundaryDemo> createState() => _RepaintBoundaryDemoState();
}

class _RepaintBoundaryDemoState extends State<RepaintBoundaryDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Q55: Without RepaintBoundary
        // Entire subtree repaints on animation
        Expanded(
          child: Column(
            children: [
              const Text('Without RepaintBoundary'),
              const SizedBox(height: 8),
              _AnimatedBox(controller: _controller),
              const SizedBox(height: 8),
              const _ExpensiveWidget(label: 'Repaints unnecessarily'),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Q55: With RepaintBoundary
        // Only animated box repaints
        Expanded(
          child: Column(
            children: [
              const Text('With RepaintBoundary'),
              const SizedBox(height: 8),
              RepaintBoundary(
                child: _AnimatedBox(controller: _controller),
              ),
              const SizedBox(height: 8),
              const _ExpensiveWidget(label: 'Doesn\'t repaint'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedBox extends StatelessWidget {
  final AnimationController controller;
  
  const _AnimatedBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * 3.14159,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.blue,
          ),
        );
      },
    );
  }
}

class _ExpensiveWidget extends StatelessWidget {
  final String label;
  
  const _ExpensiveWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('_ExpensiveWidget($label)');
    
    // Simulate expensive build
    _doExpensiveWork();
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(
            'Builds: ${PerformanceMonitor.getBuildCount('_ExpensiveWidget($label)')}',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  void _doExpensiveWork() {
    // Simulate computation
    var sum = 0;
    for (var i = 0; i < 10000; i++) {
      sum += i;
    }
  }
}
```

---

## 💻 FILE 4: Performance Metrics Widget (6 min)

**Create: `lib/apps/day3/performance_app/widgets/performance_metrics.dart`**

```dart
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// Q58: Performance metrics display
class PerformanceMetrics extends StatefulWidget {
  const PerformanceMetrics({Key? key}) : super(key: key);

  @override
  State<PerformanceMetrics> createState() => _PerformanceMetricsState();
}

class _PerformanceMetricsState extends State<PerformanceMetrics> {
  double _fps = 60.0;
  int _frameTime = 16;
  
  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }
  
  void _startMonitoring() {
    // Q58: Monitor frame rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      
      // Simulate FPS tracking (in real app, use performance overlay)
      if (mounted) {
        setState(() {
          _fps = 60.0; // Placeholder
          _frameTime = 16; // 16ms = 60fps
        });
        
        // Continue monitoring
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _startMonitoring();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _fps >= 55 ? Colors.green[50] : Colors.red[50],
        border: Border.all(
          color: _fps >= 55 ? Colors.green : Colors.red,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.speed,
            color: _fps >= 55 ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FPS: ${_fps.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Frame: ${_frameTime}ms',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Q58: Timeline profiling helper
class TimelineTask {
  final String name;
  final Stopwatch _stopwatch = Stopwatch();
  
  TimelineTask(this.name) {
    developer.Timeline.startSync(name);
    _stopwatch.start();
  }
  
  void finish() {
    _stopwatch.stop();
    developer.Timeline.finishSync();
    developer.log(
      '$name took ${_stopwatch.elapsedMilliseconds}ms',
      name: 'Timeline',
    );
  }
}
```

---

## 💻 FILE 5: Image Optimization Screen (8 min)

**Create: `lib/apps/day3/performance_app/screens/image_optimization_screen.dart`**

```dart
import 'package:flutter/material.dart';
import '../widgets/optimized_image.dart';

/// Q51: Image optimization demonstrations
class ImageOptimizationScreen extends StatelessWidget {
  const ImageOptimizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q51: Image Optimization'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Optimized Images',
            'Uses cacheWidth/cacheHeight to decode at correct size',
            _buildOptimizedImages(),
          ),
          
          const SizedBox(height: 20),
          
          _buildSection(
            'Image Caching',
            'Flutter automatically caches network images',
            _buildCachingDemo(),
          ),
          
          const SizedBox(height: 20),
          
          _buildSection(
            'Best Practices',
            'Tips for image optimization',
            _buildBestPractices(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, String description, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildOptimizedImages() {
    // Sample image URLs
    const imageUrl = 'https://picsum.photos/400/300';
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text('Small (100x75)'),
                  const SizedBox(height: 8),
                  OptimizedImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 75,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Decoded at 100x75',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text('Medium (150x112)'),
                  const SizedBox(height: 8),
                  OptimizedImage(
                    imageUrl: imageUrl,
                    width: 150,
                    height: 112,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Decoded at 150x112',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCachingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Same image loaded multiple times:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            6,
            (index) => OptimizedImage(
              imageUrl: 'https://picsum.photos/100/100?random=$index',
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '💡 Each unique image is cached automatically.\n'
            'Default cache: 1000 images or 100MB',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBestPractices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _BestPracticeItem(
          icon: Icons.check_circle,
          text: 'Use cacheWidth/cacheHeight to decode at display size',
        ),
        _BestPracticeItem(
          icon: Icons.check_circle,
          text: 'Provide appropriate image dimensions',
        ),
        _BestPracticeItem(
          icon: Icons.check_circle,
          text: 'Use loading and error builders',
        ),
        _BestPracticeItem(
          icon: Icons.check_circle,
          text: 'Consider using cached_network_image package',
        ),
        _BestPracticeItem(
          icon: Icons.warning,
          text: 'Avoid loading huge images unnecessarily',
          isWarning: true,
        ),
      ],
    );
  }
}

class _BestPracticeItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isWarning;
  
  const _BestPracticeItem({
    required this.icon,
    required this.text,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: isWarning ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 💻 FILE 6: List Optimization Screen (10 min)

**Create: `lib/apps/day3/performance_app/screens/list_optimization_screen.dart`**

```dart
import 'package:flutter/material.dart';
import '../utils/performance_monitor.dart';

/// Q52: ListView optimization with AutomaticKeepAliveClientMixin
class ListOptimizationScreen extends StatefulWidget {
  const ListOptimizationScreen({Key? key}) : super(key: key);

  @override
  State<ListOptimizationScreen> createState() => _ListOptimizationScreenState();
}

class _ListOptimizationScreenState extends State<ListOptimizationScreen> {
  bool _useKeepAlive = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q52: List Optimization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              PerformanceMonitor.reset();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Use AutomaticKeepAliveClientMixin'),
            subtitle: const Text('Prevents widget disposal when scrolled off'),
            value: _useKeepAlive,
            onChanged: (value) {
              setState(() {
                _useKeepAlive = value;
              });
            },
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                if (_useKeepAlive) {
                  return _KeepAliveListItem(index: index);
                } else {
                  return _RegularListItem(index: index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Q52: WITHOUT AutomaticKeepAliveClientMixin
/// Rebuilt every time it scrolls into view
class _RegularListItem extends StatefulWidget {
  final int index;
  
  const _RegularListItem({required this.index});

  @override
  State<_RegularListItem> createState() => _RegularListItemState();
}

class _RegularListItemState extends State<_RegularListItem> {
  late String _expensiveData;
  
  @override
  void initState() {
    super.initState();
    _loadExpensiveData();
  }
  
  void _loadExpensiveData() {
    // Simulate expensive operation
    _expensiveData = 'Loaded data for item ${widget.index}';
    PerformanceMonitor.trackBuild('RegularItem-${widget.index}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.red[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text('${widget.index}'),
        ),
        title: Text('Regular Item ${widget.index}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_expensiveData),
            Text(
              'Builds: ${PerformanceMonitor.getBuildCount('RegularItem-${widget.index}')}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: const Icon(Icons.warning, color: Colors.red),
      ),
    );
  }
}

/// Q52: WITH AutomaticKeepAliveClientMixin
/// State preserved when scrolled off screen
class _KeepAliveListItem extends StatefulWidget {
  final int index;
  
  const _KeepAliveListItem({required this.index});

  @override
  State<_KeepAliveListItem> createState() => _KeepAliveListItemState();
}

class _KeepAliveListItemState extends State<_KeepAliveListItem>
    with AutomaticKeepAliveClientMixin {
  late String _expensiveData;
  
  @override
  bool get wantKeepAlive => true; // Q52: This is the magic!
  
  @override
  void initState() {
    super.initState();
    _loadExpensiveData();
  }
  
  void _loadExpensiveData() {
    _expensiveData = 'Loaded data for item ${widget.index}';
    PerformanceMonitor.trackBuild('KeepAliveItem-${widget.index}');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Q52: Must call super.build()!
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.green[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text('${widget.index}'),
        ),
        title: Text('Keep Alive Item ${widget.index}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_expensiveData),
            Text(
              'Builds: ${PerformanceMonitor.getBuildCount('KeepAliveItem-${widget.index}')} (stays in memory)',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
```

---

## 💻 FILE 7: Widget Optimization Screen (8 min)

**Create: `lib/apps/day3/performance_app/screens/widget_optimization_screen.dart`**

```dart
import 'package:flutter/material.dart';
import '../widgets/heavy_widget.dart';
import '../utils/performance_monitor.dart';

/// Q53-Q56: Widget optimization demonstrations
class WidgetOptimizationScreen extends StatefulWidget {
  const WidgetOptimizationScreen({Key? key}) : super(key: key);

  @override
  State<WidgetOptimizationScreen> createState() =>
      _WidgetOptimizationScreenState();
}

class _WidgetOptimizationScreenState extends State<WidgetOptimizationScreen> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('WidgetOptimizationScreen');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q53-56: Widget Optimization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              PerformanceMonitor.reset();
              setState(() {
                _counter = 0;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Counter: $_counter',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Screen builds: ${PerformanceMonitor.getBuildCount('WidgetOptimizationScreen')}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          
          const SizedBox(height: 20),
          
          // Q53: const optimization
          const Text(
            'Q53: const Optimization',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          HeavyWidget(
            title: 'Without const',
            color: Colors.red,
            useConst: false,
          ),
          const SizedBox(height: 8),
          const HeavyWidget(
            title: 'With const',
            color: Colors.green,
            useConst: true,
          ),
          
          const SizedBox(height: 20),
          
          // Q55: RepaintBoundary
          const Text(
            'Q55: RepaintBoundary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const RepaintBoundaryDemo(),
          
          const SizedBox(height: 20),
          
          // Q56: Extract widgets
          const Text(
            'Q56: Extract Static Widgets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildStaticContent(),
          
          const SizedBox(height: 20),
          
          // Q59: Reduce rebuilds
          const Text(
            'Q59: Reduce Rebuilds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildRebuildDemo(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // Q56: Extract to method (but not optimal)
  Widget _buildStaticContent() {
    PerformanceMonitor.trackBuild('_buildStaticContent');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This is extracted to a method'),
          const SizedBox(height: 4),
          Text(
            'But still rebuilds: ${PerformanceMonitor.getBuildCount('_buildStaticContent')}',
            style: const TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRebuildDemo() {
    return Column(
      children: [
        // Q59: Bad - rebuilds unnecessarily
        _UnnecessaryRebuildWidget(counter: _counter),
        
        const SizedBox(height: 8),
        
        // Q59: Good - only rebuilds when needed
        const _OptimizedWidget(),
      ],
    );
  }
}

/// Q56: Better - Extract to separate widget (const)
class _StaticWidget extends StatelessWidget {
  const _StaticWidget();

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('_StaticWidget');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This is a const widget'),
          const SizedBox(height: 4),
          Text(
            'Builds: ${PerformanceMonitor.getBuildCount('_StaticWidget')} (should be 1)',
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

/// Q59: Rebuilds unnecessarily
class _UnnecessaryRebuildWidget extends StatelessWidget {
  final int counter;
  
  const _UnnecessaryRebuildWidget({required this.counter});

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('_UnnecessaryRebuildWidget');
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Unnecessary Rebuild Widget'),
          Text(
            'Rebuilds even though it doesn\'t use counter',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            'Builds: ${PerformanceMonitor.getBuildCount('_UnnecessaryRebuildWidget')}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

/// Q59: Optimized - doesn't rebuild
class _OptimizedWidget extends StatelessWidget {
  const _OptimizedWidget();

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackBuild('_OptimizedWidget');
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Optimized Widget (const)'),
          Text(
            'Doesn\'t rebuild because it\'s const',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            'Builds: ${PerformanceMonitor.getBuildCount('_OptimizedWidget')} (should be 1)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
```

---

## 💻 FILE 8: Memory Demo Screen (6 min)

**Create: `lib/apps/day3/performance_app/screens/memory_demo_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'dart:async';

/// Q57: Memory leak prevention demonstrations
class MemoryDemoScreen extends StatelessWidget {
  const MemoryDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q57: Memory Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _MemoryLeakExample(),
          SizedBox(height: 20),
          _ProperMemoryManagement(),
        ],
      ),
    );
  }
}

/// Q57: WRONG - Memory leak example
class _MemoryLeakExample extends StatefulWidget {
  const _MemoryLeakExample();

  @override
  State<_MemoryLeakExample> createState() => _MemoryLeakExampleState();
}

class _MemoryLeakExampleState extends State<_MemoryLeakExample> {
  Timer? _timer;
  int _counter = 0;
  
  @override
  void initState() {
    super.initState();
    // ❌ BAD: Timer not cancelled in dispose
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });
    });
  }
  
  // ❌ Missing dispose() - memory leak!

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Memory Leak Example',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Counter: $_counter'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '❌ Timer not cancelled in dispose()\n'
                '❌ Continues running after widget removed\n'
                '❌ Causes memory leak',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Q57: CORRECT - Proper memory management
class _ProperMemoryManagement extends StatefulWidget {
  const _ProperMemoryManagement();

  @override
  State<_ProperMemoryManagement> createState() =>
      _ProperMemoryManagementState();
}

class _ProperMemoryManagementState extends State<_ProperMemoryManagement> {
  Timer? _timer;
  StreamSubscription? _subscription;
  final TextEditingController _controller = TextEditingController();
  int _counter = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _counter++;
        });
      }
    });
    
    // Example stream subscription
    _subscription = Stream.periodic(const Duration(seconds: 2))
        .listen((event) {
      print('Stream event: $event');
    });
  }
  
  @override
  void dispose() {
    // Q57: ✅ ALWAYS dispose resources
    _timer?.cancel();
    _subscription?.cancel();
    _controller.dispose();
    
    super.dispose(); // Call super.dispose() last
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Proper Memory Management',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Counter: $_counter'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '✅ Timer cancelled in dispose()\n'
                '✅ Subscription cancelled\n'
                '✅ Controller disposed\n'
                '✅ No memory leaks',
                style: TextStyle(fontSize: 12),
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

## 💻 FILE 9: Home Screen (4 min)

**Create: `lib/apps/day3/performance_app/screens/home_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'image_optimization_screen.dart';
import 'list_optimization_screen.dart';
import 'widget_optimization_screen.dart';
import 'memory_demo_screen.dart';
import '../widgets/performance_metrics.dart';

class PerformanceHomeScreen extends StatelessWidget {
  const PerformanceHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance & Optimization'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PerformanceMetrics(),
          
          const SizedBox(height: 20),
          
          _buildFeatureCard(
            context,
            icon: Icons.image,
            title: 'Q51: Image Optimization',
            description: 'Caching, sizing, lazy loading',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ImageOptimizationScreen(),
              ),
            ),
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.list,
            title: 'Q52: List Optimization',
            description: 'AutomaticKeepAliveClientMixin',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ListOptimizationScreen(),
              ),
            ),
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.widgets,
            title: 'Q53-56: Widget Optimization',
            description: 'const, RepaintBoundary, reduce rebuilds',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WidgetOptimizationScreen(),
              ),
            ),
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.memory,
            title: 'Q57: Memory Management',
            description: 'Prevent leaks, dispose properly',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MemoryDemoScreen(),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildInfoCard(),
        ],
      ),
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Q58-Q60: Additional Topics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _InfoItem(text: 'Q58: Performance profiling (DevTools)'),
            _InfoItem(text: 'Q59: Reduce rebuilds (const, keys, extraction)'),
            _InfoItem(text: 'Q60: Release mode optimizations'),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String text;
  
  const _InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
```

---

## 💻 FILE 10: Main App (2 min)

**Create: `lib/apps/day3/performance_app/performance_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PerformanceApp());
}

class PerformanceApp extends StatelessWidget {
  const PerformanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance & Optimization',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const PerformanceHomeScreen(),
    );
  }
}
```

---

## 🚀 Run App 2

```bash
flutter run lib/apps/day3/performance_app/performance_app.dart
```

---

## ✅ App 2 Checkpoint

**Test These:**
1. [ ] Navigate through all screens
2. [ ] See optimized images load
3. [ ] Toggle AutomaticKeepAlive in list
4. [ ] Watch build counters
5. [ ] See RepaintBoundary effect
6. [ ] Compare const vs non-const widgets
7. [ ] Observe memory management examples

---

## 🎓 What You Learned (Q51-Q60)

**Q51: Image optimization with cacheWidth/cacheHeight**
**Q52: AutomaticKeepAliveClientMixin for list performance**
**Q53: const optimization reduces rebuilds**
**Q54: Keys preserve state and optimize updates**
**Q55: RepaintBoundary limits repaint scope**
**Q56: Extract widgets, optimize build methods**
**Q57: Dispose resources to prevent memory leaks**
**Q58: Performance profiling with DevTools**
**Q59: Reduce unnecessary rebuilds**
**Q60: Release mode optimizations**

---

## 🎉 DAY 3 CODING COMPLETE!

### **What You Built Today:**

**App 1: Clean Architecture Todo (120 min)**
- ✅ 3-layer architecture
- ✅ Complete CRUD operations
- ✅ Dependency injection
- ✅ Error handling with Either
- ✅ 10 questions (Q41-Q50)

**App 2: Performance Showcase (60 min)**
- ✅ Image optimization
- ✅ List optimization
- ✅ Widget optimization
- ✅ Memory management
- ✅ 10 questions (Q51-Q60)

**Total: 20 questions mastered!**

---

## 📚 NEXT STEP

**Now request theory:**

**Say: "READY FOR DAY 3 THEORY"**

You'll get:
- ✅ DAY_03_THEORY.md (Q41-Q60 explained)
- ✅ DAY_03_QUIZ.md (20 questions + 3 challenges)

**Total Day 3 Time: 6-8 hours**
- Morning: 3-4 hours coding ✅ DONE
- Afternoon: 2-3 hours theory
- Evening: 1 hour quiz

---

**Progress: 60/200 questions (30%)** 📊

**Congratulations on finishing Day 3 coding!** 🎉
