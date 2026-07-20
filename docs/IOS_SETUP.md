# Dart Tracker – iOS Setup

Diese Anleitung beschreibt, wie **Dart Tracker** auf einem Mac gebaut und auf einem iPhone oder im iOS Simulator getestet werden kann.

## Voraussetzungen

### Hardware

- Mac mit aktuellem macOS
- Optional: iPhone

### Software

- Xcode (aktuelle Version)
- Flutter SDK
- Git
- CocoaPods

---

# 1. Xcode installieren

Xcode über den Mac App Store installieren.

Nach der Installation Xcode einmal starten und die Lizenzbedingungen akzeptieren.

Im Terminal anschließend:

```bash
sudo xcode-select --switch /Applications/Xcode.app
sudo xcodebuild -runFirstLaunch
```

---

# 2. Flutter installieren

Flutter gemäß der offiziellen Dokumentation installieren:

https://docs.flutter.dev/get-started/install/macos

Installation prüfen:

```bash
flutter doctor -v
```

Alle Punkte sollten erfolgreich sein.

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

# 5. CocoaPods installieren

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

Es sollte mindestens ein iOS Simulator oder ein angeschlossenes iPhone angezeigt werden.

---

# 7. App starten

Simulator:

```bash
flutter run
```

oder

```bash
flutter run -d "iPhone 16"
```

Falls ein iPhone angeschlossen ist:

```bash
flutter run
```

---

# 8. Falls Xcode Signing verlangt

Projekt öffnen:

```bash
open ios/Runner.xcworkspace
```

In Xcode:

Runner

→ Signing & Capabilities

- Team auswählen
- Apple-ID auswählen
- Bundle Identifier prüfen

Danach erneut:

```bash
flutter run
```

---

# 9. Bekannte Probleme

## Flutter prüfen

```bash
flutter doctor -v
```

---

## CocoaPods aktualisieren

```bash
pod repo update
pod install
```

---

## Projekt bereinigen

```bash
flutter clean

flutter pub get

cd ios

pod install

cd ..

flutter run
```

---

# Testumfang

Bitte folgende Funktionen prüfen:

## Allgemein

- App startet
- Navigation zwischen Entries und Finishes
- App nach Neustart weiterhin funktionsfähig

## Entries

- 180 erfassen
- 171 erfassen
- 162 erfassen
- High Finish
- Short Leg
- Löschen

## Finishes

- Finish erfassen
- Finish-Historie
- Finish Chart
- Löschen

## Daten

- Reset
- Backup Export
- Backup Import

---

# Feedback

Bitte insbesondere melden:

- Abstürze
- Darstellungsfehler
- Probleme beim Dateidialog
- Auffälligkeiten auf iPhone oder iPad
- Bedienprobleme während des Trainings

---

Dokumentversion: passend zu Dart Tracker v1.3.0