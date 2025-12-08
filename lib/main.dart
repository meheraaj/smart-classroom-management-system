import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scms/nav.dart';
import 'package:scms/screens/student/student_nav.dart';
import 'firebase_options.dart';
import 'screens/teacher/teacher_dashboad.dart';
import 'screens/login.dart';
import 'providers/auth_providers.dart';

// Initialize Firebase
final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 FIX: MaterialApp MUST wrap the entire FutureBuilder content.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Classroom Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define a consistent color scheme for all screens
        primaryColor: const Color(0xFF4285F4),
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 3. The home property uses FutureBuilder to manage initialization state
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // --- Error Check ---
          if (snapshot.hasError) {
            // Must return a Scaffold for proper material design handling
            return const Scaffold(
              body: Center(
                child: Text("Error: Firebase Initialization Failed"),
              ),
            );
          }

          // --- Done Check ---
          if (snapshot.connectionState == ConnectionState.done) {
            // 4. Initialization done, proceed to AuthChecker
            return const AuthChecker();
          }

          // --- Loading State ---
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

// Ensure the AuthChecker handles its loading/error states properly (it does now)
class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    final userAsync = ref.watch(userDataProvider);

    return authStateAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, _) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),

      data: (firebaseUser) {
        // 🔹 Not logged in → Login screen immediately
        if (firebaseUser == null) {
          return const LoginScreen();
        }

        // 🔹 Firestore user still loading → Show loading (to avoid flicker)
        return userAsync.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),

          error: (err, _) => Scaffold(
            body: Center(child: Text("User Error: $err")),
          ),

          data: (user) {
            if (user == null) {
              return const Scaffold(
                body: Center(child: Text("No user data found.")),
              );
            }

            final isStudent = user["utype"] == "student";

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: isStudent ? const StudentNav() : const NavHolder(),
              ),
            );
          },
        );
      },
    );
  }
}

