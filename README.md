AgroCore

Gestión inteligente para viveros y sistemas agrícolas

- Tabla de contenido

Descripción general

Características

Tecnologías

Estructura del proyecto

Flujo de trabajo con Git

Instalación y ejecución

Equipo

Roadmap

- Descripción general

AgroCore es una aplicación multiplataforma desarrollada en Flutter para la gestión completa de viveros y operaciones agrícolas.
Centraliza procesos como siembras, pedidos, localización de plantas y alertas provenientes de sensores IoT.
El proyecto mantiene una arquitectura modular, escalable y orientada a datos en tiempo real.

- Características

Pedidos: creación, edición y seguimiento.

Siembras: registro y control detallado de cultivos.

Ubicación de plantas: organización por lotes y áreas.

Alertas IoT: notificaciones por humedad, temperatura y otros parámetros.

Dashboards: vistas personalizadas para cada rol.

Usuarios / Roles: permisos y control de accesos.

🛠 Tecnologías

Flutter / Dart

Provider (gestión de estado)

fl_chart (gráficas)

GitHub (control de versiones)

Sensores IoT: ESP8266, LoRa, Arduino

- Estructura del proyecto
agrocore/
├─ lib/
│  ├─ main.dart
│  ├─ dashboards/
│  │  └─ ingeniero_dashboard.dart
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

- Flujo de trabajo con Git

Ramas:

main → producción estable

dev → integración

feature/... → cada módulo o funcionalidad

Reglas:

Los PR van de feature → dev

No se trabaja directo en main

Convenciones de commit: feat:, fix:, refactor:

- Instalación y ejecución
git clone https://github.com/YeisenK/agrocore.git
cd agrocore
flutter pub get
flutter run

- Equipo

Yeisen K. — PM & Dashboards

Eduardo — Pedidos

René — Ubicación y alertas

Sebas — Siembras

- Roadmap

 Integración con sensores reales

 Notificaciones push

 Exportación PDF / Excel

 Integración con Odoo

 IA para predicciones agrícolas

 Dashboard avanzado para ingenieros
