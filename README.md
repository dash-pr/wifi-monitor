# WiFi Monitor for macOS (SwiftUI)

This repo contains Swift source files you can drop into a new Xcode SwiftUI macOS App to build a live Wi‑Fi monitor with beautiful Apple‑like UI, charts, and tables. It samples every 1s, 2s, or 5s and displays SSID, RSSI, Noise, SNR, TX Rate, Channel, MCS, NSS, and more.

What you get
- Modern SwiftUI macOS app structure (Views, ViewModel, Services, Models)
- Live polling using a configurable interval (1/2/5s)
- Beautiful Charts (Swift Charts) for RSSI, Noise, SNR, TX Rate
- Cards with current metrics and a detailed table
- Uses Apple’s private "airport" CLI to access extra fields (MCS/NSS) and falls back gracefully

Requirements
- macOS 13+ (Ventura) recommended, macOS 12 may work with minor tweaks
- Xcode 14+ (SwiftUI + Charts)

Setup (once)
1) Open Xcode → File → New → Project… → App
   - Name: WiFiMonitor
   - Interface: SwiftUI
   - Language: Swift
   - Platform: macOS, Minimum macOS: 13.0
2) In the new project, delete the default ContentView.swift and <AppName>App.swift files (we’ll replace them).
3) In Finder or Xcode, create folders (Groups) matching this structure:
   - Sources/
     - App/
     - Models/
     - Services/
     - ViewModels/
     - Views/
       - Components/
       - Charts/
4) Drag the files from this repo’s Sources folder into your Xcode project (Copy items if needed).
5) Build & Run. No special entitlements are required. The app executes the built‑in airport CLI to read Wi‑Fi stats.

Notes
- The airport binary path used: /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
- This is a private tool but ships on macOS and is commonly used for diagnostics. For App Store distribution, consider CoreWLAN for public APIs (you’ll miss MCS/NSS).
- Charts requires macOS 13+.

Customization ideas
- Add a Menu Bar Extra with compact live stats
- Export history to CSV/JSON
- Add alerts if SNR drops below a threshold
- Theme toggles (light/dark, accent color)
