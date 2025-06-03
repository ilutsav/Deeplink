# Flutter Deep Link Implementation with app_links

This Flutter project demonstrates how to handle deep links and dynamic links using the [`app_links`](https://pub.dev/packages/app_links) package. It also shows how to create and process dynamic links via an API or URL parameters.

---

## Features

- Listen for app links (deep links) when the app is launched from a terminated state.
- Listen for incoming app links while the app is running (foreground or background).
- Handle different link paths (`/product`, `/profile`, `/share`) with query parameters.
- Navigate to appropriate screens based on deep link content.
- Support for custom dynamic link creation via API or URL parameter construction.
- Android manifest setup for deep link handling and app link verification.

---

## Getting Started

### 1. Setup and Dependencies

Add the required dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.4.0
  app_links: ^6.4.0
