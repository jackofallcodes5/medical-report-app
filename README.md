# Medical Report Analysis App

A full-stack application that analyzes medical reports using Google Gemini AI and explains them in simple, plain English.

## Project Structure
- `App/` - Flutter frontend (Android app)
- `BackEnd/` - Node.js & Express backend

---

## 1. Prerequisites

1. **Node.js**: Installed (v22.1.0 is available on your system).
2. **Flutter SDK**: [Download and install Flutter](https://docs.flutter.dev/get-started/install/windows) if you haven't already.
3. **Gemini API Key**: Get a free API key from [Google AI Studio](https://aistudio.google.com/apikey).

---

## 2. Backend Setup (Node.js)

1. Open a terminal and navigate to the `BackEnd` folder:
   ```cmd
   cd c:\Shushrut\BackEnd
   ```
2. Install dependencies:
   ```cmd
   npm install
   ```
3. Set up your environment variables:
   - Rename `.env.example` to `.env`
   - Open `.env` and replace `your_gemini_api_key_here` with your actual Gemini API key.
4. Start the development server:
   ```cmd
   npm run dev
   ```
   *The server will start on `http://localhost:3000`.*

---

## 3. Frontend Setup (Flutter Android App)

Since this folder was created manually, you first need to let Flutter generate the Android platform files:

1. Open a terminal and navigate to the `App` folder:
   ```cmd
   cd c:\Shushrut\App
   ```
2. Generate the required platform files (this won't overwrite our custom code):
   ```cmd
   flutter create . --platforms android
   ```
3. **Crucial Step**: Add Internet Permission for Android.
   - Open `c:\Shushrut\App\android\app\src\main\AndroidManifest.xml`
   - Add this line inside the `<manifest>` tag, right before `<application>`:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```
4. Install dependencies:
   ```cmd
   flutter pub get
   ```
5. Run the app on an emulator or connected device:
   ```cmd
   flutter run
   ```

*(Note: The app is currently configured to connect to `http://10.0.2.2:3000` which is the Android Emulator's alias for your PC's localhost. If testing on a physical Android device over Wi-Fi, change `_baseUrl` in `App/lib/services/api_service.dart` to your PC's local IP address, e.g., `http://192.168.1.100:3000`)*

---

## 4. Building the Android APK

When you are ready to build the final APK to share or install on your phone:

1. Open a terminal in the `App` folder:
   ```cmd
   cd c:\Shushrut\App
   ```
2. Build the release APK:
   ```cmd
   flutter build apk --release
   ```
3. Once the build finishes, you will find your APK file at:
   `c:\Shushrut\App\build\app\outputs\flutter-apk\app-release.apk`
