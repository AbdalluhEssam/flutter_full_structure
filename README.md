# Flutter Full Structure Generator 🏗️

A powerful Visual Studio Code extension that helps you scaffold **Clean Architecture** for your Flutter apps in seconds.

This tool creates full project structure or feature modules with proper domain/data/presentation layers, as well as essential shared layers like `core`, `routing`, `theme`, and `utils`.

---

## ✨ Features

- ✅ **Generate Full Project**: Clean architecture with:
  - `core/` (constants, network, services, utils, theme, routing, cubits)
  - `features/` (e.g., splash, onboarding, auth)
  - `main.dart`, `app.dart`, `app_bloc_observer.dart`
  - Pre-configured `pubspec.yaml`
  - `assets/` folders with dummy localization
- ✅ **Generate Feature Only**: Create a new feature module with domain, data, and presentation layers.
- ✅ Automatically runs Dart scripts via terminal
- ✅ Intelligent folder creation
- ✅ Works on any Flutter project

---

## 🚀 How to Use

### 🔹 Generate Full Project Structure

1. Open a Flutter project in VS Code
2. Press `Ctrl + Shift + P` or `Cmd + Shift + P`
3. Type `Flutter Full Structure: Generate` and hit Enter
4. Select `Generate Full Project`
5. Your app structure will be generated instantly

### 🔹 Generate a New Feature

1. Same as above (`Ctrl + Shift + P`, search `Flutter Full Structure: Generate`)
2. Select `Generate Feature`
3. Enter the **feature name** (e.g., `login`, `home`)
4. It creates:
   - `lib/features/feature_name/`
   - Organized folders: `domain`, `data`, `presentation`
   - Ready-to-code files like:
     - `feature_entity.dart`
     - `feature_repository.dart`
     - `feature_usecase.dart`
     - `feature_model.dart`
     - Cubit & state classes
     - View (page) with `BlocBuilder`

---

## 📁 Files Structure (Generate Full Project)

```
lib/
├── core/
│   ├── constants
│   ├── network
│   ├── errors
│   ├── utils
│   ├── services
│   ├── routing
│   ├── theme
│   ├── cubit
│   └── extensions
├── features/
│   ├── splash
│   ├── onboarding
├── app.dart
├── main.dart
└── app_bloc_observer.dart
```

---

## 🔧 Requirements

- ✅ Dart SDK installed & configured
- ✅ Flutter SDK installed
- ✅ `tool/` directory is auto-created

---

## 🛠️ Scripts Included

- `generate_project.dart` - Generates entire project scaffold
- `generate_feature.dart` - Generates a single feature module

These are automatically copied from the extension's `assets/` folder into `tool/` if they don't exist.

---

## 🖼 Preview

![Preview](icon.jpeg)

---

## 📦 Installation

1. Download the `.vsix` file
2. Install manually:
```bash
code --install-extension flutter_clean_arch_gen.vsix
```
3. Or search for `Flutter Full Structure Generator` in VS Code Marketplace (if published)

---

## 👨‍💻 Author

Built with ❤️ by **Abdalluh Essam** 🇪🇬

📩 Email: abdallhesam100@gmail.com

---

## 📄 License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2025 Abdalluh Essam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙌 Contributions

Pull requests are welcome!
Feel free to fork the project and open issues for suggestions or improvements. 🙏

