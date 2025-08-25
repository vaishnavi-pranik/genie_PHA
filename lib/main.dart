import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

  static const String _apiKey = 'AIzaSyB5poSNPJrip37CQ6c-NjH9Zzq-CZE_3D0';
  static Future<String> analyzeTextIntent(String text) async {
    print('🚀 GEMINI-ONLY ANALYSIS STARTING');
    print('🔍 Input text: "$text"');
    // TODO: Implement Gemini API call here
    // For now, fallback to simple keyword matching
    final lower = text.toLowerCase();
    if (lower.contains('doctor') || lower.contains('డాక్టర్') || lower.contains('डॉक्टर')) {
      return 'doctor';
    } else if (lower.contains('prescription') || lower.contains('medicine') || lower.contains('మందు') || lower.contains('दवा')) {
      return 'prescription';
    } else if (lower.contains('family') || lower.contains('కుటుంబ') || lower.contains('परिवार')) {
      return 'family';
    } else {
      return 'profile';
    }
  }
}
//     } else {
//       // If genie is hidden, stop any recording and TTS
//       TTSService.stop();
//       if (_isRecording) {
//         _stopRecording();
//       }
//       if (_isListening) {
//         _stopListening();
//       }
//     }
//   }

//   // Method to update selected index from external sources (like RecordingDialog)
//   void updateSelectedIndex(int index) {
//     print('🔄 UPDATE INDEX CALLED:');
//     print('🔄 Requested index: $index');
//     print('🔄 Current index: $_selectedIndex');
//     print('🔄 Valid range: 0 to ${_pages.length - 1}');
//     print('🔄 Is mounted: $mounted');

//     if (mounted && index >= 0 && index < _pages.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       print('✅ Index updated successfully to: $_selectedIndex');
//       print('✅ Current page: ${_pageTitles[_selectedIndex]}');
//     } else {
//       print(
//         '❌ Index update failed! mounted: $mounted, valid index: ${index >= 0 && index < _pages.length}',
//       );
//     }
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> _startRecording() async {
//     await _requestPermissions();

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final path =
//           '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start(const RecordConfig(), path: path);
//         setState(() {
//           _isRecording = true;
//           _recordingSeconds = 0;
//           _audioPath = path;
//         });

//         _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//           if (mounted) {
//             setState(() {
//               _recordingSeconds++;
//             });
//           }
//         });

//         print('Recording started: $_audioPath');
//       } else {
//         print('Microphone permission not granted');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Microphone permission required')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Recording error: $e')));
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _audioRecorder.stop();
//       _recordingTimer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//       print('✅ Recording saved to: $_audioPath');

//       if (mounted && _audioPath != null) {
//         // Show processing message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('🤖 Processing with Gemini AI...'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         print('🚀 Starting Gemini analysis...');

//         // Send audio to Gemini for intent analysis
//         try {
//           final intent = await GeminiService.analyzeAudioIntent(_audioPath!);
//           print('🎯 Gemini analysis complete! Intent: $intent');

//           // Show what Gemini detected
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   '🤖 Gemini detected: "${intent.toUpperCase()}" - Navigating...',
//                 ),
//                 backgroundColor: Colors.blue,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//           }

//           // Navigate and speak
//           _navigateToPage(intent);
//         } catch (e) {
//           print('❌ Error processing with Gemini: $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('❌ Gemini error: $e. Using default...'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//             _navigateToPage('profile');
//           }
//         }
//       }
//     } catch (e) {
//       print('❌ Error stopping recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Stop recording error: $e')));
//       }
//     }
//   }

//   // --- Speech-to-text logic ---
//   Future<void> _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => print('STT status: $status'),
//       onError: (error) => print('STT error: $error'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       // Prefer Telugu if Genie is visible and user likely wants Telugu
//       String localeId = 'en_IN';
//       // If Genie is visible and user last spoke Telugu, use Telugu
//       // (You can improve this logic as needed)
//       _speech.listen(
//         localeId: localeId,
//         listenMode: stt.ListenMode.confirmation,
//         onResult: (val) async {
//           setState(() {
//             _recognizedText = val.recognizedWords;
//           });
//           if (val.finalResult && _recognizedText.isNotEmpty) {
//             setState(() => _isListening = false);
//             // Analyze intent
//             final intent = await GeminiService.analyzeTextIntent(_recognizedText);
//             _navigateToPage(intent);
//           }
//         },
//       );
//     } else {
//       setState(() => _isListening = false);
//       print('Speech recognition not available');
//     }
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() => _isListening = false);
//   }

//   void _navigateToPage(String intent) {
//     print('🧭 NAVIGATION DEBUG:');
//     print('🧭 Received intent: "$intent"');

//     int targetIndex;
//     switch (intent) {
//       case 'doctor':
//         targetIndex = 0; // Call Doctor page
//         break;
//       case 'prescription':
//         targetIndex = 1; // Prescription page
//         break;
//       case 'family':
//         targetIndex = 2; // Family Members page
//         break;
//       case 'profile':
//       default:
//         targetIndex = 3; // User Profile page
//         break;
//     }

//     print('🧭 Target index: $targetIndex for intent: $intent');

//     // Update the selected index
//     updateSelectedIndex(targetIndex);

//     // Speak the appropriate message for the page
//     String pageMessage = TTSService.getPageMessage(intent);
//     TTSService.speak(pageMessage);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     TTSService.stop();
//     _speech.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_pageTitles[_selectedIndex]),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Column(
//             children: [
//               Expanded(child: _pages[_selectedIndex]),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _openGenieJsonAndRecord,
//                   icon: const Icon(Icons.assistant),
//                   label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Floating Genie at bottom left
//           if (_isGenieVisible)
//             Positioned(
//               bottom: 100,
//               left: 20,
//               child: Container(
//                 width: 120,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.purple.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Genie Animation
//                     SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Lottie.asset(
//                         'assets/genie.json',
//                         repeat: true,
//                         animate: _isRecording, // Only animate when recording
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.star,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Recording status
//                     Text(
//                       _isRecording
//                           ? 'Listening (audio)...'
//                           : _isListening
//                               ? 'Listening (speech)...'
//                               : 'Tap to talk',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     if (_isRecording)
//                       Text(
//                         _formatTime(_recordingSeconds),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     if (_isListening)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Text(
//                           _recognizedText,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                     // Record button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: _isRecording ? _stopRecording : _startRecording,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: _isRecording ? Colors.red : Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               _isRecording ? Icons.stop : Icons.mic,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         GestureDetector(
//                           onTap: _isListening ? _stopListening : _startListening,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: _isListening ? Colors.red : Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               _isListening ? Icons.stop : Icons.record_voice_over,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.phone),
//             label: 'Call Doctor',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt),
//             label: 'Prescriptions',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.family_restroom),
//             label: 'Family',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
// class TTSService {
//   static final FlutterTts _flutterTts = FlutterTts();
//   static bool _isInitialized = false;
//   static String _currentLanguage = "en-IN"; // Default to Indian English

//   static Future<void> _initialize([String? language]) async {
//     if (!_isInitialized || language != null) {
//       // Set language to Indian English or Telugu
//       String selectedLanguage = language ?? _currentLanguage;

//       try {
//         await _flutterTts.setLanguage(selectedLanguage);
//         await _flutterTts.setSpeechRate(0.4); // Slower speech rate for clarity
//         await _flutterTts.setVolume(1.0);
//         await _flutterTts.setPitch(1.0);

//         // Get available voices and select Indian accent voice
//         var voices = await _flutterTts.getVoices;
//         if (voices != null) {
//           Map<String, dynamic>? selectedVoice;

