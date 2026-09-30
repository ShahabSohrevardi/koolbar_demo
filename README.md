<div align="center">

# 🚕 Koolbar

### Offline-First Ride-Hailing & Navigation App built with Flutter

A **modular**, **Clean Architecture** mobile application engineered around **SOLID principles**, **dependency injection** and an **offline-first** data strategy.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%5E3.13-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-brightgreen)](#-architecture)
[![SOLID](https://img.shields.io/badge/Design-SOLID-blueviolet)](#-solid-principles-in-practice)
[![Offline First](https://img.shields.io/badge/Data-Offline--First-orange)](#-offline-first-strategy)
[![Modular](https://img.shields.io/badge/Structure-Modular-informational)](#-modular-project-structure)
[![DI](https://img.shields.io/badge/DI-get__it%20%2B%20injectable-lightgrey)](#-dependency-injection)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[Highlights](#-engineering-highlights) •
[Architecture](#-architecture) •
[SOLID](#-solid-principles-in-practice) •
[Dependency Injection](#-dependency-injection) •
[Offline-First](#-offline-first-strategy) •
[Structure](#-modular-project-structure) •
[Getting Started](#-getting-started)

</div>

---

## 📖 Overview

**Koolbar** is a taxi-booking and navigation application that focuses on **software architecture quality** as much as on features. Every decision in the codebase serves three goals:

- **Maintainability:** strict layer boundaries and single-responsibility components.
- **Testability:** business logic depends on abstractions, never on frameworks or concrete implementations.
- **Resilience:** the app stays useful with poor or no connectivity because local storage is part of the core data flow.

> This repository is intended as a reference implementation of production-style Flutter architecture.

## 📸 Screenshots

<div align="center">

<img src="docs/screen-shots/Screenshot-1.png" alt="Koolbar home screen" width="250" />

</div>

<!--
More screenshots: add files to docs/screen-shots/ and list them side by side:

<div align="center">
  <img src="docs/screen-shots/Screenshot-1.png" width="250" />
  <img src="docs/screen-shots/Screenshot-2.png" width="250" />
  <img src="docs/screen-shots/Screenshot-3.png" width="250" />
</div>
-->

## 🏆 Engineering Highlights

| Area | What was done | Why it matters |
|------|---------------|----------------|
| 🏛 **Clean Architecture** | Strict **Presentation → Domain ← Data** separation with the dependency rule enforced | Business rules are independent of UI, network and storage choices |
| 🧱 **SOLID Principles** | Small single-purpose classes, abstractions in the Domain layer, implementations in Data | Code that is easy to extend, refactor and unit-test |
| 💉 **Dependency Injection** | `get_it` + `injectable` with generated registration code | No manual wiring, no hidden singletons, swappable implementations |
| 📴 **Offline-First** | Local database (Hive CE) is part of the repository flow, the network refreshes it | Fast startup, instant UI and graceful behaviour without connectivity |
| 🧩 **Modular Design** | Feature modules, a shared `core`, and a dedicated `design_system` | Features evolve independently and scale with team size |
| 🗺 **Maps & Location** | `maplibre_gl` vector maps with `geolocator` and runtime permission handling | Smooth, customizable, vendor-neutral map rendering |
| 🔀 **Predictable State** | `flutter_bloc` with `equatable` value equality | Unidirectional data flow and reproducible UI states |
| 🧭 **Type-Safe Routing** | `auto_route` with code generation | Compile-time checked navigation and arguments |
| 🌍 **Localization** | `easy_localization`, `intl`, Persian calendar and number utilities | Ready for multi-language and RTL audiences |

## 🏗 Architecture

The app follows **Clean Architecture**. Source-code dependencies point **inward only**: the Domain layer knows nothing about Flutter, HTTP or databases.

```mermaid
flowchart TB
    P["<b>Presentation</b><br/>Pages · Widgets · BLoC"]
    D["<b>Domain</b><br/>Entities · Use Cases · Repository Contracts"]
    DA["<b>Data</b><br/>Repository Implementations · Data Sources · Models"]

    P --> D
    DA --> D
```

| Layer | Responsibility | Depends on |
|-------|----------------|------------|
| **Presentation** | UI rendering, user interaction, state management with BLoC | Domain |
| **Domain** | Pure Dart business logic: entities, use cases and repository **interfaces** | Nothing |
| **Data** | Repository **implementations**, remote and local data sources, DTO mapping | Domain |

**Key consequences of this design**

- The UI can be replaced without touching business rules.
- The database or API client can be swapped without touching use cases.
- Use cases and BLoCs can be unit-tested with simple mocks, with no Flutter runtime needed.

## 🧠 SOLID Principles in Practice

| Principle | How it is applied |
|-----------|-------------------|
| **S**: Single Responsibility | Each use case performs one business action. Data sources only fetch or store. BLoCs only translate events into states. |
| **O**: Open/Closed | New behaviour is added by new implementations or use cases, without modifying existing, tested code. |
| **L**: Liskov Substitution | Any repository or data-source implementation can replace another (for example remote ↔ local ↔ fake) without breaking consumers. |
| **I**: Interface Segregation | Contracts are small and feature-specific, so consumers never depend on methods they do not use. |
| **D**: Dependency Inversion | High-level policy (Domain) defines abstractions. Low-level details (Data) implement them and are injected at runtime. |

## 💉 Dependency Injection

Dependencies are resolved through **`get_it`** as the service locator and **`injectable`** for annotation-based, **code-generated** registration.

- No hand-written registration boilerplate
- Constructor injection throughout, so dependencies are explicit
- Easy to replace implementations in tests

A simplified illustration of the pattern:

```dart
// Domain: abstraction
abstract class RideRepository {
  Future<List<Ride>> getRides();
}

// Data: implementation, registered automatically by injectable
@LazySingleton(as: RideRepository)
class RideRepositoryImpl implements RideRepository {
  RideRepositoryImpl(this._remote, this._local);

  final RideRemoteDataSource _remote;
  final RideLocalDataSource _local;

  @override
  Future<List<Ride>> getRides() async { /* local first, then refresh */ }
}
```

Generate the registrations with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📴 Offline-First Strategy

The local database is **part of the core data flow**, not a fallback added later. The UI is always rendered from local data, and the network keeps that data fresh.

```mermaid
sequenceDiagram
    participant UI as Presentation - BLoC
    participant Repo as Repository
    participant Local as Local DB - Hive CE
    participant Remote as Remote API - Dio

    UI->>Repo: Request data
    Repo->>Local: Read cached data
    Local-->>UI: Emit cached state instantly
    Repo->>Remote: Fetch latest when online
    Remote-->>Repo: Fresh data
    Repo->>Local: Persist
    Local-->>UI: Emit updated state
```

**Benefits**

- ⚡ Instant screens, with no loading spinner for data the user has already seen
- 📶 Usable on weak or unstable mobile networks
- 🔋 Fewer redundant network calls
- 🧪 A single source of truth for the UI

## 🧩 Modular Project Structure

```
lib/
├── app/               # App bootstrap, root widget and global wiring
├── core/
│   ├── common/        # Shared abstractions and cross-cutting code
│   ├── db/            # Local persistence layer (offline-first storage)
│   ├── network/       # HTTP client and networking infrastructure
│   └── utilities/     # Helpers and extensions
├── design_system/     # Reusable UI components and theming
├── features/
│   └── ride_request/  # Self-contained feature module (data · domain · presentation)
└── main.dart          # Entry point
```

**Design rules**

- **Feature modules** are self-contained and own their own data, domain and presentation layers.
- **`core`** holds infrastructure shared by all features and never depends on a feature.
- **`design_system`** keeps the UI building blocks separate from feature code, so the look and feel stays consistent.
- Adding a new feature means adding a new folder under `features/`, with no changes to existing features.

## 🛠 Tech Stack

| Category | Technologies |
|----------|--------------|
| **Framework** | Flutter, Dart |
| **State Management** | `flutter_bloc`, `equatable`, `rxdart` |
| **Dependency Injection** | `get_it`, `injectable`, `injectable_generator` |
| **Routing** | `auto_route` (code-generated, type-safe) |
| **Networking** | `dio` |
| **Local Storage** | `hive_ce`, `hive_ce_flutter`, `shared_preferences` |
| **Maps & Location** | `maplibre_gl`, `geolocator`, `permission_handler` |
| **Serialization** | `json_annotation`, `json_serializable` |
| **Localization** | `easy_localization`, `intl`, `persian_datetime_picker`, `persian_tools` |
| **Configuration** | `flutter_dotenv` |
| **UI & UX** | `responsive_framework`, `flutter_animate`, `shimmer`, `cached_network_image`, `flutter_svg` |
| **Code Quality** | `flutter_lints`, `build_runner` |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (stable channel) with Dart SDK `^3.13.4`
- Android Studio or VS Code with the Flutter plugin
- An Android emulator/device or an iOS simulator/device

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ShahabSohrevardi/koolbar_demo.git
cd koolbar_demo

# 2. Install dependencies
flutter pub get

# 3. Generate DI, routing, serialization and Hive adapters
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Configuration

Runtime configuration is loaded with `flutter_dotenv` from a `.env` file in the project root, which is declared as an asset in `pubspec.yaml`. Review the file and provide your own values before running.

> ⚠️ Never commit real secrets or API keys to version control.

### Build

```bash
flutter build apk --release    # Android
flutter build ios --release    # iOS
```

## 🎯 Skills Demonstrated

- Designing and enforcing **Clean Architecture** boundaries in a real Flutter codebase
- Applying **SOLID principles** and **Dependency Inversion** with generated DI
- Building an **offline-first** data layer with local persistence
- Structuring a **modular, scalable** project with shared core and design system
- Integrating **vector maps, location services and permissions**
- **BLoC** state management, type-safe routing and code generation workflows

## 🗺 Roadmap

- [ ] Real-time driver matching
- [ ] Payment gateway integration
- [ ] Trip history
- [ ] Unit and widget test coverage for use cases and BLoCs
- [ ] CI pipeline (analyze, test, build)

## 🤝 Contributing

Contributions, issues and feature requests are welcome.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit using Conventional Commits: `git commit -m "feat: add amazing feature"`
4. Push the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

## 👤 Author

**Shahab Sohrevardi**
GitHub: [@ShahabSohrevardi](https://github.com/ShahabSohrevardi)

<!-- Add your LinkedIn and email here for CV use -->

---

<div align="center">

⭐ If this project helped or inspired you, please consider giving it a star.

</div><div align="center">

# 🚕 Koolbar Demo | کولبار

**اپلیکیشن رزرو تاکسی و حمل‌ونقل هوشمند با Flutter**
**A production-grade Ride-Hailing & Navigation demo built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.x-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.x-0175C2?logo=dart)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%7C%20Feature--First-brightgreen)](#-architecture)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-orange.svg)](#-contributing)

[Features](#-features) • [Architecture](#-architecture) • [Kalman Filter](#-gps-smoothing-with-kalman-filter) • [Getting Started](#-getting-started) • [Contributing](#-contributing)

</div>

---

## 📖 About

**Koolbar Demo** is a modular ride-hailing and navigation application that shows enterprise-level Flutter engineering. It combines **Clean Architecture**, smooth vector maps with **MapLibre GL**, and a **Kalman Filter** that removes noise from GPS streams. The result is stable, natural movement of the user and driver on the map.

> **کولبار دمو** یک اپلیکیشن ماژولار برای رزرو تاکسی و حمل‌ونقل است. این پروژه با معماری تمیز (Clean Architecture)، نقشه‌ی برداری MapLibre و فیلتر کالمن برای حذف نویز GPS ساخته شده است.

## 📸 Screenshots

<div align="center">

<img src="docs/screen-shots/Screenshot-1.png" alt="Home screen" width="250" />

</div>

<!--
To add more screenshots, put the files in docs/screen-shots/ and add them side by side:

<div align="center">
  <img src="docs/screen-shots/Screenshot-1.png" alt="Home" width="250" />
  <img src="docs/screen-shots/Screenshot-2.png" alt="Ride Request" width="250" />
  <img src="docs/screen-shots/Screenshot-3.png" alt="Tracking" width="250" />
  <img src="docs/screen-shots/Screenshot-4.png" alt="Tracking" width="250" />
</div>
-->

## ✨ Features

- 🧩 **Modular, feature-first architecture**: independent modules that are easy to scale and maintain.
- 📍 **Smart GPS telemetry**: a real-time Kalman Filter removes jitter, so markers move smoothly on the map.
- 🗺 **MapLibre GL maps**: vector tiles, custom layers and Neshan map service integration.
- 🧭 **Declarative navigation**: `go_router` with deep-linking and separate routes for each feature.
- 🏛 **Clean Architecture and SOLID**: clear Domain, Data and Presentation layers.
- 💉 **Dependency Injection**: IoC with `get_it` and `injectable`.

## 🏗 Architecture

The project follows **Clean Architecture** with a **layered-by-feature** layout. Dependencies always point inward, toward the Domain layer.

```
┌──────────────────────────────────────┐
│           Presentation               │  Pages, Widgets, State
├──────────────────────────────────────┤
│              Domain                  │  Entities, UseCases, Repository contracts
├──────────────────────────────────────┤
│               Data                   │  Models, DataSources, Repository impl
└──────────────────────────────────────┘
```

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | UI, user interaction and state management |
| **Domain** | Business logic, pure Dart, independent of any framework |
| **Data** | API calls, local storage and mapping models to entities |

## 🧭 GPS Smoothing with Kalman Filter

Raw GPS data is noisy and makes markers jump on the map. The app runs a **Kalman Filter** on the location stream. It works in two steps:

1. **Predict:** estimates the next position from the previous state and speed.
2. **Update:** combines the prediction with the new measurement, weighted by measurement accuracy.

This gives a smooth path, less jitter and a better tracking experience for both passenger and driver.

## 🗺 Maps & Routing

- Vector map rendering with **MapLibre GL**
- Neshan map service for tiles and routing
- Custom layers for markers, routes and origin/destination

## 📦 Project Structure

```
lib/
├── core/                 # Shared utilities, DI, router, theme, network
├── features/
│   └── ...               # One folder per feature (data / domain / presentation)
└── main.dart
```

## 🛠 Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter, Dart |
| Map | MapLibre GL, Neshan |
| Routing | auto_route |
| DI | get_it, injectable |
| Signal filtering | Kalman Filter (custom implementation) |
| Architecture | Clean Architecture, Feature-First |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>= 3.x`
- Dart SDK `>= 3.x`
- Android Studio or VS Code
- A Neshan API key (if you use Neshan services)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ShahabSohrevardi/koolbar_demo.git
cd koolbar_demo

# 2. Install dependencies
flutter pub get

# 3. Generate code (injectable, etc.)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Configuration

Add your API keys to the project's config file. Never commit real keys to the repository.

### Build

```bash
flutter build apk --release        # Android
flutter build ios --release        # iOS
```

## 🗺 Roadmap

- [ ] Real-time driver matching
- [ ] Payment gateway integration
- [ ] Trip history
- [ ] Multi-language support (FA/EN)
- [ ] Unit and widget tests

## 🤝 Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m "feat: add amazing feature"`
4. Push the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request.


## 👤 Author

**Shahab Sohrevardi**
GitHub: [@ShahabSohrevardi](https://github.com/ShahabSohrevardi)

---

<div align="center">

⭐ If you like this project, give it a star!

</div>
