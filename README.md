# AgroCore

Intelligent management system for nurseries and agricultural operations

- Table of Contents

Overview

Features

Technologies

Project Structure

Git Workflow

Installation

Team

Roadmap

- Overview

AgroCore is a cross-platform application built with Flutter for comprehensive management of nurseries and agricultural systems.
It centralizes operations such as crop tracking, order management, plant location, and IoT-based alerts.
The project follows a modular, scalable architecture optimized for real-time data integration and role-based dashboards.

- Features

Order management: create, edit, and track orders

Crop management: register and monitor crops

Plant location: organize lots and areas

IoT alerts: humidity, temperature, and environmental event notifications

Dashboards: custom views for each user role

User and role system: permissions and access control

- Technologies

Flutter / Dart

Provider (state management)

fl_chart (data visualization)

GitHub (version control)

IoT sensors: ESP8266, LoRa, Arduino

- Project Structure
agrocore/
├─ lib/ 
│  ├─ main.dart 
│  ├─ dashboards/ 
│  │  └─ engineer_dashboard.dart 
│  └─ pages/ 
│     └─ login.dart 
│ 
├─ assets/ 
│  ├─ images/
│  ├─ fonts/
│  └─ mock/
│
├─ web/
│  ├─ index.html
│  ├─ manifest.json
│  └─ icons/
│     ├─ Icon-192.png
│     ├─ Icon-512.png
│     ├─ Icon-maskable-192.png
│     └─ Icon-maskable-512.png
│
├─ android/
├─ ios/
├─ macos/
├─ linux/
├─ windows/
├─ test/
├─ pubspec.yaml
├─ analysis_options.yaml
└─ .gitignore

- Git Workflow

Branches

main → stable production branch

dev → integration branch

feature/... → individual modules and features

Rules

Pull requests must go from feature → dev

No direct commits to main

Commit message conventions: feat:, fix:, refactor:

- Installation
git clone https://github.com/YeisenK/agrocore.git
cd agrocore
flutter pub get
flutter run

- Team

Yeisen K. — PM & Dashboards

Eduardo — Orders

René — Location & Alerts

Sebas — Crops

- Roadmap

 Real sensor integration

 Push notifications

 PDF/Excel reports

 Odoo integration

 AI-based predictions

 Advanced engineer dashboard
