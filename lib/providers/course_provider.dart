import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';

final courseProvider = StreamProvider.family<CourseModel?, String>((ref, roomId) {
  final doc = FirebaseFirestore.instance
      .collection("couses")
      .doc(roomId.toLowerCase())
      .snapshots();

  return doc.map((snap) {
    if (!snap.exists) return null;
    return CourseModel.fromMap(snap.data()!);
  });
});
