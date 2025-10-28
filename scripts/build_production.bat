@echo off
echo Building production APK...

echo Cleaning previous builds...
flutter clean
flutter pub get

echo Building release APK with obfuscation...
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

echo Production APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk

pause