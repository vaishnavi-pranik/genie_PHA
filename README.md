# Genie Health Assistant App

A Flutter health application with AI-powered voice navigation using Google's Gemini API and text-to-speech capabilities.

## 🌟 Features

### 🏥 Health App Pages
- **Call Doctor**: Quick access to call medical professionals
- **Prescriptions**: View and manage medication prescriptions  
- **Family Members**: Manage family member health information
- **User Profile**: Personal health profile and settings

### 🧞‍♂️ AI Genie Assistant
- **Voice Recognition**: Record voice commands using device microphone
- **AI Intent Recognition**: Uses Google Gemini 1.5 Flash Latest for understanding user requests
- **Text-to-Speech**: Genie speaks greetings and navigation confirmations
- **Smart Navigation**: Automatically navigates to requested pages based on voice commands
- **Floating UI**: Elegant floating genie interface at bottom-left of screen

### 🎯 Voice Commands
The genie understands natural language requests like:
- "Call doctor" → Navigates to Call Doctor page
- "Show my prescriptions" → Navigates to Prescriptions page  
- "Family members" → Navigates to Family Members page
- "My profile" → Navigates to User Profile page

## 🚀 Technologies Used

- **Flutter SDK**: Cross-platform mobile app framework
- **Google Gemini API**: AI-powered intent recognition and audio processing
- **flutter_tts**: Text-to-speech functionality
- **record**: Audio recording capabilities
- **permission_handler**: Microphone and storage permissions
- **lottie**: Animated genie character
- **http**: API communication

## 📋 Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio / VS Code
- Google Gemini API key
- Physical device or emulator with microphone support

## 🛠️ Setup Instructions

### 1. Clone the repository
```bash
git clone <repository-url>
cd genie_test_four
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure Gemini API
- Get your Gemini API key from [Google AI Studio](https://aistudio.google.com/)
- Replace `'Gemini_api_key_here'` in `lib/main.dart` with your actual API key:
```dart
static const String _apiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
```

### 4. Add Lottie Animation
- Place your `genie.json` Lottie animation file in the `assets/` directory
- The animation file should contain a genie character animation

### 5. Run the app
```bash
flutter run
```

## 🎮 How to Use

1. **Launch the app** - The health app opens with 4 main pages
2. **Show Genie** - Tap the "Show Genie" button to reveal the floating genie assistant
3. **Voice Interaction**:
   - The genie will greet you: *"Hello! How can I help you today?"*
   - Tap the microphone button to start recording
   - Speak your request (e.g., "Show my prescriptions")
   - The genie processes your voice with Gemini AI
   - Automatically navigates to the requested page
   - Speaks confirmation: *"We are now on the Prescription page..."*

## 🏗️ App Architecture

### Core Components
- **GeminiService**: Handles AI processing for text and audio intent recognition
- **TTSService**: Manages text-to-speech functionality with slower speech rate
- **MainScreen**: Main app interface with floating genie integration
- **Health Pages**: Individual pages for different health functionalities

### AI Processing Flow
1. **Audio Recording** → Device microphone captures voice
2. **Gemini Processing** → Audio sent directly to Gemini 1.5 Flash Latest
3. **Intent Classification** → AI determines user intent (doctor/prescription/family/profile)
4. **Navigation** → App automatically switches to requested page
5. **TTS Feedback** → Genie speaks page-specific confirmation message

## 🔧 Configuration Options

### TTS Settings (in TTSService)
- **Speech Rate**: Currently set to 0.5 (slower pace)
- **Language**: English (en-US)
- **Voice**: Attempts to use female voice if available
- **Volume**: 1.0 (maximum)

### Gemini API Settings
- **Model**: gemini-1.5-flash-latest
- **Temperature**: 0.0 (deterministic responses)
- **Max Tokens**: 10 (concise intent responses)
- **Timeout**: 30 seconds for audio processing

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS (with microphone permissions)
- ⚠️ Web (limited microphone support)
- ⚠️ Desktop (requires microphone setup)

## 🔐 Permissions Required

- **Microphone**: For voice recording
- **Storage**: For temporary audio file storage

## 🐛 Troubleshooting

### Common Issues
- **No voice recognition**: Check microphone permissions
- **Gemini API errors**: Verify API key is correct and has sufficient quota
- **TTS not working**: Ensure device has text-to-speech enabled
- **Lottie animation not loading**: Confirm `genie.json` is in assets folder

### Fallback Behavior
- If Gemini API fails, the app uses keyword matching as fallback
- If no valid intent detected, defaults to Profile page
- Network errors are handled gracefully with user notifications

## 🚧 Future Enhancements

- **Multi-language support** for voice commands and TTS
- **Medical diagnosis conversations** with extended Gemini integration  
- **Health data integration** with device sensors
- **Doctor appointment scheduling** through voice commands
- **Medication reminders** with voice notifications

## 📄 License

This project is a Flutter demonstration app showcasing AI-powered voice navigation in healthcare applications.

## 🤝 Contributing

This is a demonstration project. For educational and development purposes.

---

**Built with ❤️ using Flutter and Google Gemini AI**
