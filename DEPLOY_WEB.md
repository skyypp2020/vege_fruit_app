# Flutter Web Deployment Guide

將您的 Flutter APP 部署為網頁 (Web App)，讓其他人可以直接透過瀏覽器存取。

## 前置準備
確認您的專案已啟用 Web 支援 (目前專案已有 `web` 資料夾，表示已啟用)。

## 方法一：使用 GitHub Pages (推薦)
如果您的專案已經託管在 GitHub 上，這是最方便的方法。

1.  **建立 Web Build**
    在終端機執行以下指令，這會將專案編譯成靜態網頁檔案：
    ```bash
    flutter build web --base-href "/<repository-name>/"
    ```
    *請將 `<repository-name>` 替換為您的 GitHub 儲存庫名稱 (例如 `vege_fruit_app`)。如果您的網址是 `username.github.io` 而沒有子路徑，則使用 `--base-href "/"`。*

2.  **部署**
    編譯完成後，檔案會位於 `build/web` 資料夾。
    您可以使用 `gh-pages` 套件來自動部署，或手動將此資料夾的內容推送到 GitHub 的 `gh-pages` 分支。

    **手動方式 (範例)**：
    ```bash
    cd build/web
    git init
    git add .
    git commit -m "Deploy to GitHub Pages"
    git branch -M main
    git remote add origin https://github.com/<username>/<repository-name>.git
    git push -u -f origin main:gh-pages
    ```

3.  **設定 GitHub**
    到 GitHub 儲存庫的 **Settings** -> **Pages**，將 Source 設定為 `gh-pages` 分支。

## 方法二：使用 Vercel / Netlify (最簡單)
如果您不想處理 Git 分支，可以使用這些服務的 "Drag & Drop" 功能。

1.  **建立 Web Build**
    ```bash
    flutter build web --release
    ```

2.  **上傳**
    -   前往 [Vercel](https://vercel.com/) 或 [Netlify](https://www.netlify.com/)。
    -   註冊/登入後，找到 "Add New Project" 或 "Deploy manually"。
    -   將專案中的 `build/web` 資料夾直接拖曳到上傳區塊。
    -   幾秒鐘後，您就會獲得一個可公開存取的 HTTPS 網址。

## 注意事項
-   **圖片顯示**: 確保 `pubspec.yaml` 中的圖片路徑正確，且在 Web 上通常需要將圖片放在 `assets` 資料夾並正確宣告。
-   **CORS 問題**: 如果您的 APP 有呼叫外部 API，在 Web 上可能會遇到跨域資源共享 (CORS) 限制。
