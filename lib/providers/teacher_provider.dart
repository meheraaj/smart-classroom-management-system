import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teacherProvider =
FutureProvider.family<List<Map<String, dynamic>>, String>((ref, tid) async {
  List<Map<String, dynamic>> tinfo = [];

  // Fetch user info by internal field ID
  final querySnapshot = await FirebaseFirestore.instance
      .collection("user") // <-- ensure correct collection name
      .where("id", isEqualTo: tid.toLowerCase())
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    // Return fallback teacher object
    tinfo.add({
      "id": tid,
      "name": "Unknown",
      "dept": "CSE",
      "utype": "teacher",
    });
    return tinfo;
  }

  final userDoc = querySnapshot.docs.first;
  final data = userDoc.data();

  tinfo.add({
    "id": data["id"] ?? tid,
    "name": data["name"] ?? "Unknown",
    "dept": data["dept"] ?? "CSE",
    "utype": data["utype"] ?? "teacher",
  });

  return tinfo;
});
