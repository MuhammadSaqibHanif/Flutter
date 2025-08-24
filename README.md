# 📱 Flutter Multi-App Showcase

Welcome to my **Flutter Multi-App Showcase** — a single master application that contains **8 fully functional Flutter apps** as independent packages.  
This project demonstrates clean architecture, modularization, and state management using **BLoC + MVVM**, while also serving as my personal Flutter portfolio.

---

## 🚀 Features

- 🗂 **Modular Architecture** — Each app is built as a separate Flutter package under `/packages`
- 🎯 **BLoC + MVVM Pattern** — Clean, scalable, and testable code
- 📦 **Reusable Components** — Shared themes, utilities, and assets
- 📱 **Single Entry Point** — A master app that lists and navigates to all apps
- 🎨 **Attractive UI** — Emoji-based icons for quick recognition
- 🧩 **9 Showcase Apps** — See the full list below

---

## 📂 Project Structure

```bash
master_app/
├─ pubspec.yaml           # main app pubspec
├─ lib/
│   ├─ main.dart          # app entry point
│   ├─ core/              # shared core (themes, utils)
│   └─ features/          # optional: glue code or aggregated UI
└─ packages/              # directory for feature modules (Flutter packages)
    ├─ roll_dice_app/
    ├─ quiz_app/
    ├─ expense_tracker_app/
    ├─ todo_app/
    ├─ meals_app/
    ├─ shopping_list_app/
    ├─ favorite_places_app/
    ├─ chat_app/
    └─ flutter_bloc_pro_app/
```

---

## 📋 Included Apps

| Icon | App Name              | Description                               |
| ---- | --------------------- | ----------------------------------------- |
| 🎲   | **Roll Dice App**     | Roll virtual dice with a simple tap       |
| 🧠   | **Quiz App**          | Test your knowledge with fun quizzes      |
| 💰   | **Expense Tracker**   | Track and manage your daily expenses      |
| 📝   | **Todo App**          | Manage your tasks and boost productivity  |
| 🍽️   | **Meals App**         | Browse and save delicious recipes         |
| 🛒   | **Shopping List App** | Create and manage your shopping lists     |
| 📍   | **Favorite Places**   | Save and view your favorite locations     |
| 💬   | **Chat App**          | Real-time messaging app with Firebase     |
| 🧩   | **Bloc Mastery App**  | Flutter BLoC Pro App (Production-quality) |

---

## 🎥 Previews

> _(Add GIFs/screenshots here for each app)_

| App                 | Preview                                                 |
| ------------------- | ------------------------------------------------------- |
| Roll Dice App       | ![Roll Dice](assets/previews/roll_dice.gif)             |
| Quiz App            | ![Quiz](assets/previews/quiz.gif)                       |
| Expense Tracker     | ![Expense Tracker](assets/previews/expense_tracker.gif) |
| Todo App            | ![Todo](assets/previews/todo.gif)                       |
| Meals App           | ![Meals](assets/previews/meals.gif)                     |
| Shopping List App   | ![Shopping List](assets/previews/shopping_list.gif)     |
| Favorite Places App | ![Favorite Places](assets/previews/favorite_places.gif) |
| Chat App            | ![Chat](assets/previews/chat.gif)                       |
| Bloc Mastery App    | ![Bloc Mastery](assets/previews/bloc_astery.gif)        |

---

## 🛠️ Installation & Run

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/flutter-multi-app-showcase.git

# Navigate into the master app
cd flutter-multi-app-showcase

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📌 Why This Project?

I created this as:

1. **A Learning Project** — To improve my Flutter, architecture, and clean code skills
2. **A Showcase Portfolio** — Something I can share with recruiters and on LinkedIn
3. **A Modular Experiment** — Testing Flutter package-based app structuring

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

💡 _If you liked this project, don't forget to ⭐ star the repo and connect with me on [LinkedIn](https://linkedin.com/in/YOUR_PROFILE)._