//           if (selectedLanguage == "te-IN") {
//             // Look for Telugu voice
//             selectedVoice = voices.firstWhere(
//               (voice) =>
//                   voice["locale"].toString().toLowerCase().contains("te-in") ||
//                   voice["locale"].toString().toLowerCase().contains("te_in") ||
//                   voice["name"].toString().toLowerCase().contains("telugu"),
//               orElse: () => voices.firstWhere(
//                 (voice) =>
//                     voice["locale"].toString().toLowerCase().contains(
//                       "en-in",
//                     ) ||
//                     voice["locale"].toString().toLowerCase().contains("en_in"),
//                 orElse: () => voices.first,
//               ),
//             );
//           } else {
//             // Look for Indian English voice
//             selectedVoice = voices.firstWhere(
//               (voice) =>
//                   voice["locale"].toString().toLowerCase().contains("en-in") ||
//                   voice["locale"].toString().toLowerCase().contains("en_in") ||
//                   voice["name"].toString().toLowerCase().contains("indian") ||
//                   voice["name"].toString().toLowerCase().contains("india"),
//               orElse: () => voices.firstWhere(
//                 (voice) =>
//                     voice["name"].toString().toLowerCase().contains("female") ||
//                     voice["name"].toString().toLowerCase().contains("woman"),
//                 orElse: () => voices.first,
//               ),
//             );
//           }

//           if (selectedVoice != null) {
//             await _flutterTts.setVoice({
//               "name": selectedVoice["name"],
//               "locale": selectedVoice["locale"],
//             });
//             print(
//               '🗣️ Selected voice: ${selectedVoice["name"]} with locale: ${selectedVoice["locale"]}',
//             );
//           }
//         }

//         _currentLanguage = selectedLanguage;
//         _isInitialized = true;
//         print('🗣️ TTS initialized with language: $selectedLanguage');
//       } catch (e) {
//         print('❌ TTS initialization error: $e');
//         // Fallback to default
//         await _flutterTts.setLanguage("en-IN");
//         _currentLanguage = "en-IN";
//         _isInitialized = true;
//       }
//     }
//   }

//   static Future<void> speak(String text, [String? language]) async {
//     // Detect language if not specified
//     String detectedLanguage = language ?? _detectLanguage(text);

//     print('🗣️ TTS Speaking: "$text" in language: $detectedLanguage');
//     await _initialize(detectedLanguage);

//     // Stop any current speech
//     await _flutterTts.stop();

//     // Speak the text
//     await _flutterTts.speak(text);
//   }

//   // Simple language detection based on script
//   static String _detectLanguage(String text) {
//     // Telugu Unicode range: 0C00-0C7F
//     final teluguRegex = RegExp(r'[\u0C00-\u0C7F]');

//     if (teluguRegex.hasMatch(text)) {
//       return "te-IN"; // Telugu
//     } else {
//       return "en-IN"; // Default to Indian English
//     }
//   }

//   static Future<void> stop() async {
//     await _flutterTts.stop();
//   }

//   // Get appropriate message for each page with bilingual support
//   static String getPageMessage(String intent, [String language = "en-IN"]) {
//     if (language == "te-IN") {
//       // Telugu messages
//       switch (intent) {
//         case 'doctor':
//           return 'మేము ఇప్పుడు కాల్ డాక్టర్ పేజీలో ఉన్నాము. నేను ఇప్పుడు డాక్టర్‌కి కాల్ చేయాలా?';
//         case 'prescription':
//           return 'మేము ఇప్పుడు ప్రిస్క్రిప్షన్ పేజీలో ఉన్నాము. ఇక్కడ మీ మందులు మరియు ప్రిస్క్రిప్షన్‌లు ఉన్నాయి.';
//         case 'family':
//           return 'మేము ఇప్పుడు కుటుంబ సభ్యుల పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ కుటుంబ సభ్యులందరినీ చూడవచ్చు.';
//         case 'profile':
//           return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ వ్యక్తిగత సమాచారాన్ని చూడవచ్చు మరియు సవరించవచ్చు.';
//         default:
//           return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము.';
//       }
//     } else {
//       // English messages with Indian context
//       switch (intent) {
//         case 'doctor':
//           return 'We are now on the Call Doctor page. Shall I call the doctor now?';
//         case 'prescription':
//           return 'We are now on the Prescription page. Here are your medicines and prescriptions.';
//         case 'family':
//           return 'We are now on the Family Members page. Here you can see all your family members.';
//         case 'profile':
//           return 'We are now on your Profile page. Here you can view and edit your personal information.';
//         default:
//           return 'We are now on your Profile page.';
//       }
//     }
//   }

//   static String getGreeting([String language = "en-IN"]) {
//     if (language == "te-IN") {
//       return 'నమస్కారం! నేను మీకు ఎలా సహాయం చేయగలను? మీరు నన్ను డాక్టర్, ప్రిస్క్రిప్షన్‌లు, కుటుంబ సభ్యులు లేదా మీ ప్రొఫైల్‌కు నావిగేట్ చేయమని అడగవచ్చు.';
//     } else {
//       return 'Namaste! How can I help you today? You can ask me to navigate to doctor, prescriptions, family members, or your profile.';
//     }
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   bool _isGenieVisible = false;
//   bool _isRecording = false;
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   int _recordingSeconds = 0;
//   Timer? _recordingTimer;
//   String? _audioPath;

//   final List<Widget> _pages = [
//     const CallDoctorPage(),
//     const PrescriptionPage(),
//     const FamilyMembersPage(),
//     const UserProfilePage(),
//   ];

//   final List<String> _pageTitles = [
//     'Call Doctor',
//     'Prescriptions',
//     'Family Members',
//     'Profile',
//   ];

//   Future<void> _requestPermissions() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   Future<void> _openGenieJsonAndRecord() async {
//     setState(() {
//       _isGenieVisible = !_isGenieVisible;
//     });

//     // If genie becomes visible, speak greeting
//     if (_isGenieVisible) {
//       TTSService.speak(TTSService.getGreeting());
//     } else {
//       // If genie is hidden, stop any recording and TTS
//       TTSService.stop();
//       if (_isRecording) {
//         _stopRecording();
//       }
//     }
//   }

//   // Method to update selected index from external sources (like RecordingDialog)
//   void updateSelectedIndex(int index) {
//     print('🔄 UPDATE INDEX CALLED:');
//     print('🔄 Requested index: $index');
//     print('🔄 Current index: $_selectedIndex');
//     print('🔄 Valid range: 0 to ${_pages.length - 1}');
//     print('🔄 Is mounted: $mounted');

