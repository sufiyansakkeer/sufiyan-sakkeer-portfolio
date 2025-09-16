# Firebase Setup Guide for Template Users

This Flutter project uses a secure template-based approach for Firebase configuration. All sensitive API keys have been removed from the source code and replaced with environment variables.

## 🚀 Quick Start

### 1. Clone and Setup Environment

```bash
# Clone the repository
git clone <your-repo-url>
cd <project-directory>

# Copy the environment template
cp .env.example .env
```

### 2. Get Your Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Go to **Project Settings** (gear icon)
4. Scroll to **Your apps** section

### 3. Configure Web App

1. Click **Add app** → **Web** (if not already created)
2. Register your app with a nickname
3. Copy the configuration values:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",           // → FIREBASE_WEB_API_KEY
  authDomain: "project.firebaseapp.com",  // → FIREBASE_AUTH_DOMAIN
  projectId: "your-project",     // → FIREBASE_PROJECT_ID
  storageBucket: "project.firebasestorage.app", // → FIREBASE_STORAGE_BUCKET
  messagingSenderId: "123456",   // → FIREBASE_MESSAGING_SENDER_ID
  appId: "1:123456:web:abc123",  // → FIREBASE_WEB_APP_ID
  measurementId: "G-ABC123"      // → FIREBASE_WEB_MEASUREMENT_ID
};
```

### 4. Configure Android App (Optional)

1. Click **Add app** → **Android**
2. Enter your package name (e.g., `com.example.portfolio`)
3. Download `google-services.json`
4. Extract values for your `.env` file:
   - `client[0].api_key[0].current_key` → `FIREBASE_ANDROID_API_KEY`
   - `client[0].client_info.mobilesdk_app_id` → `FIREBASE_ANDROID_APP_ID`

### 5. Configure iOS App (Optional)

1. Click **Add app** → **iOS**
2. Enter your bundle ID (e.g., `com.example.portfolio`)
3. Download `GoogleService-Info.plist`
4. Extract values for your `.env` file:
   - `API_KEY` → `FIREBASE_IOS_API_KEY`
   - `GOOGLE_APP_ID` → `FIREBASE_IOS_APP_ID`
   - `BUNDLE_ID` → `FIREBASE_IOS_BUNDLE_ID`

### 6. Update Your .env File

Edit your `.env` file with the actual values:

```env
# Firebase Project Configuration
FIREBASE_PROJECT_ID=your-actual-project-id
FIREBASE_MESSAGING_SENDER_ID=your-actual-sender-id
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app

# Firebase Web Configuration
FIREBASE_WEB_API_KEY=AIzaSyYourActualWebApiKey
FIREBASE_WEB_APP_ID=1:123456:web:youractualappid
FIREBASE_WEB_MEASUREMENT_ID=G-YOURMEASUREMENTID

# Firebase Android Configuration (if using Android)
FIREBASE_ANDROID_API_KEY=AIzaSyYourActualAndroidApiKey
FIREBASE_ANDROID_APP_ID=1:123456:android:youractualappid

# Firebase iOS Configuration (if using iOS)
FIREBASE_IOS_API_KEY=AIzaSyYourActualIosApiKey
FIREBASE_IOS_APP_ID=1:123456:ios:youractualappid
FIREBASE_IOS_BUNDLE_ID=com.example.your-app
```

## 🔧 Development Setup

### Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# For environment variable support (optional)
flutter pub add flutter_dotenv
```

### Run the Application

```bash
# Run on web
flutter run -d chrome

# Run on mobile (with device connected)
flutter run

# Build for production
flutter build web
```

## 🏗️ How the Template System Works

### Environment Variable Loading

The app uses compile-time environment variables through `String.fromEnvironment()`:

```dart
// In lib/firebase_options.dart
static String _getEnvVar(String key, String placeholder) {
  final envValue = _getSpecificEnvVar(key);
  if (envValue.isNotEmpty) {
    return envValue;  // Use actual environment variable
  }
  return placeholder;  // Use safe placeholder for development
}
```

### Safe Placeholders

When environment variables are not set, the app uses safe placeholder values:
- `YOUR_WEB_API_KEY_HERE` instead of real API keys
- `your-project-id` instead of real project IDs
- `com.example.your-app` instead of real bundle IDs

### Development vs Production

- **Development**: Shows warnings when environment variables are missing
- **Production**: Should fail fast if required environment variables are not set

## 🚀 Deployment

### Web Deployment

For web deployment, set environment variables in your hosting platform:

#### Netlify
1. Go to Site Settings → Environment Variables
2. Add all `FIREBASE_*` variables

#### Vercel
1. Go to Project Settings → Environment Variables
2. Add all `FIREBASE_*` variables

#### Firebase Hosting
```bash
# Set environment variables
firebase functions:config:set firebase.web_api_key="your-key"

# Deploy
firebase deploy
```

### Mobile Deployment

For mobile apps, environment variables are set at build time:

```bash
# Android
flutter build apk --dart-define=FIREBASE_ANDROID_API_KEY=your-key

# iOS
flutter build ios --dart-define=FIREBASE_IOS_API_KEY=your-key
```

## 🔒 Security Best Practices

### ✅ Do's
- Keep your `.env` file private and never commit it
- Use different Firebase projects for development/staging/production
- Regularly rotate your API keys
- Set up Firebase security rules
- Use environment-specific configurations

### ❌ Don'ts
- Never hardcode API keys in source code
- Don't commit `.env` files to version control
- Don't share API keys in chat/email
- Don't use production keys in development

## 🐛 Troubleshooting

### Firebase Not Initializing
1. Check that your `.env` file exists and has correct values
2. Verify environment variables are being loaded
3. Check browser console for Firebase errors

### Environment Variables Not Loading
1. Ensure `.env` file is in the project root
2. Check that variable names match exactly
3. Restart your development server

### Build Errors
1. Make sure all required environment variables are set
2. Check for typos in variable names
3. Verify Firebase configuration is valid

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Setup](https://firebase.flutter.dev/docs/overview)
- [Environment Variables in Flutter](https://docs.flutter.dev/deployment/flavors)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)

## 🆘 Need Help?

If you encounter issues:
1. Check the troubleshooting section above
2. Verify your Firebase project settings
3. Ensure all environment variables are correctly set
4. Check the browser console for error messages
