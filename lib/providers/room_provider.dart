import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/roommodel.dart';



final allRoomsStreamProvider = StreamProvider<List<RoomModel>>((ref) {
  final collectionRef = FirebaseFirestore.instance.collection("rooms");

  return collectionRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return RoomModel.fromMap(doc.data() as Map<String, dynamic>)
        ..id = doc.id; // optional: save room id (cx401)
    }).toList();
  });
});

final roomStreamProvider =
StreamProvider.family<RoomModel, String>((ref, roomId) {
  return FirebaseFirestore.instance
      .collection("rooms")
      .doc(roomId)
      .snapshots()
      .map((snap) => RoomModel.fromMap(snap.data() ?? {}));
});


final studentCurrentRoomProvider =
FutureProvider.family<String?, String>((ref, studentId) async {
  final snapshot =
  await FirebaseFirestore.instance.collection("rooms").get();

  for (var doc in snapshot.docs) {
    final data = doc.data();

    final studentsMap = data["students"] as Map<String, dynamic>?;
    print(data["students"]);
    if (studentsMap != null && studentsMap.containsKey(studentId.toLowerCase())) {
      print("yes conttains");
      return doc.id;  // room id (cx404)
    }
  }

  return null; // student NOT inside any room
});
