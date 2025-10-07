[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

# FreeDefense V1

FreeDefense Game with Flutter and Flame.

<img src="assets/screenshot.jpg" width="275px"/>

## DEMO: [Web version for V0]  
[Web version] http://freedefense.vquant.ml/

Controls:
- Click:  preview the weapon.  (do not block the enemies!)
- Click again: build weapon.
- Click on weapon: update and destroy the weapon
- Collect mine to build weapon

## TODO
* [ ] Game 
    - [ ] Toast to indicate wrong action
    - [ ] Game guide
    - [v] Collect coin and use coin to create cannon
    - [ ] Game Failure/Re-start
* [ ] Weapons
    - [ ] Add more Weapon types
    - [v] Upgrade Weapon with more features. (faster bullet/better aiming/more damage)
* [v] Enemies
    - [v] Add life indicator
* [ ] Next version [TBD]
    - [ ] More topography 
    - [ ] Medal system
 




## Troubleshooting: Windows CMake cache/source mismatch

If you hit an error similar to:

CMake Error: The current CMakeCache.txt directory F:/.../build/windows/x64/CMakeCache.txt is different than the directory C:/.../build/windows/x64 where CMakeCache.txt was created. This may result in binaries being created in the wrong place.

This happens when the project is moved between different folders or drives and the previously generated CMake cache still points to the old path. To fix:

- Run the cleanup script that removes stale Windows build artifacts:
  - PowerShell: powershell -ExecutionPolicy Bypass -File .\scripts\clean_windows_build.ps1
  - CMD: scripts\clean_windows_build.bat
- Then regenerate build files:
  - flutter clean
  - flutter pub get
  - flutter build windows

The script deletes build\windows, build\win32, and windows\flutter\ephemeral so CMake and Flutter regenerate fresh build files for the current path.
