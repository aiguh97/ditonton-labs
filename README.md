# Ditonton App

A Flutter application for browsing **Movies and TV Series** built with
**Clean Architecture** and **BLoC State Management**.\
The project integrates **Firebase Analytics**, **Firebase Crashlytics**,
and **Continuous Integration (CI)** to ensure app quality and
monitoring.

------------------------------------------------------------------------

# Features

## 🎬 Movie & TV Series Catalog

-   Browse **Now Playing Movies**
-   View **Popular Movies**
-   View **Top Rated Movies**
-   Browse **TV Series**
-   View **Movie / TV Series Details**
-   Search movies and TV series
-   Add or remove items from **Watchlist**

------------------------------------------------------------------------

## 📊 Firebase Analytics

The application integrates **Firebase Analytics** to track user behavior
and engagement.

Tracked events include:

-   Screen views
-   Movie detail visits
-   Watchlist additions
-   Search activity

### Screenshot

![Firebase Analytics](screenshots/firebase_analytics.png)

------------------------------------------------------------------------

## 🛠 Firebase Crashlytics

The project uses **Firebase Crashlytics** for real-time crash reporting
and monitoring.

Features:

-   Automatic crash reporting
-   Detailed crash stack trace
-   Crash statistics
-   Device and OS information

This helps developers quickly detect and fix application issues.

### Screenshot

![Firebase Crashlytics](screenshots/firebase_crashlytics.png)

------------------------------------------------------------------------

## 🔄 Continuous Integration (CI)

The project uses **Continuous Integration** to automatically run checks
when code is pushed to the repository.

CI pipeline includes:

-   Running **Unit Tests**
-   Checking **Test Coverage**
-   Running **Static Analysis**
-   Ensuring build stability

### Screenshot

![CI Pipeline](screenshots/ci.png)

------------------------------------------------------------------------

# Architecture

This project follows **Clean Architecture** principles.

    lib
     ├── common
     ├── data
     │   ├── datasources
     │   ├── models
     │   └── repositories
     ├── domain
     │   ├── entities
     │   ├── repositories
     │   └── usecases
     └── presentation
         ├── bloc
         ├── pages
         └── widgets

Layers:

-   **Presentation** → UI & BLoC
-   **Domain** → Business Logic
-   **Data** → API & Database

------------------------------------------------------------------------

# Testing

This project includes:

-   Unit Tests
-   Widget Tests
-   Mocking using Mockito
-   Test Coverage

Run tests:

``` bash
flutter test
```

Generate coverage:

``` bash
flutter test --coverage
```

------------------------------------------------------------------------

# Screenshots

All feature screenshots are located inside the **screenshots** folder.

    screenshots/
     ├── ci.png
     ├── firebase_analytics.png
     ├── firebase_crashlytics.png

------------------------------------------------------------------------

# Tech Stack

-   Flutter
-   Dart
-   BLoC
-   Firebase Analytics
-   Firebase Crashlytics
-   CI/CD
-   Clean Architecture

------------------------------------------------------------------------

# Author

Developed as part of a **Flutter Expert level submission project**.
