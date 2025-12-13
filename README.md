# 智慧飲食健康管理系統 (Vege Fruit App)

**第十七組**
**指導教授**: 陳煥
**組員**: 洪靖倫、羅雅馨、楊竣博、林智堅

本專案採用 **CRISP-DM** (跨行業資料探勘標準流程) 方法論進行架構，並針對物聯網 (IoT) 與資料分析應用進行調整。

## 1. 商業理解 (Business Understanding)
**目標**: 開發一款行動應用程式，利用物聯網概念與資料分析，協助使用者辨識與追蹤蔬菜水果。
-   **目的**: 提供直覺的介面，讓使用者能透過拍照、檢視統計數據來管理蔬果攝取或庫存。
-   **成功標準**: 友善的登入介面、流暢的相機整合，以及準確的資料視覺化。

## 2. 資料理解 (Data Understanding)
**資料來源**:
-   **使用者輸入**: 登入憑證 (使用者 ID/Email)。
-   **影像資料**: 透過裝置相機拍攝的照片 (相機頁面)。
-   **統計資料**: 使用數據或庫存數量 (統計頁面)。

## 3. 資料準備 (Data Preparation)
**處理流程**:
-   **影像處理**: 擷取並顯示來自相機的影像。
-   **輸入驗證**: 在登入時驗證使用者憑證。
-   **狀態管理**: 管理使用者工作階段與應用程式狀態 (Flutter `StatefulWidget`)。

## 4. 建模 (Modeling)
**邏輯與演算法**:
-   **認證邏輯**: 簡單的憑證驗證 (目前為演示用的寫死數據)。
-   **導航邏輯**: 在登入、首頁、相機與統計頁面間的路由切換。
-   *(未來擴充)*: 整合 AI/ML 模型 (如 YOLO, CNN) 以自動從拍攝影像中偵測與分類蔬果。

## 5. 評估 (Evaluation)
**測試與驗證**:
-   **功能測試**: 驗證登入流程、相機存取與頁面導航。
-   **UI/UX 審查**: 確保設計符合預期的美學 (例如：藍綠色漸層登入主題)。
-   **效能**: 監控應用程式的反應速度與資源使用率。

## 6. 部署 (Deployment)
**發布**:
-   **平台**: Flutter (Android/iOS/Windows)。
-   **目前狀態**: 具備功能性 UI 與基本導航的開發原型。
-   **執行方式**: 透過 `flutter run` 執行。

---

## 專案結構 (Project Structure)

```text
vege_fruit_app/
├── android/       # Android 原生代碼
├── assets/        # 靜態資源 (圖片等)
├── ios/           # iOS 原生代碼
├── lib/           # Flutter 應用程式主要程式碼
│   ├── screens/   # 介面 (UI) 相關檔案
│   │   ├── ask_ai_page.dart
│   │   ├── camera_page.dart
│   │   ├── help_page.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   └── stats_page.dart
│   └── main.dart  # 程式進入點
├── web/           # Web 相關代碼
├── windows/       # Windows 原生代碼
├── pubspec.yaml   # 專案依賴與設定
└── README.md      # 專案說明文件
```

## 快速開始 (Getting Started)

本專案是 Flutter 應用程式的起點。

如果您是第一次接觸 Flutter 專案，以下資源可協助您入門：

- [Lab: 編寫您的第一個 Flutter 應用程式](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: 實用的 Flutter 範例](https://docs.flutter.dev/cookbook)

如需更多關於 Flutter 開發的協助，請參閱
[線上文件](https://docs.flutter.dev/)，其中提供了教學、範例、行動開發指南以及完整的 API 參考。
