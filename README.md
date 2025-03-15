# RoyCad - Android DWG Viewer

RoyCad is an offline Android application for viewing and navigating AutoCAD DWG files with basic manipulation tools.

![RoyCad Logo](attached_assets/logo-black%20(Custom)%20(1).png)

## Features

- **Offline Viewing**: View AutoCAD DWG files directly on your Android device without an internet connection
- **Layer Management**: Toggle visibility of different layers in your CAD drawings
- **Measurement Tools**: Measure distances, angles, and areas within your drawings
- **Entity Support**: View various CAD entities including:
  - Lines
  - Circles
  - Arcs
  - Text
  - Polylines
- **Zoom and Pan**: Navigate large drawings with intuitive touch controls
- **No Subscriptions**: One-time purchase, no recurring fees

## Technical Details

RoyCad is built using modern Android development practices:

- 100% Kotlin implementation
- MVVM architecture with Android Architecture Components
- Room database for file management
- Hardware-accelerated rendering for smooth performance

## Code Structure

```
app/
├── src/
│   ├── main/
│   │   ├── java/com/roycad/
│   │   │   ├── model/           # Data models and entity classes
│   │   │   │   ├── DwgFile.kt   # DWG file representation for database
│   │   │   │   ├── DrawingData.kt # Contains drawing information
│   │   │   │   ├── Entity.kt    # Base class for all drawing entities
│   │   │   │   ├── Entities.kt  # Specific entity implementations
│   │   │   │   └── Layer.kt     # Layer management
│   │   │   ├── view/            # UI components
│   │   │   │   ├── DrawingView.kt # Main canvas for rendering
│   │   │   │   ├── MainActivity.kt # Main application entry point
│   │   │   │   └── fragments/   # UI fragments for different screens
│   │   │   ├── viewmodel/       # ViewModels for MVVM architecture
│   │   │   │   └── ViewerViewModel.kt # Main ViewModel for drawing interaction
│   │   │   ├── util/            # Utility classes
│   │   │   │   └── DwgRenderer.kt # Handles DWG file parsing and rendering
│   │   │   └── database/        # Room database implementation
│   │   └── res/                 # Android resources (layouts, drawables, etc.)
│   └── test/                    # Unit tests
└── build.gradle                 # App-specific build configuration
```

## Building the Application

### Prerequisites

- Android Studio Arctic Fox (2020.3.1) or newer
- JDK 11 or newer
- Android SDK 30 or newer

### Build Instructions

1. Clone this repository
2. Open the project in Android Studio
3. Run `./gradlew :app:assembleDebug` or use the Run button in Android Studio
4. The APK will be generated in `app/build/outputs/apk/debug/`

### Running Tests

Run `./gradlew test` to execute the unit tests

## GitHub CI/CD Setup

This project includes GitHub Actions workflows for continuous integration and deployment:

### Continuous Integration Workflow

File: `.github/workflows/android-ci.yml`

```yaml
name: Android CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: gradle
      - name: Grant execute permission for gradlew
        run: chmod +x gradlew
      - name: Run unit tests
        run: ./gradlew test
      - name: Build debug APK
        run: ./gradlew assembleDebug
      - name: Upload debug APK
        uses: actions/upload-artifact@v3
        with:
          name: app-debug
          path: app/build/outputs/apk/debug/app-debug.apk
```

### Release Workflow

File: `.github/workflows/android-release.yml`

```yaml
name: Android Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: gradle
      - name: Grant execute permission for gradlew
        run: chmod +x gradlew
      - name: Build release APK
        run: ./gradlew assembleRelease
      - name: Sign APK
        uses: r0adkll/sign-android-release@v1
        with:
          releaseDirectory: app/build/outputs/apk/release
          signingKeyBase64: ${{ secrets.SIGNING_KEY }}
          alias: ${{ secrets.KEY_ALIAS }}
          keyStorePassword: ${{ secrets.KEY_STORE_PASSWORD }}
          keyPassword: ${{ secrets.KEY_PASSWORD }}
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: false
          prerelease: false
      - name: Upload Release Asset
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: app/build/outputs/apk/release/app-release-signed.apk
          asset_name: RoyCad-${{ github.ref_name }}.apk
          asset_content_type: application/vnd.android.package-archive
```

### Deployment Instructions

1. Set up repository secrets in GitHub:
   - `SIGNING_KEY`: Base64-encoded Android keystore file
   - `KEY_ALIAS`: Alias for the key in the keystore
   - `KEY_STORE_PASSWORD`: Password for the keystore
   - `KEY_PASSWORD`: Password for the key
   
2. To trigger a release:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

3. The GitHub Actions workflow will automatically build, sign, and create a release with the APK attached.

## License

This project is proprietary software. All rights reserved.

## Acknowledgements

- Uses a modified version of the AndroidDXF-Library for file parsing
- Icons by Material Design