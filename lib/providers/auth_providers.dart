

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scms/services/auth_services.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref){
  return FirebaseAuth.instance;
});

final authServiceProvider = Provider<AuthenticationService>((ref){
  return AuthenticationService(ref.read(firebaseAuthProvider));

});
final authStateProvider = StreamProvider<User?>((ref){
  return ref.watch(authServiceProvider).authStateChange;
});




/// Fetch Firestore user data for the logged-in user
final userDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider).value;

  if (user == null) return null; // Not logged in

  final doc = await FirebaseFirestore.instance
      .collection("user")
      .doc(user.uid)
      .get();

  return doc.data();
});
