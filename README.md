# Croquette

An iOS app for crochet makers to organize projects, track row-by-row progress, and detect stitches from photos using computer vision.

## Features

- **Project management** — create and save crochet projects with persistent storage via SwiftData.
- **Row tracking** — log each row's stitch type and progress as you work.
- **Stitch detection** — snap a photo and get stitch predictions from a Roboflow vision model.

## Tech Stack

- SwiftUI + SwiftData (iOS 15.4+)
- [Roboflow](https://roboflow.com) hosted inference for crochet stitch detection
- CocoaPods for dependencies

## Setup

1. Install dependencies:
   ```sh
   pod install
   ```
2. Open the workspace (not the project):
   ```sh
   open Croqet.xcworkspace
   ```
3. Add your Roboflow API key to `Croqet/Secrets.xcconfig`:
   ```
   ROBOFLOW_API_KEY = your_key_here
   ```
4. Build and run on a device or simulator.

## Project Structure

```
Croqet/
├── CroqetApp.swift        App entry point
├── Project/               Project list & main content
├── NewProject/            New project creation flow
├── ProjectDetail/         Per-project detail & row editing
├── ProjectChecker/        Stitch-detection result screen
├── Models/
│   ├── Camera/            Camera capture & photo preview
│   ├── Vision/            CrochetAnalyzer (Roboflow integration)
│   └── Model/             SwiftData models (ProjectData, Row)
├── Component/             Reusable UI components
└── DesignSystem/          Fonts & styling
```
