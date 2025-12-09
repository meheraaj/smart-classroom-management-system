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
      final studentId =
      entry.key.toString().toLowerCase(); // e.g. "c233267"
      final attendData = entry.value ?? {};

      final String status =
      (attendData["status"] ?? "in").toString().trim().toLowerCase();

      final String enter =
          attendData["enter"]?.toString() ?? "--";
      final String leave =
          attendData["leave"]?.toString() ?? "--";

      // Fetch user info
      final querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where("id", isEqualTo: studentId)
          .limit(1)
          .get();

      String name = "Unknown";

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        name = data["name"] ?? "Unknown";
      }

      attendanceList.add({
        "id": studentId,
        "name": name,
        "status": status, // <<< VERY IMPORTANT
        "enter": enter,
        "leave": leave,
      });
    }

    return attendanceList;
  });
});
