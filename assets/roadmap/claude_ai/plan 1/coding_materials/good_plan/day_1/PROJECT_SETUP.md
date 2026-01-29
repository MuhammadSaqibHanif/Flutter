# 🔧 PROJECT SETUP - 15 Minutes

## ✅ Prerequisites Check

Before starting, verify you have:
- [ ] Flutter SDK installed
- [ ] Android Studio OR VS Code
- [ ] Android Emulator OR iOS Simulator OR Physical Device
- [ ] Git installed

---

## 🚀 Quick Setup (15 minutes)

### **Step 1: Verify Flutter Installation (2 min)**

Open terminal and run:
```bash
flutter doctor
```

**Expected Output:**
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain
✓ Chrome
✓ VS Code OR Android Studio
```

**If any issues:** Run `flutter doctor --android-licenses` and accept all.

---

### **Step 2: Create Project (3 min)**

```bash
# Navigate to your projects folder
cd ~/Documents/Projects

# Create new Flutter project
flutter create devsync_mini

# Navigate into project
cd devsync_mini

# Open in VS Code (or use 'studio .' for Android Studio)
code .
```

**What this creates:**
```
devsync_mini/
├── lib/
│   └── main.dart          # We'll work here
├── test/
├── pubspec.yaml           # Dependencies
├── android/
├── ios/
└── README.md
```

---

### **Step 3: Clean Starter Code (2 min)**

Open `lib/main.dart` and **DELETE EVERYTHING**.

Replace with this minimal starter:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevSync Mini',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Day 1: Fundamentals'),
        ),
        body: Center(
          child: Text(
            'Ready to Learn!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
```

---

### **Step 4: Run App (5 min)**

**Option A: Using Command Line**
```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run
```

**Option B: Using VS Code**
1. Press `F5` or click "Run" → "Start Debugging"
2. Select device from bottom-right corner

**Option C: Using Android Studio**
1. Click green ▶️ play button
2. Select device from dropdown

**Expected Result:**
- App opens on device/emulator
- Shows "Ready to Learn!" text
- Blue app bar at top

---

### **Step 5: Enable Hot Reload (1 min)**

**Test Hot Reload:**
1. Keep app running
2. Change "Ready to Learn!" to "Hot Reload Works!"
3. Save file (Ctrl+S / Cmd+S)
4. See instant update WITHOUT restarting app

**That's Hot Reload! ⚡** (Teaches Q2)

---

### **Step 6: Project Organization (2 min)**

Create folder structure for today:

```bash
# In your project root
cd lib

# Create folders
mkdir -p apps/day1
```

**Your structure now:**
```
lib/
├── main.dart              # Keep this
└── apps/
    └── day1/
        ├── app1_hello.dart      # We'll create these
        ├── app2_counter.dart
        ├── app3_form.dart
        ├── app4_navigation.dart
        └── app5_async.dart
```

---

## ✅ Setup Complete!

You should now have:
- [x] Flutter project created
- [x] App running on device/emulator
- [x] Hot reload working
- [x] Folder structure ready

**Time taken: ~15 minutes**

---

## 🐛 Troubleshooting

### **Problem: "Flutter command not found"**
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or reinstall Flutter:
# https://docs.flutter.dev/get-started/install
```

### **Problem: "No devices available"**
```bash
# For Android Emulator:
flutter emulators
flutter emulators --launch <emulator_id>

# For iOS Simulator (Mac only):
open -a Simulator

# For Chrome (web):
flutter run -d chrome
```

### **Problem: "Gradle build failed"**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### **Problem: "CocoaPods not installed" (Mac/iOS)**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

---

## 🎯 Quick Device Setup

### **Android Emulator (Fastest)**
1. Open Android Studio
2. Tools → Device Manager
3. Create Virtual Device
4. Select Pixel 5 or similar
5. Download system image (API 33+)
6. Launch emulator

### **Physical Device**
**Android:**
1. Enable Developer Options on phone
2. Enable USB Debugging
3. Connect via USB
4. Run `flutter devices`

**iOS (Mac only):**
1. Connect iPhone via USB
2. Trust computer on iPhone
3. Run `flutter devices`

---

## 📱 Recommended Setup

**Best for Learning:**
- **Device:** Android Emulator (faster than iOS Simulator)
- **IDE:** VS Code (lighter than Android Studio)
- **Extensions:** Flutter, Dart

**VS Code Extensions to Install:**
1. Flutter (by Dart Code)
2. Dart (by Dart Code)
3. Awesome Flutter Snippets
4. Bracket Pair Colorizer

---

## 🎉 You're Ready!

Next step: Open `DAY_01_CODE.md` and start building your first 5 apps!

**Remember:**
- Type the code (don't copy-paste) for better learning
- Run each app to see it work
- Break things and fix them
- Hot reload is your friend ⚡

---

## 📞 Need Help?

**Common Resources:**
- Flutter Docs: https://docs.flutter.dev
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: Tag [flutter]

**Quick Commands:**
```bash
flutter pub get        # Install dependencies
flutter clean          # Clean build
flutter doctor         # Check setup
flutter upgrade        # Update Flutter
```

---

**Setup Complete! Move to DAY_01_CODE.md** 🚀
