import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allRoomsAlertProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection("rooms")
      .snapshots()
      .map((snap) =>
      snap.docs.map((doc) => {...doc.data(), "roomId": doc.id}).toList());
});