//     if (mounted && index >= 0 && index < _pages.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       print('✅ Index updated successfully to: $_selectedIndex');
//       print('✅ Current page: ${_pageTitles[_selectedIndex]}');
//     } else {
//       print(
//         '❌ Index update failed! mounted: $mounted, valid index: ${index >= 0 && index < _pages.length}',
//       );
//     }
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> _startRecording() async {
//     await _requestPermissions();

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final path =
//           '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start(const RecordConfig(), path: path);
//         setState(() {
//           _isRecording = true;
//           _recordingSeconds = 0;
//           _audioPath = path;
//         });

//         _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//           if (mounted) {
//             setState(() {
//               _recordingSeconds++;
//             });
//           }
//         });

//         print('Recording started: $_audioPath');
//       } else {
//         print('Microphone permission not granted');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Microphone permission required')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Recording error: $e')));
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _audioRecorder.stop();
//       _recordingTimer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//       print('✅ Recording saved to: $_audioPath');

//       if (mounted && _audioPath != null) {
//         // Show processing message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('🤖 Processing with Gemini AI...'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         print('🚀 Starting Gemini analysis...');

//         // Send audio to Gemini for intent analysis
//         try {
//           final intent = await GeminiService.analyzeAudioIntent(_audioPath!);
//           print('🎯 Gemini analysis complete! Intent: $intent');

//           // Show what Gemini detected
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   '🤖 Gemini detected: "${intent.toUpperCase()}" - Navigating...',
//                 ),
//                 backgroundColor: Colors.blue,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//           }

//           // Navigate and speak
//           _navigateToPage(intent);
//         } catch (e) {
//           print('❌ Error processing with Gemini: $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('❌ Gemini error: $e. Using default...'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//             _navigateToPage('profile');
//           }
//         }
//       }
//     } catch (e) {
//       print('❌ Error stopping recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Stop recording error: $e')));
//       }
//     }
//   }

//   void _navigateToPage(String intent) {
//     print('🧭 NAVIGATION DEBUG:');
//     print('🧭 Received intent: "$intent"');

//     int targetIndex;
//     switch (intent) {
//       case 'doctor':
//         targetIndex = 0; // Call Doctor page
//         break;
//       case 'prescription':
//         targetIndex = 1; // Prescription page
//         break;
//       case 'family':
//         targetIndex = 2; // Family Members page
//         break;
//       case 'profile':
//       default:
//         targetIndex = 3; // User Profile page
//         break;
//     }

//     print('🧭 Target index: $targetIndex for intent: $intent');

//     // Update the selected index
//     updateSelectedIndex(targetIndex);

//     // Speak the appropriate message for the page
//     String pageMessage = TTSService.getPageMessage(intent);
//     TTSService.speak(pageMessage);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     TTSService.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_pageTitles[_selectedIndex]),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Column(
//             children: [
//               Expanded(child: _pages[_selectedIndex]),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _openGenieJsonAndRecord,
//                   icon: const Icon(Icons.assistant),
//                   label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Floating Genie at bottom left
//           if (_isGenieVisible)
//             Positioned(
//               bottom: 100,
//               left: 20,
//               child: Container(
//                 width: 120,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: Colors.purple.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Genie Animation
//                     SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Lottie.asset(
//                         'assets/genie.json',
//                         repeat: true,
//                         animate: _isRecording, // Only animate when recording
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.star,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Recording status
//                     Text(
//                       _isRecording ? 'Listening...' : 'Tap to talk',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     if (_isRecording)
//                       Text(
//                         _formatTime(_recordingSeconds),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                     // Record button
//                     GestureDetector(
//                       onTap: _isRecording ? _stopRecording : _startRecording,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: _isRecording ? Colors.red : Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           _isRecording ? Icons.stop : Icons.mic,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.phone),
//             label: 'Call Doctor',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt),
//             label: 'Prescriptions',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.family_restroom),
//             label: 'Family',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// // Call Doctor Page
// class CallDoctorPage extends StatelessWidget {
//   const CallDoctorPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: ElevatedButton(
//           onPressed: () {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('Calling doctor...')));
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
//             textStyle: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           child: const Text('Call Doctor'),
//         ),
//       ),
//     );
//   }
// }

// // Prescription Page
// class PrescriptionPage extends StatelessWidget {
//   const PrescriptionPage({super.key});

//   final List<Map<String, String>> _prescriptions = const [
//     {
//       'id': 'RX001',
//       'doctor': 'Dr. Smith',
//       'date': '2024-01-15',
//       'medication': 'Amoxicillin 500mg',
//       'instructions': 'Take twice daily after meals',
//     },
//     {
//       'id': 'RX002',
//       'doctor': 'Dr. Johnson',
//       'date': '2024-01-10',
//       'medication': 'Ibuprofen 400mg',
//       'instructions': 'Take as needed for pain',
//     },
//     {
//       'id': 'RX003',
//       'doctor': 'Dr. Williams',
//       'date': '2024-01-05',
//       'medication': 'Vitamin D3 1000IU',
//       'instructions': 'Take once daily with breakfast',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _prescriptions.length,
//       itemBuilder: (context, index) {
//         final prescription = _prescriptions[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: const CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.medication, color: Colors.white),
//             ),
//             title: Text(prescription['medication']!),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Doctor: ${prescription['doctor']}'),
//                 Text('Date: ${prescription['date']}'),
//                 Text('Instructions: ${prescription['instructions']}'),
//               ],
//             ),
//             trailing: Text(
//               prescription['id']!,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Family Members Page
// class FamilyMembersPage extends StatelessWidget {
//   const FamilyMembersPage({super.key});

//   final List<Map<String, dynamic>> _familyMembers = const [
//     {'name': 'John Doe', 'age': 45, 'relation': 'Father'},
//     {'name': 'Jane Doe', 'age': 42, 'relation': 'Mother'},
//     {'name': 'Mike Doe', 'age': 18, 'relation': 'Brother'},
//     {'name': 'Sarah Doe', 'age': 16, 'relation': 'Sister'},
//     {'name': 'Robert Doe', 'age': 70, 'relation': 'Grandfather'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _familyMembers.length,
//       itemBuilder: (context, index) {
//         final member = _familyMembers[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.orange,
//               child: Text(
//                 member['name'][0],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             title: Text(member['name']),
//             subtitle: Text('${member['relation']} • Age: ${member['age']}'),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Selected ${member['name']}')),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// // User Profile Page
// class UserProfilePage extends StatelessWidget {
//   const UserProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           // Profile Picture
//           const CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey,
//             child: Icon(Icons.person, size: 80, color: Colors.white),
//           ),
//           const SizedBox(height: 20),
//           // User Info Cards
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.person, color: Colors.blue),
//               title: const Text('Name'),
//               subtitle: const Text('Alex Johnson'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.email, color: Colors.green),
//               title: const Text('Email'),
//               subtitle: const Text('alex.johnson@email.com'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.phone, color: Colors.orange),
//               title: const Text('Phone'),
//               subtitle: const Text('+1 (555) 123-4567'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.language, color: Colors.purple),
//               title: const Text('Language'),
//               subtitle: const Text('English'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.cake, color: Colors.pink),
//               title: const Text('Date of Birth'),
//               subtitle: const Text('January 15, 1990'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // // ignore: depend_on_referenced_packages
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Voice Assistant App',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       home: VoiceAssistantScreen(),
// //     );
// //   }
// // }

// // class VoiceAssistantScreen extends StatefulWidget {
// //   @override
// //   _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
// // }

// // class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
// //   late stt.SpeechToText _speech;
// //   bool _isListening = false;
// //   String _text = '';
// //   String _response = '';
// //   final FlutterTts _flutterTts = FlutterTts();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _speech = stt.SpeechToText();
// //     initTTS();
// //   }

// //   Future<void> initTTS() async {
// //     await _flutterTts.setLanguage("en-IN"); // Indian English
// //     await _flutterTts.setSpeechRate(0.5);
// //     await _flutterTts.setPitch(1.0);
// //     await _flutterTts.setVolume(1.0);
// //     await _flutterTts.awaitSpeakCompletion(true);
// //   }

// //   Future<void> _speak(String text, {bool inTelugu = false}) async {
// //     if (inTelugu) {
// //       await _flutterTts.setLanguage("te-IN"); // Telugu
// //     } else {
// //       await _flutterTts.setLanguage("en-IN"); // Indian English
// //     }
// //     await _flutterTts.speak(text);
// //   }

// //   Future<void> _listen() async {
// //     if (!_isListening) {
// //       bool available = await _speech.initialize();
// //       if (available) {
// //         setState(() => _isListening = true);
// //         _speech.listen(
// //           onResult: (val) => setState(() {
// //             _text = val.recognizedWords;
// //           }),
// //         );
// //       }
// //     } else {
// //       setState(() => _isListening = false);
// //       _speech.stop();
// //       if (_text.isNotEmpty) {
// //         await fetchGeminiResponse(_text);
// //       }
// //     }
// //   }

// //   Future<void> fetchGeminiResponse(String query) async {
// //     final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyB5poSNPJrip37CQ6c-NjH9Zzq-CZE_3D0");
    
