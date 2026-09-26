# 🚀 Koolbar Demo (کولبر)

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.x-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%7C%20Feature--First-brightgreen)](#-architecture--design-principles)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A high-performance, modular, and production-grade **Ride-Hailing & Navigation Demo** built with **Flutter**. This project demonstrates enterprise-level engineering standards, clean architecture principles, smooth interactive mapping via MapLibre, and real-time noise reduction using a 1D/2D **Kalman Filter** for telemetry and GPS sensor streams.

---

## 📑 Table of Contents
- [✨ Key Features](#-key-features)
- [🏗 Architecture & Design Principles](#-architecture--design-principles)
- [🧭 Location Smoothing with Kalman Filter](#-location-smoothing-with-kalman-filter)
- [🗺 Maps & Routing Infrastructure](#-maps--routing-infrastructure)
- [📦 Project Structure (Layered by Feature)](#-project-structure-layered-by-feature)
- [🛠 Tech Stack & Dependencies](#-tech-stack--dependencies)
- [🚀 Getting Started](#-getting-started)
- [🤝 Contributing](#-contributing)

---

## ✨ Key Features

- **Modular & Feature-First Architecture**: Decoupled modules for scalable and maintainable development.
- **Smart GPS Telemetry (Kalman Filter)**: Real-time filtering of noisy GPS signals and jitter for silky-smooth on-map driver/user tracking.
- **MapLibre GL Integration**: Vector-tile map rendering with customized layers and Neshan map service integration.
- **Declarative Navigation & Deep-Linking**: Powered by `go_router` / `app_router` with modular route separation across independent features.
- **Strict Clean Architecture & SOLID Compliance**: Clear separation of concerns (Domain, Data, Presentation layers).
- **Robust Dependency Injection**: Inversion of Control (IoC) with Service Locator pattern (`get_it` / `injectable`).

---

## 🏗 Architecture & Design Principles

The application is architected around the **Clean Architecture** paradigm combined with a **Feature-Driven (Layered-by-Feature)** directory layout.
