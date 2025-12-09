import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String id; // the document id: cx404, cx401
  final int fan;
  final int fire;
  final int humidity;
  final int light;
  final int projector;
  final int temp;
  final String teacherId;
  final Map<String, dynamic> students;
  final String? lastUpdate;

  RoomModel({
    this.id = "",
    required this.fan,
    required this.fire,
    required this.humidity,
    required this.light,
    required this.projector,
    required this.temp,
    required this.teacherId,
    required this.students,
    this.lastUpdate,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      fan: map["fan"] ?? 0,
      fire: map["fire"] ?? 0,
      humidity: map["humidity"] ?? 0,
      light: map["light"] ?? 0,
      projector: map["projector"] ?? 0,
      temp: map["temp"] ?? 0,
      teacherId: map["teacherId"] ?? "",
      students: map["students"] ?? {},
      lastUpdate: map["last_update"] != null
          ? (map["last_update"])
          : "",
    );
  }
}
