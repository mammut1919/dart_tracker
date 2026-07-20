# Dart Tracker – iOS Build Anleitung

Diese Anleitung beschreibt, wie Dart Tracker auf einem Mac gebaut und auf einem iPhone installiert werden kann.

## Voraussetzungen

### Hardware

- Mac mit aktuellem macOS
- iPhone (optional, aber empfohlen)

### Software

- Xcode (aktuelle Version)
- Flutter SDK
- Git

---

# 1. Xcode installieren

Xcode aus dem Mac App Store installieren.

Nach der Installation einmal starten und die Lizenzbedingungen akzeptieren.

Anschließend im Terminal:

```bash
sudo xcode-select --switch /Applications/Xcode.app
sudo xcodebuild -runFirstLaunch
```

---

# 2. Flutter installieren

Flutter installieren:

https://docs.flutter.dev/get-started/install/macos

Anschließend prüfen:

```bash
flutter doctor
```

Alle Punkte sollten grün sein.

Falls CocoaPods fehlt:

```bash
sudo gem install cocoapods
```

---

# 3. Repository klonen

```bash
git clone https://github.com/mammut1919/dart_tracker.git

cd dart_tracker
```

---

# 4. Abhängigkeiten installieren

```bash
flutter pub get
```

---

# 5. iOS-Abhängigkeiten installieren

```bash
cd ios

pod install

cd ..
```

---

# 6. Verfügbare Geräte prüfen

```bash
flutter devices
```

Beispiel:

```
iPhone 15 Pro
macOS
Chrome
```

---

# 7. Projekt starten

Mit Simulator:

```bash
flutter run
```

oder

```bash
flutter run -d "iPhone 15 Pro"
```

Mit angeschlossenem iPhone:

```bash
flutter run
```

---

# 8. Release Build

APK gibt es unter iOS natürlich nicht.

Ein Release-Build wird erzeugt mit:

```bash
flutter build ios
```

oder

```bash
flutter build ipa
```

Für den ersten Test genügt jedoch `flutter run`.

---

# 9. Falls Xcode Signing verlangt

Projekt öffnen:

```bash
open ios/Runner.xcworkspace
```

In Xcode:

Runner

→ Signing & Capabilities

- Team auswählen
- Apple-ID auswählen
- Bundle Identifier ggf. anpassen

Danach erneut:

```bash
flutter run
```

---

# 10. Bekannte Probleme

## CocoaPods

```bash
pod repo update
pod install
```

---

## Flutter prüfen

```bash
flutter doctor
```

---

## Build bereinigen

```bash
flutter clean

flutter pub get

cd ios

pod install

cd ..

flutter run
```

---

# Feedback

Bitte insbesondere prüfen:

- Startet die App?
- Funktionieren Entries?
- Funktionieren Finishes?
- Funktioniert Backup Import/Export?
- Gibt es Darstellungsfehler?
- Gibt es Bedienprobleme auf dem iPhone?

Vielen Dank fürs Testen!