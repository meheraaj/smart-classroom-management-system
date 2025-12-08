import 'package:cloud_firestore/cloud_firestore.dart';

class Studentmodel {
  final String id; // the document id: cx404, cx401
  final String name;
  final String dept;
  final String utype;

  Studentmodel({
   required this.name, required this.dept, required this.utype, required this.id,
  });

  factory Studentmodel.fromMap(Map<String, dynamic> map) {
    return Studentmodel(
      id:map["id"]??"",
      name:map["name"]??"",
      dept:map["dept"]??"",

      utype:map["utype"]??"",


    );
  }
}