// //     final response = await http.post(
// //       url,
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({
// //         "contents": [
// //           {
// //             "parts": [
// //               {"text": query}
// //             ]
// //           }
// //         ]
// //       }),
// //     );

// //     if (response.statusCode == 200) {
// //       final data = json.decode(response.body);
// //       final reply = data['candidates'][0]['content']['parts'][0]['text'];
// //       setState(() {
// //         _response = reply;
// //       });
// //       final bool telugu = _text.contains(RegExp(r'[అ-ఱ]')) || _text.toLowerCase().contains('telugu');
// //       await _speak(reply, inTelugu: telugu);
// //     } else {
// //       setState(() {
// //         _response = 'Failed to get response from Gemini.';
// //       });
// //       await _speak("Sorry, I couldn’t understand.", inTelugu: false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Voice Assistant'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             Text("You said:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             Text(_text, style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 20),
// //             Text("Bot response:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             Text(_response, style: TextStyle(fontSize: 18)),
// //             Spacer(),
// //             FloatingActionButton(
// //               onPressed: _listen,
// //               child: Icon(_isListening ? Icons.mic_off : Icons.mic),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:async';
// import 'package:record/record.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

//   static const String _apiKey = 'AIzaSyB5poSNPJrip37CQ6c-NjH9Zzq-CZE_3D0';

//   // Use ONLY Gemini API for intent recognition - no local keyword matching
//   static Future<String> analyzeTextIntent(String text) async {
//     print('🚀 GEMINI-ONLY ANALYSIS STARTING');
//     print('🔍 Input text: "$text"');

//     try {
//       // Updated API endpoint
//       final url =
//           'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey';
//       print('🌐 API URL: $url');

//       final requestBody = {
//         'contents': [
//           {
//             'parts': [
//               {
//                 'text':
//                     '''Classify this user request into exactly one category. The user may speak in English, Telugu (తెలుగు), or mix of both languages:

// Input: "$text"

// Categories:
// - doctor: for calling doctor, medical help, health issues, appointments (डॉक्टर, వైద्యుడు, కాల్ డాక్టర్, medical help, వైద্య సహాయం)
// - prescription: for medications, prescriptions, medicine, pills, pharmacy (दवा, మందు, ప్రిస్క్రిప్షన్, మెడిసిన్, pharmacy)
// - family: for family members, relatives, family page, parents, children (కుటుంబం, family, కుటుంబ సభ్యులు, relatives, माता-पिता)
// - profile: for user profile, account, settings, personal information (ప్రొఫైల్, account, settings, వ్యక్తిగత సమాచారం)

// Examples:
// - "డాక్టర్‌కి కాల్ చేయండి" or "call doctor" → doctor
// - "మందులు చూపించండి" or "show medicines" → prescription  
// - "కుటుంబ సభ్యులు" or "family members" → family
// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   bool _isGenieVisible = false;
//   bool _isRecording = false;
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   int _recordingSeconds = 0;
//   Timer? _recordingTimer;
//   String? _audioPath;

//   // Speech-to-text
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _recognizedText = '';

//   final List<Widget> _pages = [
//     const CallDoctorPage(),
//     const PrescriptionPage(),
//     const FamilyMembersPage(),
//     const UserProfilePage(),
//   ];

//   final List<String> _pageTitles = [
//     'Call Doctor',
//     'Prescriptions',
//     'Family Members',
//     'Profile',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   Future<void> _requestPermissions() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   Future<void> _openGenieJsonAndRecord() async {
//     setState(() {
//       _isGenieVisible = !_isGenieVisible;
//     });

//     // If genie becomes visible, speak greeting
//     if (_isGenieVisible) {
//       TTSService.speak(TTSService.getGreeting());
//     } else {
//       // If genie is hidden, stop any recording and TTS
//       TTSService.stop();
//       if (_isRecording) {
//         _stopRecording();
//       }
//       if (_isListening) {
//         _stopListening();
//       }
//     }
//   }

//   // Method to update selected index from external sources (like RecordingDialog)
//   void updateSelectedIndex(int index) {
//     print('🔄 UPDATE INDEX CALLED:');
//     print('🔄 Requested index: $index');
//     print('🔄 Current index: $_selectedIndex');
//     print('🔄 Valid range: 0 to ${_pages.length - 1}');
//     print('🔄 Is mounted: $mounted');

//     if (mounted && index >= 0 && index < _pages.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       print('✅ Index updated successfully to: $_selectedIndex');
//       print('✅ Current page: ${_pageTitles[_selectedIndex]}');
//     } else {
//       print(
//         '❌ Index update failed! mounted: $mounted, valid index: ${index >= 0 && index < _pages.length}',
//       );
//     }
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> _startRecording() async {
//     await _requestPermissions();

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final path =
//           '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start(const RecordConfig(), path: path);
//         setState(() {
//           _isRecording = true;
//           _recordingSeconds = 0;
//           _audioPath = path;
//         });

//         _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//           if (mounted) {
//             setState(() {
//               _recordingSeconds++;
//             });
//           }
//         });

//         print('Recording started: $_audioPath');
//       } else {
//         print('Microphone permission not granted');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Microphone permission required')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Recording error: $e')));
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _audioRecorder.stop();
//       _recordingTimer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//       print('✅ Recording saved to: $_audioPath');

//       if (mounted && _audioPath != null) {
//         // Show processing message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('🤖 Processing with Gemini AI...'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         print('🚀 Starting Gemini analysis...');

//         // Send audio to Gemini for intent analysis
//         try {
//           final intent = await GeminiService.analyzeAudioIntent(_audioPath!);
//           print('🎯 Gemini analysis complete! Intent: $intent');

//           // Show what Gemini detected
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   '🤖 Gemini detected: "${intent.toUpperCase()}" - Navigating...',
//                 ),
//                 backgroundColor: Colors.blue,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//           }

//           // Navigate and speak
//           _navigateToPage(intent);
//         } catch (e) {
//           print('❌ Error processing with Gemini: $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('❌ Gemini error: $e. Using default...'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//             _navigateToPage('profile');
//           }
//         }
//       }
//     } catch (e) {
//       print('❌ Error stopping recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Stop recording error: $e')));
//       }
//     }
//   }

//   // --- Speech-to-text logic ---
//   Future<void> _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => print('STT status: $status'),
//       onError: (error) => print('STT error: $error'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       // Prefer Telugu if Genie is visible and user likely wants Telugu
//       String localeId = 'en_IN';
//       // If Genie is visible and user last spoke Telugu, use Telugu
//       // (You can improve this logic as needed)
//       _speech.listen(
//         localeId: localeId,
//         listenMode: stt.ListenMode.confirmation,
//         onResult: (val) async {
//           setState(() {
//             _recognizedText = val.recognizedWords;
//           });
//           if (val.finalResult && _recognizedText.isNotEmpty) {
//             setState(() => _isListening = false);
//             // Analyze intent
//             final intent = await GeminiService.analyzeTextIntent(_recognizedText);
//             _navigateToPage(intent);
//           }
//         },
//       );
//     } else {
//       setState(() => _isListening = false);
//       print('Speech recognition not available');
//     }
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() => _isListening = false);
//   }

//   void _navigateToPage(String intent) {
//     print('🧭 NAVIGATION DEBUG:');
//     print('🧭 Received intent: "$intent"');

//     int targetIndex;
//     switch (intent) {
//       case 'doctor':
//         targetIndex = 0; // Call Doctor page
//         break;
//       case 'prescription':
//         targetIndex = 1; // Prescription page
//         break;
//       case 'family':
//         targetIndex = 2; // Family Members page
//         break;
//       case 'profile':
//       default:
//         targetIndex = 3; // User Profile page
//         break;
//     }

//     print('🧭 Target index: $targetIndex for intent: $intent');

//     // Update the selected index
//     updateSelectedIndex(targetIndex);

//     // Speak the appropriate message for the page
//     String pageMessage = TTSService.getPageMessage(intent);
//     TTSService.speak(pageMessage);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     TTSService.stop();
//     _speech.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_pageTitles[_selectedIndex]),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Column(
//             children: [
//               Expanded(child: _pages[_selectedIndex]),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _openGenieJsonAndRecord,
//                   icon: const Icon(Icons.assistant),
//                   label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Floating Genie at bottom left
//           if (_isGenieVisible)
//             Positioned(
//               bottom: 100,
//               left: 20,
//               child: Container(
//                 width: 120,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.purple.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Genie Animation
//                     SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Lottie.asset(
//                         'assets/genie.json',
//                         repeat: true,
//                         animate: _isRecording, // Only animate when recording
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.star,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Recording status
//                     Text(
//                       _isRecording
//                           ? 'Listening (audio)...'
//                           : _isListening
//                               ? 'Listening (speech)...'
//                               : 'Tap to talk',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     if (_isRecording)
//                       Text(
//                         _formatTime(_recordingSeconds),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     if (_isListening)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Text(
//                           _recognizedText,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                     // Record button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: _isRecording ? _stopRecording : _startRecording,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: _isRecording ? Colors.red : Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               _isRecording ? Icons.stop : Icons.mic,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         GestureDetector(
//                           onTap: _isListening ? _stopListening : _startListening,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: _isListening ? Colors.red : Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               _isListening ? Icons.stop : Icons.record_voice_over,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.phone),
//             label: 'Call Doctor',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt),
//             label: 'Prescriptions',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.family_restroom),
//             label: 'Family',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
// class TTSService {
//   static final FlutterTts _flutterTts = FlutterTts();
//   static bool _isInitialized = false;
//   static String _currentLanguage = "en-IN"; // Default to Indian English

//   static Future<void> _initialize([String? language]) async {
//     if (!_isInitialized || language != null) {
//       // Set language to Indian English or Telugu
//       String selectedLanguage = language ?? _currentLanguage;

//       try {
//         await _flutterTts.setLanguage(selectedLanguage);
//         await _flutterTts.setSpeechRate(0.4); // Slower speech rate for clarity
//         await _flutterTts.setVolume(1.0);
//         await _flutterTts.setPitch(1.0);

//         // Get available voices and select Indian accent voice
//         var voices = await _flutterTts.getVoices;
//         if (voices != null) {
//           Map<String, dynamic>? selectedVoice;

//           if (selectedLanguage == "te-IN") {
//             // Look for Telugu voice
//             selectedVoice = voices.firstWhere(
//               (voice) =>
//                   voice["locale"].toString().toLowerCase().contains("te-in") ||
//                   voice["locale"].toString().toLowerCase().contains("te_in") ||
//                   voice["name"].toString().toLowerCase().contains("telugu"),
//               orElse: () => voices.firstWhere(
//                 (voice) =>
//                     voice["locale"].toString().toLowerCase().contains(
//                       "en-in",
//                     ) ||
//                     voice["locale"].toString().toLowerCase().contains("en_in"),
//                 orElse: () => voices.first,
//               ),
//             );
//           } else {
//             // Look for Indian English voice
//             selectedVoice = voices.firstWhere(
//               (voice) =>
//                   voice["locale"].toString().toLowerCase().contains("en-in") ||
//                   voice["locale"].toString().toLowerCase().contains("en_in") ||
//                   voice["name"].toString().toLowerCase().contains("indian") ||
//                   voice["name"].toString().toLowerCase().contains("india"),
//               orElse: () => voices.firstWhere(
//                 (voice) =>
//                     voice["name"].toString().toLowerCase().contains("female") ||
//                     voice["name"].toString().toLowerCase().contains("woman"),
//                 orElse: () => voices.first,
//               ),
//             );
//           }

//           if (selectedVoice != null) {
//             await _flutterTts.setVoice({
//               "name": selectedVoice["name"],
//               "locale": selectedVoice["locale"],
//             });
//             print(
//               '🗣️ Selected voice: ${selectedVoice["name"]} with locale: ${selectedVoice["locale"]}',
//             );
//           }
//         }

//         _currentLanguage = selectedLanguage;
//         _isInitialized = true;
//         print('🗣️ TTS initialized with language: $selectedLanguage');
//       } catch (e) {
//         print('❌ TTS initialization error: $e');
//         // Fallback to default
//         await _flutterTts.setLanguage("en-IN");
//         _currentLanguage = "en-IN";
//         _isInitialized = true;
//       }
//     }
//   }

//   static Future<void> speak(String text, [String? language]) async {
//     // Detect language if not specified
//     String detectedLanguage = language ?? _detectLanguage(text);

//     print('🗣️ TTS Speaking: "$text" in language: $detectedLanguage');
//     await _initialize(detectedLanguage);

//     // Stop any current speech
//     await _flutterTts.stop();

//     // Speak the text
//     await _flutterTts.speak(text);
//   }

//   // Simple language detection based on script
//   static String _detectLanguage(String text) {
//     // Telugu Unicode range: 0C00-0C7F
//     final teluguRegex = RegExp(r'[\u0C00-\u0C7F]');

//     if (teluguRegex.hasMatch(text)) {
//       return "te-IN"; // Telugu
//     } else {
//       return "en-IN"; // Default to Indian English
//     }
//   }

//   static Future<void> stop() async {
//     await _flutterTts.stop();
//   }

//   // Get appropriate message for each page with bilingual support
//   static String getPageMessage(String intent, [String language = "en-IN"]) {
//     if (language == "te-IN") {
//       // Telugu messages
//       switch (intent) {
//         case 'doctor':
//           return 'మేము ఇప్పుడు కాల్ డాక్టర్ పేజీలో ఉన్నాము. నేను ఇప్పుడు డాక్టర్‌కి కాల్ చేయాలా?';
//         case 'prescription':
//           return 'మేము ఇప్పుడు ప్రిస్క్రిప్షన్ పేజీలో ఉన్నాము. ఇక్కడ మీ మందులు మరియు ప్రిస్క్రిప్షన్‌లు ఉన్నాయి.';
//         case 'family':
//           return 'మేము ఇప్పుడు కుటుంబ సభ్యుల పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ కుటుంబ సభ్యులందరినీ చూడవచ్చు.';
//         case 'profile':
//           return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ వ్యక్తిగత సమాచారాన్ని చూడవచ్చు మరియు సవరించవచ్చు.';
//         default:
//           return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము.';
//       }
//     } else {
//       // English messages with Indian context
//       switch (intent) {
//         case 'doctor':
//           return 'We are now on the Call Doctor page. Shall I call the doctor now?';
//         case 'prescription':
//           return 'We are now on the Prescription page. Here are your medicines and prescriptions.';
//         case 'family':
//           return 'We are now on the Family Members page. Here you can see all your family members.';
//         case 'profile':
//           return 'We are now on your Profile page. Here you can view and edit your personal information.';
//         default:
//           return 'We are now on your Profile page.';
//       }
//     }
//   }

//   static String getGreeting([String language = "en-IN"]) {
//     if (language == "te-IN") {
//       return 'నమస్కారం! నేను మీకు ఎలా సహాయం చేయగలను? మీరు నన్ను డాక్టర్, ప్రిస్క్రిప్షన్‌లు, కుటుంబ సభ్యులు లేదా మీ ప్రొఫైల్‌కు నావిగేట్ చేయమని అడగవచ్చు.';
//     } else {
//       return 'Namaste! How can I help you today? You can ask me to navigate to doctor, prescriptions, family members, or your profile.';
//     }
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   bool _isGenieVisible = false;
//   bool _isRecording = false;
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   int _recordingSeconds = 0;
//   Timer? _recordingTimer;
//   String? _audioPath;

//   final List<Widget> _pages = [
//     const CallDoctorPage(),
//     const PrescriptionPage(),
//     const FamilyMembersPage(),
//     const UserProfilePage(),
//   ];

//   final List<String> _pageTitles = [
//     'Call Doctor',
//     'Prescriptions',
//     'Family Members',
//     'Profile',
//   ];

//   Future<void> _requestPermissions() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   Future<void> _openGenieJsonAndRecord() async {
//     setState(() {
//       _isGenieVisible = !_isGenieVisible;
//     });

//     // If genie becomes visible, speak greeting
//     if (_isGenieVisible) {
//       TTSService.speak(TTSService.getGreeting());
//     } else {
//       // If genie is hidden, stop any recording and TTS
//       TTSService.stop();
//       if (_isRecording) {
//         _stopRecording();
//       }
//     }
//   }

//   // Method to update selected index from external sources (like RecordingDialog)
//   void updateSelectedIndex(int index) {
//     print('🔄 UPDATE INDEX CALLED:');
//     print('🔄 Requested index: $index');
//     print('🔄 Current index: $_selectedIndex');
//     print('🔄 Valid range: 0 to ${_pages.length - 1}');
//     print('🔄 Is mounted: $mounted');

//     if (mounted && index >= 0 && index < _pages.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       print('✅ Index updated successfully to: $_selectedIndex');
//       print('✅ Current page: ${_pageTitles[_selectedIndex]}');
//     } else {
//       print(
//         '❌ Index update failed! mounted: $mounted, valid index: ${index >= 0 && index < _pages.length}',
//       );
//     }
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> _startRecording() async {
//     await _requestPermissions();

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final path =
//           '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start(const RecordConfig(), path: path);
//         setState(() {
//           _isRecording = true;
//           _recordingSeconds = 0;
//           _audioPath = path;
//         });

//         _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//           if (mounted) {
//             setState(() {
//               _recordingSeconds++;
//             });
//           }
//         });

//         print('Recording started: $_audioPath');
//       } else {
//         print('Microphone permission not granted');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Microphone permission required')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Recording error: $e')));
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _audioRecorder.stop();
//       _recordingTimer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//       print('✅ Recording saved to: $_audioPath');

//       if (mounted && _audioPath != null) {
//         // Show processing message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('🤖 Processing with Gemini AI...'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         print('🚀 Starting Gemini analysis...');

//         // Send audio to Gemini for intent analysis
//         try {
//           final intent = await GeminiService.analyzeAudioIntent(_audioPath!);
//           print('🎯 Gemini analysis complete! Intent: $intent');

//           // Show what Gemini detected
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   '🤖 Gemini detected: "${intent.toUpperCase()}" - Navigating...',
//                 ),
//                 backgroundColor: Colors.blue,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//           }

//           // Navigate and speak
//           _navigateToPage(intent);
//         } catch (e) {
//           print('❌ Error processing with Gemini: $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('❌ Gemini error: $e. Using default...'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//             _navigateToPage('profile');
//           }
//         }
//       }
//     } catch (e) {
//       print('❌ Error stopping recording: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Stop recording error: $e')));
//       }
//     }
//   }

//   void _navigateToPage(String intent) {
//     print('🧭 NAVIGATION DEBUG:');
//     print('🧭 Received intent: "$intent"');

//     int targetIndex;
//     switch (intent) {
//       case 'doctor':
//         targetIndex = 0; // Call Doctor page
//         break;
//       case 'prescription':
//         targetIndex = 1; // Prescription page
//         break;
//       case 'family':
//         targetIndex = 2; // Family Members page
//         break;
//       case 'profile':
//       default:
//         targetIndex = 3; // User Profile page
//         break;
//     }

//     print('🧭 Target index: $targetIndex for intent: $intent');

//     // Update the selected index
//     updateSelectedIndex(targetIndex);

//     // Speak the appropriate message for the page
//     String pageMessage = TTSService.getPageMessage(intent);
//     TTSService.speak(pageMessage);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     TTSService.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_pageTitles[_selectedIndex]),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Column(
//             children: [
//               Expanded(child: _pages[_selectedIndex]),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _openGenieJsonAndRecord,
//                   icon: const Icon(Icons.assistant),
//                   label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Floating Genie at bottom left
//           if (_isGenieVisible)
//             Positioned(
//               bottom: 100,
//               left: 20,
//               child: Container(
//                 width: 120,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: Colors.purple.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Genie Animation
//                     SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Lottie.asset(
//                         'assets/genie.json',
//                         repeat: true,
//                         animate: _isRecording, // Only animate when recording
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.star,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Recording status
//                     Text(
//                       _isRecording ? 'Listening...' : 'Tap to talk',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     if (_isRecording)
//                       Text(
//                         _formatTime(_recordingSeconds),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                     // Record button
//                     GestureDetector(
//                       onTap: _isRecording ? _stopRecording : _startRecording,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: _isRecording ? Colors.red : Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           _isRecording ? Icons.stop : Icons.mic,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.phone),
//             label: 'Call Doctor',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt),
//             label: 'Prescriptions',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.family_restroom),
//             label: 'Family',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// // Call Doctor Page
// class CallDoctorPage extends StatelessWidget {
//   const CallDoctorPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: ElevatedButton(
//           onPressed: () {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('Calling doctor...')));
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
//             textStyle: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           child: const Text('Call Doctor'),
//         ),
//       ),
//     );
//   }
// }

// // Prescription Page
// class PrescriptionPage extends StatelessWidget {
//   const PrescriptionPage({super.key});

//   final List<Map<String, String>> _prescriptions = const [
//     {
//       'id': 'RX001',
//       'doctor': 'Dr. Smith',
//       'date': '2024-01-15',
//       'medication': 'Amoxicillin 500mg',
//       'instructions': 'Take twice daily after meals',
//     },
//     {
//       'id': 'RX002',
//       'doctor': 'Dr. Johnson',
//       'date': '2024-01-10',
//       'medication': 'Ibuprofen 400mg',
//       'instructions': 'Take as needed for pain',
//     },
//     {
//       'id': 'RX003',
//       'doctor': 'Dr. Williams',
//       'date': '2024-01-05',
//       'medication': 'Vitamin D3 1000IU',
//       'instructions': 'Take once daily with breakfast',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _prescriptions.length,
//       itemBuilder: (context, index) {
//         final prescription = _prescriptions[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: const CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.medication, color: Colors.white),
//             ),
//             title: Text(prescription['medication']!),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Doctor: ${prescription['doctor']}'),
//                 Text('Date: ${prescription['date']}'),
//                 Text('Instructions: ${prescription['instructions']}'),
//               ],
//             ),
//             trailing: Text(
//               prescription['id']!,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Family Members Page
// class FamilyMembersPage extends StatelessWidget {
//   const FamilyMembersPage({super.key});

//   final List<Map<String, dynamic>> _familyMembers = const [
//     {'name': 'John Doe', 'age': 45, 'relation': 'Father'},
//     {'name': 'Jane Doe', 'age': 42, 'relation': 'Mother'},
//     {'name': 'Mike Doe', 'age': 18, 'relation': 'Brother'},
//     {'name': 'Sarah Doe', 'age': 16, 'relation': 'Sister'},
//     {'name': 'Robert Doe', 'age': 70, 'relation': 'Grandfather'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _familyMembers.length,
//       itemBuilder: (context, index) {
//         final member = _familyMembers[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.orange,
//               child: Text(
//                 member['name'][0],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             title: Text(member['name']),
//             subtitle: Text('${member['relation']} • Age: ${member['age']}'),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Selected ${member['name']}')),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// // User Profile Page
// class UserProfilePage extends StatelessWidget {
//   const UserProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           // Profile Picture
//           const CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.grey,
//             child: Icon(Icons.person, size: 80, color: Colors.white),
//           ),
//           const SizedBox(height: 20),
//           // User Info Cards
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.person, color: Colors.blue),
//               title: const Text('Name'),
//               subtitle: const Text('Alex Johnson'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.email, color: Colors.green),
//               title: const Text('Email'),
//               subtitle: const Text('alex.johnson@email.com'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.phone, color: Colors.orange),
//               title: const Text('Phone'),
//               subtitle: const Text('+1 (555) 123-4567'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.language, color: Colors.purple),
//               title: const Text('Language'),
//               subtitle: const Text('English'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.cake, color: Colors.pink),
//               title: const Text('Date of Birth'),
//               subtitle: const Text('January 15, 1990'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // // ignore: depend_on_referenced_packages
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Voice Assistant App',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       home: VoiceAssistantScreen(),
// //     );
// //   }
// // }

// // class VoiceAssistantScreen extends StatefulWidget {
// //   @override
// //   _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
// // }

// // class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
// //   late stt.SpeechToText _speech;
// //   bool _isListening = false;
// //   String _text = '';
// //   String _response = '';
// //   final FlutterTts _flutterTts = FlutterTts();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _speech = stt.SpeechToText();
// //     initTTS();
// //   }

// //   Future<void> initTTS() async {
// //     await _flutterTts.setLanguage("en-IN"); // Indian English
// //     await _flutterTts.setSpeechRate(0.5);
// //     await _flutterTts.setPitch(1.0);
// //     await _flutterTts.setVolume(1.0);
// //     await _flutterTts.awaitSpeakCompletion(true);
// //   }

// //   Future<void> _speak(String text, {bool inTelugu = false}) async {
// //     if (inTelugu) {
// //       await _flutterTts.setLanguage("te-IN"); // Telugu
// //     } else {
// //       await _flutterTts.setLanguage("en-IN"); // Indian English
// //     }
// //     await _flutterTts.speak(text);
// //   }

// //   Future<void> _listen() async {
// //     if (!_isListening) {
// //       bool available = await _speech.initialize();
// //       if (available) {
// //         setState(() => _isListening = true);
// //         _speech.listen(
// //           onResult: (val) => setState(() {
// //             _text = val.recognizedWords;
// //           }),
// //         );
// //       }
// //     } else {
// //       setState(() => _isListening = false);
// //       _speech.stop();
// //       if (_text.isNotEmpty) {
// //         await fetchGeminiResponse(_text);
// //       }
// //     }
// //   }

// //   Future<void> fetchGeminiResponse(String query) async {
// //     final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyB5poSNPJrip37CQ6c-NjH9Zzq-CZE_3D0");
    
// //     final response = await http.post(
// //       url,
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({
// //         "contents": [
// //           {
// //             "parts": [
// //               {"text": query}
// //             ]
// //           }
// //         ]
// //       }),
// //     );

// //     if (response.statusCode == 200) {
// //       final data = json.decode(response.body);
// //       final reply = data['candidates'][0]['content']['parts'][0]['text'];
// //       setState(() {
// //         _response = reply;
// //       });
// //       final bool telugu = _text.contains(RegExp(r'[అ-ఱ]')) || _text.toLowerCase().contains('telugu');
// //       await _speak(reply, inTelugu: telugu);
// //     } else {
// //       setState(() {
// //         _response = 'Failed to get response from Gemini.';
// //       });
// //       await _speak("Sorry, I couldn’t understand.", inTelugu: false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Voice Assistant'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             Text("You said:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             Text(_text, style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 20),
// //             Text("Bot response:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             Text(_response, style: TextStyle(fontSize: 18)),
// //             Spacer(),
// //             FloatingActionButton(
// //               onPressed: _listen,
// //               child: Icon(_isListening ? Icons.mic_off : Icons.mic),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GeminiService {
  static const String _apiKey = 'AIzaSyB5poSNPJrip37CQ6c-NjH9Zzq-CZE_3D0';

  // Gemini API for intent recognition
  static Future<String> analyzeTextIntent(String text) async {
    print('🚀 GEMINI-ONLY ANALYSIS STARTING');
    print('🔍 Input text: "$text"');
    // TODO: Implement Gemini API call here
    // For now, fallback to simple keyword matching
    final lower = text.toLowerCase();
    if (lower.contains('doctor') || lower.contains('డాక్టర్') || lower.contains('डॉक्टर')) {
      return 'doctor';
    } else if (lower.contains('prescription') || lower.contains('medicine') || lower.contains('మందు') || lower.contains('दवा')) {
      return 'prescription';
    } else if (lower.contains('family') || lower.contains('కుటుంబ') || lower.contains('परिवार')) {
      return 'family';
    } else {
// ...existing code...
    print('🧭 Target index: $targetIndex for intent: $intent');

    // Update the selected index
    updateSelectedIndex(targetIndex);

    // Speak the appropriate message for the page
    String pageMessage = TTSService.getPageMessage(intent);
    TTSService.speak(pageMessage);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    TTSService.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              Expanded(child: _pages[_selectedIndex]),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openGenieJsonAndRecord,
                  icon: const Icon(Icons.assistant),
                  label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          // Floating Genie at bottom left
          if (_isGenieVisible)
            Positioned(
              bottom: 100,
              left: 20,
              child: Container(
                width: 120,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Genie Animation
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Lottie.asset(
                        'assets/genie.json',
                        repeat: true,
                        animate: _isRecording, // Only animate when recording
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Recording status
                    Text(
                      _isRecording
                          ? 'Listening (audio)...'
                          : _isListening
                              ? 'Listening (speech)...'
                              : 'Tap to talk',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isRecording)
                      Text(
                        _formatTime(_recordingSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    if (_isListening)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          _recognizedText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Record button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isRecording ? _stopRecording : _startRecording,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _isRecording ? Colors.red : Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _isListening ? _stopListening : _startListening,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _isListening ? Colors.red : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isListening ? Icons.stop : Icons.record_voice_over,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Call Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Family',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static String _currentLanguage = "en-IN"; // Default to Indian English

  static Future<void> _initialize([String? language]) async {
    if (!_isInitialized || language != null) {
      // Set language to Indian English or Telugu
      String selectedLanguage = language ?? _currentLanguage;

      try {
        await _flutterTts.setLanguage(selectedLanguage);
        await _flutterTts.setSpeechRate(0.4); // Slower speech rate for clarity
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);

        // Get available voices and select Indian accent voice
        var voices = await _flutterTts.getVoices;
        if (voices != null) {
          Map<String, dynamic>? selectedVoice;

          if (selectedLanguage == "te-IN") {
            // Look for Telugu voice
            selectedVoice = voices.firstWhere(
              (voice) =>
                  voice["locale"].toString().toLowerCase().contains("te-in") ||
                  voice["locale"].toString().toLowerCase().contains("te_in") ||
                  voice["name"].toString().toLowerCase().contains("telugu"),
              orElse: () => voices.firstWhere(
                (voice) =>
                    voice["locale"].toString().toLowerCase().contains(
                      "en-in",
                    ) ||
                    voice["locale"].toString().toLowerCase().contains("en_in"),
                orElse: () => voices.first,
              ),
            );
          } else {
            // Look for Indian English voice
            selectedVoice = voices.firstWhere(
              (voice) =>
                  voice["locale"].toString().toLowerCase().contains("en-in") ||
                  voice["locale"].toString().toLowerCase().contains("en_in") ||
                  voice["name"].toString().toLowerCase().contains("indian") ||
                  voice["name"].toString().toLowerCase().contains("india"),
              orElse: () => voices.firstWhere(
                (voice) =>
                    voice["name"].toString().toLowerCase().contains("female") ||
                    voice["name"].toString().toLowerCase().contains("woman"),
                orElse: () => voices.first,
              ),
            );
          }

          if (selectedVoice != null) {
            await _flutterTts.setVoice({
              "name": selectedVoice["name"],
              "locale": selectedVoice["locale"],
            });
            print(
              '🗣️ Selected voice: ${selectedVoice["name"]} with locale: ${selectedVoice["locale"]}',
            );
          }
        }

        _currentLanguage = selectedLanguage;
        _isInitialized = true;
        print('🗣️ TTS initialized with language: $selectedLanguage');
      } catch (e) {
        print('❌ TTS initialization error: $e');
        // Fallback to default
        await _flutterTts.setLanguage("en-IN");
        _currentLanguage = "en-IN";
        _isInitialized = true;
      }
    }
  }

  static Future<void> speak(String text, [String? language]) async {
    // Detect language if not specified
    String detectedLanguage = language ?? _detectLanguage(text);

    print('🗣️ TTS Speaking: "$text" in language: $detectedLanguage');
    await _initialize(detectedLanguage);

    // Stop any current speech
    await _flutterTts.stop();

    // Speak the text
    await _flutterTts.speak(text);
  }

  // Simple language detection based on script
  static String _detectLanguage(String text) {
    // Telugu Unicode range: 0C00-0C7F
    final teluguRegex = RegExp(r'[\u0C00-\u0C7F]');

    if (teluguRegex.hasMatch(text)) {
      return "te-IN"; // Telugu
    } else {
      return "en-IN"; // Default to Indian English
    }
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Get appropriate message for each page with bilingual support
  static String getPageMessage(String intent, [String language = "en-IN"]) {
    if (language == "te-IN") {
      // Telugu messages
      switch (intent) {
        case 'doctor':
          return 'మేము ఇప్పుడు కాల్ డాక్టర్ పేజీలో ఉన్నాము. నేను ఇప్పుడు డాక్టర్‌కి కాల్ చేయాలా?';
        case 'prescription':
          return 'మేము ఇప్పుడు ప్రిస్క్రిప్షన్ పేజీలో ఉన్నాము. ఇక్కడ మీ మందులు మరియు ప్రిస్క్రిప్షన్‌లు ఉన్నాయి.';
        case 'family':
          return 'మేము ఇప్పుడు కుటుంబ సభ్యుల పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ కుటుంబ సభ్యులందరినీ చూడవచ్చు.';
        case 'profile':
          return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము. ఇక్కడ మీరు మీ వ్యక్తిగత సమాచారాన్ని చూడవచ్చు మరియు సవరించవచ్చు.';
        default:
          return 'మేము ఇప్పుడు మీ ప్రొఫైల్ పేజీలో ఉన్నాము.';
      }
    } else {
      // English messages with Indian context
      switch (intent) {
        case 'doctor':
          return 'We are now on the Call Doctor page. Shall I call the doctor now?';
        case 'prescription':
          return 'We are now on the Prescription page. Here are your medicines and prescriptions.';
        case 'family':
          return 'We are now on the Family Members page. Here you can see all your family members.';
        case 'profile':
          return 'We are now on your Profile page. Here you can view and edit your personal information.';
        default:
          return 'We are now on your Profile page.';
      }
    }
  }

  static String getGreeting([String language = "en-IN"]) {
    if (language == "te-IN") {
      return 'నమస్కారం! నేను మీకు ఎలా సహాయం చేయగలను? మీరు నన్ను డాక్టర్, ప్రిస్క్రిప్షన్‌లు, కుటుంబ సభ్యులు లేదా మీ ప్రొఫైల్‌కు నావిగేట్ చేయమని అడగవచ్చు.';
    } else {
      return 'Namaste! How can I help you today? You can ask me to navigate to doctor, prescriptions, family members, or your profile.';
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isGenieVisible = false;
  bool _isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String? _audioPath;

  final List<Widget> _pages = [
    const CallDoctorPage(),
    const PrescriptionPage(),
    const FamilyMembersPage(),
    const UserProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Call Doctor',
    'Prescriptions',
    'Family Members',
    'Profile',
  ];

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _openGenieJsonAndRecord() async {
    setState(() {
      _isGenieVisible = !_isGenieVisible;
    });

    // If genie becomes visible, speak greeting
    if (_isGenieVisible) {
      TTSService.speak(TTSService.getGreeting());
    } else {
      // If genie is hidden, stop any recording and TTS
      TTSService.stop();
      if (_isRecording) {
        _stopRecording();
      }
    }
  }

  // Method to update selected index from external sources (like RecordingDialog)
  void updateSelectedIndex(int index) {
    print('🔄 UPDATE INDEX CALLED:');
    print('🔄 Requested index: $index');
    print('🔄 Current index: $_selectedIndex');
    print('🔄 Valid range: 0 to ${_pages.length - 1}');
    print('🔄 Is mounted: $mounted');

    if (mounted && index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
      print('✅ Index updated successfully to: $_selectedIndex');
      print('✅ Current page: ${_pageTitles[_selectedIndex]}');
    } else {
      print(
        '❌ Index update failed! mounted: $mounted, valid index: ${index >= 0 && index < _pages.length}',
      );
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _startRecording() async {
    await _requestPermissions();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _recordingSeconds = 0;
          _audioPath = path;
        });

        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordingSeconds++;
            });
          }
        });

        print('Recording started: $_audioPath');
      } else {
        print('Microphone permission not granted');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission required')),
          );
        }
      }
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Recording error: $e')));
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _recordingTimer?.cancel();
      setState(() {
        _isRecording = false;
      });
      print('✅ Recording saved to: $_audioPath');

      if (mounted && _audioPath != null) {
        // Show processing message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🤖 Processing with Gemini AI...'),
            duration: Duration(seconds: 3),
          ),
        );

        print('🚀 Starting Gemini analysis...');

        // Send audio to Gemini for intent analysis
        try {
          final intent = await GeminiService.analyzeAudioIntent(_audioPath!);
          print('🎯 Gemini analysis complete! Intent: $intent');

          // Show what Gemini detected
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '🤖 Gemini detected: "${intent.toUpperCase()}" - Navigating...',
                ),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // Navigate and speak
          _navigateToPage(intent);
        } catch (e) {
          print('❌ Error processing with Gemini: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Gemini error: $e. Using default...'),
                backgroundColor: Colors.orange,
              ),
            );
            _navigateToPage('profile');
          }
        }
      }
    } catch (e) {
      print('❌ Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Stop recording error: $e')));
      }
    }
  }

  void _navigateToPage(String intent) {
    print('🧭 NAVIGATION DEBUG:');
    print('🧭 Received intent: "$intent"');

    int targetIndex;
    switch (intent) {
      case 'doctor':
        targetIndex = 0; // Call Doctor page
        break;
      case 'prescription':
        targetIndex = 1; // Prescription page
        break;
      case 'family':
        targetIndex = 2; // Family Members page
        break;
      case 'profile':
      default:
        targetIndex = 3; // User Profile page
        break;
    }

    print('🧭 Target index: $targetIndex for intent: $intent');

    // Update the selected index
    updateSelectedIndex(targetIndex);

    // Speak the appropriate message for the page
    String pageMessage = TTSService.getPageMessage(intent);
    TTSService.speak(pageMessage);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎯 Navigated to ${intent.toUpperCase()} page based on your request!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    TTSService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              Expanded(child: _pages[_selectedIndex]),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openGenieJsonAndRecord,
                  icon: const Icon(Icons.assistant),
                  label: Text(_isGenieVisible ? 'Hide Genie' : 'Show Genie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          // Floating Genie at bottom left
          if (_isGenieVisible)
            Positioned(
              bottom: 100,
              left: 20,
              child: Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Genie Animation
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Lottie.asset(
                        'assets/genie.json',
                        repeat: true,
                        animate: _isRecording, // Only animate when recording
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Recording status
                    Text(
                      _isRecording ? 'Listening...' : 'Tap to talk',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isRecording)
                      Text(
                        _formatTime(_recordingSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Record button
                    GestureDetector(
                      onTap: _isRecording ? _stopRecording : _startRecording,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _isRecording ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Call Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Family',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Call Doctor Page
class CallDoctorPage extends StatelessWidget {
  const CallDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Calling doctor...')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Call Doctor'),
        ),
      ),
    );
  }
}

// Prescription Page
class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  final List<Map<String, String>> _prescriptions = const [
    {
      'id': 'RX001',
      'doctor': 'Dr. Smith',
      'date': '2024-01-15',
      'medication': 'Amoxicillin 500mg',
      'instructions': 'Take twice daily after meals',
    },
    {
      'id': 'RX002',
      'doctor': 'Dr. Johnson',
      'date': '2024-01-10',
      'medication': 'Ibuprofen 400mg',
      'instructions': 'Take as needed for pain',
    },
    {
      'id': 'RX003',
      'doctor': 'Dr. Williams',
      'date': '2024-01-05',
      'medication': 'Vitamin D3 1000IU',
      'instructions': 'Take once daily with breakfast',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final prescription = _prescriptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.medication, color: Colors.white),
            ),
            title: Text(prescription['medication']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor: ${prescription['doctor']}'),
                Text('Date: ${prescription['date']}'),
                Text('Instructions: ${prescription['instructions']}'),
              ],
            ),
            trailing: Text(
              prescription['id']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

// Family Members Page
class FamilyMembersPage extends StatelessWidget {
  const FamilyMembersPage({super.key});

  final List<Map<String, dynamic>> _familyMembers = const [
    {'name': 'John Doe', 'age': 45, 'relation': 'Father'},
    {'name': 'Jane Doe', 'age': 42, 'relation': 'Mother'},
    {'name': 'Mike Doe', 'age': 18, 'relation': 'Brother'},
    {'name': 'Sarah Doe', 'age': 16, 'relation': 'Sister'},
    {'name': 'Robert Doe', 'age': 70, 'relation': 'Grandfather'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _familyMembers.length,
      itemBuilder: (context, index) {
        final member = _familyMembers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                member['name'][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(member['name']),
            subtitle: Text('${member['relation']} • Age: ${member['age']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected ${member['name']}')),
              );
            },
          ),
        );
      },
    );
  }
}

// User Profile Page
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Picture
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 20),
          // User Info Cards
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Name'),
              subtitle: const Text('Alex Johnson'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text('Email'),
              subtitle: const Text('alex.johnson@email.com'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.orange),
              title: const Text('Phone'),
              subtitle: const Text('+1 (555) 123-4567'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.purple),
              title: const Text('Language'),
              subtitle: const Text('English'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cake, color: Colors.pink),
              title: const Text('Date of Birth'),
              subtitle: const Text('January 15, 1990'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
