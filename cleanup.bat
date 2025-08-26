@echo off
echo ========================================
echo Moveo Project Cleanup Script
echo ========================================
echo.

echo Cleaning Flutter project...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Analyzing project...
flutter analyze

echo.
echo Checking for unused dependencies...
flutter pub deps --style=compact

echo.
echo ========================================
echo Cleanup completed!
echo ========================================
echo.
echo Next steps:
echo 1. Review any analysis warnings
echo 2. Check for unused dependencies
echo 3. Run tests: flutter test
echo 4. Build project: flutter build
echo.
pause
