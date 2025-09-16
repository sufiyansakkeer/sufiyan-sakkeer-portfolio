# Flutter Portfolio Template

A secure, production-ready Flutter portfolio template with Firebase integration. This template uses environment variables to keep sensitive API keys out of source code, making it safe for public repositories.

## 🔒 Security Features

- **No hardcoded API keys** - All sensitive data uses environment variables
- **Template-based configuration** - Safe placeholders for public repositories
- **Secure by default** - Follows security best practices
- **Production ready** - Proper environment separation

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase account
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd flutter-portfolio-template
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env with your Firebase configuration
   # See FIREBASE_SETUP.md for detailed instructions
   ```

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```

## 📁 Project Structure

```
lib/
├── config/
│   ├── firebase_config.dart     # Secure Firebase configuration
│   └── theme.dart              # App theming
├── firebase_options.dart       # Template with placeholders
├── main.dart                   # App entry point
├── screens/                    # UI screens
├── widgets/                    # Reusable widgets
└── utils/                      # Utility functions

web/
├── index.html                  # Secure web configuration
└── ...

.env.example                    # Environment template
FIREBASE_SETUP.md              # Detailed setup guide
```

## 🔧 Configuration

### Environment Variables

This template uses environment variables for all sensitive configuration:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_WEB_API_KEY=your-web-api-key
FIREBASE_WEB_APP_ID=your-web-app-id
# ... more variables
```

### Firebase Setup

1. Create a Firebase project
2. Configure web/mobile apps
3. Copy configuration to `.env` file
4. See `FIREBASE_SETUP.md` for detailed instructions

## 🎨 Customization

### Personal Information

Update your personal information in `lib/utils/constants.dart`:

```dart
class AppConstants {
  static const String name = 'Your Name';
  static const String title = 'Your Title';
  static const String email = 'your.email@example.com';
  // ... more constants
}
```

### Theming

Customize colors and themes in `lib/config/theme.dart`:

```dart
class AppTheme {
  static const Color primaryColorLight = Color(0xFF2563EB);
  static const Color secondaryColorLight = Color(0xFF10B981);
  // ... more theme configuration
}
```

### Content

- Update portfolio projects in the appropriate screen files
- Modify sections in `lib/screens/`
- Add your own assets to `assets/`

## 🚀 Deployment

### Web Deployment

#### Netlify
1. Connect your repository
2. Set environment variables in Site Settings
3. Deploy automatically on push

#### Vercel
1. Import your repository
2. Add environment variables in Project Settings
3. Deploy

#### Firebase Hosting
```bash
firebase init hosting
firebase deploy
```

### Mobile Deployment

#### Android
```bash
flutter build apk --dart-define=FIREBASE_ANDROID_API_KEY=your-key
```

#### iOS
```bash
flutter build ios --dart-define=FIREBASE_IOS_API_KEY=your-key
```

## 🔒 Security Best Practices

### ✅ Implemented Security Features

- Environment variable configuration
- No hardcoded secrets in source code
- Secure template placeholders
- Proper .gitignore patterns
- Development vs production separation

### 🛡️ Additional Recommendations

1. **Use different Firebase projects** for dev/staging/production
2. **Regularly rotate API keys**
3. **Set up Firebase security rules**
4. **Enable Firebase App Check** for production
5. **Monitor Firebase usage** for unusual activity

## 📚 Documentation

- [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md) - Detailed Firebase configuration guide
- [`SECURITY_SETUP.md`](SECURITY_SETUP.md) - Security implementation details
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure no sensitive data is committed
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter issues:

1. Check the [troubleshooting section](FIREBASE_SETUP.md#troubleshooting) in the setup guide
2. Verify your environment configuration
3. Check Firebase console for errors
4. Open an issue with detailed information

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Contributors and users of this template

---

**⚠️ Important**: This template is designed for public repositories. All sensitive configuration has been moved to environment variables. Make sure to properly configure your `.env` file before running the application.
