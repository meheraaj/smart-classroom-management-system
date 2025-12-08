import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';

/// ----------------------------------------------------------------
/// SECONDARY FIREBASE APP → Allows admin to create users without
/// getting logged out from the main FirebaseAuth session.
///
/// FirebaseAuth.createUserWithEmailAndPassword ALWAYS signs in as
/// the new user. This fixes that problem completely.
/// ----------------------------------------------------------------
class AdminFirebaseAuth {
  static FirebaseApp? _secondaryApp;

  static Future<FirebaseApp> get secondaryApp async {
    if (_secondaryApp != null) return _secondaryApp!;

    _secondaryApp = await Firebase.initializeApp(
      name: 'adminApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return _secondaryApp!;
  }

  static Future<UserCredential> adminCreateUser(
      String email, String password) async {
    final app = await secondaryApp;
    final auth = FirebaseAuth.instanceFor(app: app);
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

/// ----------------------------------------------------------------
/// ADD USER SCREEN
/// ----------------------------------------------------------------
class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _idController = TextEditingController();
  final _deptController = TextEditingController();

  String _userType = "student"; // student / teacher / admin
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _idController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final pass = _passController.text.trim();
      final id = _idController.text.trim();
      final dept = _deptController.text.trim();

      // =============================
      // CREATE USER USING SECONDARY AUTH
      // =============================
      final cred = await AdminFirebaseAuth.adminCreateUser(email, pass);
      final uid = cred.user!.uid;

      // Save user info to Firestore
      await FirebaseFirestore.instance.collection("user").doc(uid).set({
        "name": name,
        "email": email,
        "id": id,
        "dept": dept,
        "utype": _userType, // student / teacher / admin
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User created successfully.")),
      );

      // Reset form
      _nameController.clear();
      _emailController.clear();
      _passController.clear();
      _idController.clear();
      _deptController.clear();

      setState(() => _userType = "student");

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ----------------------------------------------------------------
  // UI
  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New User"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "User Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Enter name" : null,
                      ),
                      const SizedBox(height: 14),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter email";
                          if (!v.contains("@")) return "Invalid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password (min 6 chars)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v != null && v.length >= 6
                            ? null
                            : "Password too short",
                      ),
                      const SizedBox(height: 14),

                      // User ID
                      TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: "User ID (e.g., C233267)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Enter user ID" : null,
                      ),
                      const SizedBox(height: 14),

                      // Department
                      TextFormField(
                        controller: _deptController,
                        decoration: const InputDecoration(
                          labelText: "Department",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Enter department" : null,
                      ),
                      const SizedBox(height: 14),

                      // User Type
                      DropdownButtonFormField<String>(
                        value: _userType,
                        decoration: const InputDecoration(
                          labelText: "User Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "student",
                            child: Text("Student"),
                          ),
                          DropdownMenuItem(
                            value: "teacher",
                            child: Text("Teacher"),
                          ),
                          DropdownMenuItem(
                            value: "admin",
                            child: Text("Admin"),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _userType = v);
                          }
                        },
                      ),
                      const SizedBox(height: 26),

                      // Create User Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createUser,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Create User",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // LOADING OVERLAY
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
