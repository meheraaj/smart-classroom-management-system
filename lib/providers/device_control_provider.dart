import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

class DeviceController extends StateNotifier<bool> {
  DeviceController() : super(false);

  Future<void> updateDevice({
    required String roomId,
    required String field,
    required int value,
  }) async {
    print(roomId);
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(roomId)
        .update({field: value});
  }
}

final deviceControllerProvider =
StateNotifierProvider<DeviceController, bool>((ref) {
  return DeviceController();
});
