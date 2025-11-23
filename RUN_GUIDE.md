# 如何執行 Vege Fruit App

本文件說明如何在 Windows 和手機 (Android/iOS) 上執行此 Flutter 應用程式。

## 前置作業

確保您已經安裝了以下工具：
1.  **Flutter SDK**: [下載並安裝](https://docs.flutter.dev/get-started/install)
2.  **VS Code** 或 **Android Studio**
3.  **Git**

## 1. 在 Windows 上執行

由於您是在 Windows 環境下開發，這是最直接的方式。

1.  開啟終端機 (Terminal) 或 VS Code。
2.  進入專案資料夾：
    ```bash
    cd "d:\03-NCHU\02-104-1\02 - Internet of Things Applications and Data Analysis\finalproject\vege_fruit_app"
    ```
3.  啟用 Windows 桌面支援 (如果尚未啟用)：
    ```bash
    flutter config --enable-windows-desktop
    ```
4.  執行應用程式：
    ```bash
    flutter run -d windows
    ```
    或者在 VS Code 中按下 `F5` 並選擇 "Windows"。

## 2. 在 Android 手機上執行

### 使用實體手機
1.  開啟手機的 **開發者模式 (Developer Options)**。
2.  開啟 **USB 偵錯 (USB Debugging)**。
3.  使用 USB 線將手機連接到電腦。
4.  在終端機輸入 `flutter devices` 確認電腦有抓到手機。
5.  執行應用程式：
    ```bash
    flutter run -d <device_id>
    ```
    (如果只有一台裝置，直接輸入 `flutter run` 即可)

### 使用模擬器 (Emulator)
1.  開啟 Android Studio 的 **Device Manager**。
2.  啟動一個 Android 模擬器。
3.  執行應用程式：
    ```bash
    flutter run
    ```

## 3. 在 iOS 手機上執行 (需要 macOS)

**注意**：在 Windows 電腦上無法直接編譯或執行 iOS App。您需要一台 Mac 電腦。

1.  確保已安裝 Xcode。
2.  連接 iPhone 或開啟 iOS Simulator。
3.  執行應用程式：
    ```bash
    flutter run -d ios
    ```

## 常見指令

- **熱重載 (Hot Reload)**: 在終端機執行時按下 `r`，或在 VS Code 點擊閃電圖示。快速查看畫面修改。
- **熱重啟 (Hot Restart)**: 在終端機執行時按下 `R`。重新啟動 App 狀態。
- **退出**: 在終端機按下 `q`。
