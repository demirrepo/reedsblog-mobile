import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reedsblog/main_screen.dart';
import 'package:reedsblog/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Tell Flutter to wait until the engine is fully ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wake up Firebase using your specific 47reeds settings
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp()); // Your app starts here
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
