# 🚀 Persona - Responsive Flutter Portfolio

A premium, responsive developer portfolio web application built with **Flutter** and **GetX Architecture**, featuring high-fidelity size and color transition animations. 

## ✨ Features

* **GetX Architecture**: Structured using clean, modular GetX patterns (Controllers, Bindings, and Routing) to decouple business logic from the UI.
* **Premium reference layout**: Styled after modern split-screen editorial web templates, incorporating clean typography, balanced spacing, and dark theme colors.
* **High-Fidelity Size & Color Transition Animations**:
  * **Interactive Nav Links**: Smooth bottom border underline transition on active tab hover.
  * **Vibrant Social Buttons**: Resizes padding and fills background with brand-specific colors (GitHub dark-slate and LinkedIn blue) on hover, launching external URLs via `url_launcher`.
  * **Concise Skills Badge Grid**: Concise grid cells displaying tech icons and percentages. Selecting a chip opens an animated details panel displaying a progress bar and core expertise text.
  * **Dynamic Project Showcases**: Elevation lift (margin shifting) and color border glows on hover, expanding card heights on tap to reveal architecture details.
  * **Theme Switcher FAB**: Custom size morphing (circle to pill shape) on hover and color transitions (blue to warm amber) on click.
* **Responsive Layout**: Adapts layout elements dynamically for Mobile, Tablet, and Desktop web views.
* **Reactive State Management**: Toggle dark/light modes and selection tabs instantly with GetX `.obs` observables.

---

## 🛠️ Tech Stack

* **Framework**: Flutter Web / Mobile
* **State Management & Routing**: GetX
* **Typography**: Google Fonts (Outfit)
* **URL Handling**: `url_launcher`

---

## 🚀 How to Run the App

1. **Clone the repository**:
   ```bash
   git clone <your-repo-link>
   cd <repo-name>
   ```
2. **Download dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the application (Web preview)**:
   ```bash
   flutter run -d chrome
   ```
4. **Build production build (Web)**:
   ```bash
   flutter build web
   ```
