


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final attendanceProvider =
StreamProvider.family<List<Map<String, dynamic>>, String>((ref, roomId) {
  return FirebaseFirestore.instance
      .collection("rooms")
      .doc(roomId)
      .snapshots()
      .asyncMap((snapshot) async {
    final roomData = snapshot.data();
    if (roomData == null) return [];

    final studentsMap = roomData["students"] ?? {};

    List<Map<String, dynamic>> attendanceList = [];

    for (var entry in studentsMap.entries) {
      final studentId = entry.key.toString().toLowerCase();          // e.g. "c233267"
      final attendData = entry.value;       // { enter: ..., leave: ... }

      // Fetch user info from users/<studentId>
      final querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where("id", isEqualTo: studentId.toLowerCase()) // studentId = C233267 for example
          .limit(1)
          .get();



      final userDoc = querySnapshot.docs.first;
      final data = userDoc.data();

      attendanceList.add({
        "id": studentId,
        "name": data["name"] ?? "Unknown",
        "enter": attendData["enter"],
        "leave": attendData["leave"],
      });
    }

    return attendanceList;
  });
});

