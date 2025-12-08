import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_providers.dart';


const Color kPrimaryBlue = Color(0xFF4285F4);
const Color kGreenTag = Color(0xFF27AE60);
String oid = '';
class AttendanceListScreen extends ConsumerWidget {
  final String roomId;

  const AttendanceListScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider(roomId));
    final userAsync = ref.watch(userDataProvider);


    userAsync.whenData((user) {
      if (user != null && user["utype"] == "student") {
        oid = user['id'];
      } });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: attendanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (students) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  _buildHeader(),

                  // --- Student List ---
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        return _buildStudentAttendanceCard(
                          name: student["name"],
                          id: student["id"],
                          time: _formatTime(student["enter"]),
                        );

                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('10:40 AM - 11:30 AM',
              style: TextStyle(fontSize: 14, color: Colors.black54)),

          const SizedBox(height: 5),
          const Text('CSE-3524',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          const Text('Microprocessor',
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          const Text('5AM',
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 20),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Present:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildExportButton(),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return "--";
    final date = (timestamp as Timestamp).toDate();
    return "${date.hour}:${date.minute.toString().padLeft(2, "0")}";
  }


  Widget _buildExportButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimaryBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'Export Attendance',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildStudentAttendanceCard({
    required String name,
    required String id,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: id.toLowerCase()==oid.toLowerCase()?Colors.blue:Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name ,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("ID: $id",
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54)),
            ],
          ),
          Text(
            time,
            style: const TextStyle(
                fontSize: 14,
                color: kGreenTag,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
