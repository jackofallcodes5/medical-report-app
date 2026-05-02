# Medical Report App: AI-Powered Medical Analysis 🩺

Medical Report App is a professional full-stack application designed to bridge the gap between complex medical terminology and patient understanding. By leveraging the power of **Google Gemini AI**, the app analyzes medical reports and provides clear, simplified explanations in plain English.

---

## 📱 Download & Install

The application is ready for immediate use. You can download the latest Android build below:

### [📥 Download MedicalReportApp.apk](MedicalReportApp.apk)

> [!TIP]
> **Installation Note:** Since this is a custom build, you may need to enable "Install from Unknown Sources" in your Android security settings to complete the installation.

---

## ✨ Key Features

- **AI-Driven Analysis**: Uses state-of-the-art Gemini AI to interpret complex medical data.
- **Plain English Summaries**: Translates medical jargon into easy-to-understand language.
- **Hosted Backend**: Pre-configured to connect to a secure hosted server on Render.
- **Safety First**: Includes necessary medical disclaimers and professional consultation advice.
- **Modern UI**: A clean, intuitive interface built with Flutter for a seamless experience.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Android)
- **Backend**: Node.js & Express (Hosted on Render)
- **AI Engine**: Google Gemini AI
- **Communication**: RESTful API with Multipart support for file uploads.

---

## 🚀 Development Setup

If you wish to run the project locally for development:

### 1. Prerequisites
- **Node.js**: v20+ recommended.
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install/windows).
- **Gemini API Key**: Obtain one from [Google AI Studio](https://aistudio.google.com/apikey).

### 2. Backend Configuration
1. Navigate to `BackEnd/`.
2. Run `npm install`.
3. Create a `.env` file and add:
   ```env
   GEMINI_API_KEY=your_actual_key_here
   PORT=3000
   ```
4. Start the server: `npm run dev`.

### 3. Mobile App Configuration
1. Navigate to `App/`.
2. Run `flutter pub get`.
3. Run the app: `flutter run`.

---

## 📄 License

This project is personal property. All rights reserved.

---

*Developed with ❤️ to make healthcare information more accessible.*
