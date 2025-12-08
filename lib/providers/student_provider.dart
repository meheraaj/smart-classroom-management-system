import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/studentmodel.dart';

final allStudentsProvider = StreamProvider<List<Studentmodel>>((ref) {
  return FirebaseFirestore.instance
      .collection("user")
      .where("utype", isEqualTo: "student")
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Studentmodel.fromMap(doc.data());
    }).toList();
  });
});
