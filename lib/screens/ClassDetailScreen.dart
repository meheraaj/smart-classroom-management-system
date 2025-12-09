import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/room_provider.dart';
import '../../providers/auth_providers.dart';
import '../../providers/course_provider.dart';
import '../../models/roommodel.dart';
import '../../screens/teacher/AttendanceListScreen.dart';
import '../../screens/teacher/DeviceControlScreen.dart';
import '../models/course_model.dart';
import '../providers/teacher_provider.dart';

const Color kPrimaryBlue = Color(0xFF4285F4);
const Color kGreenTag = Color(0xFF27AE60);

String tid = "";
bool canEdit = false;

class ClassDetailsScreen extends ConsumerWidget {
  final String roomNumber;

  const ClassDetailsScreen({super.key, required this.roomNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomNumber));
    final courseAsync = ref.watch(courseProvider(roomNumber));
    final userAsync = ref.watch(userDataProvider);

    userAsync.whenData((user) {
      if (user != null && user["utype"] == "teacher") {
        tid = user['id'];
      } else if (user != null && user["utype"] == "admin") {
        canEdit = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Class Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: roomAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e"),
            data: (room) {
              final teacherAsync =
              (room.teacherId != null && room.teacherId!.isNotEmpty)
                  ? ref.watch(teacherProvider(room.teacherId!))
                  : null;

              return _buildContent(context, room, teacherAsync, courseAsync);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      RoomModel room,
      AsyncValue<List<Map<String, dynamic>>>? teacherAsync,
      AsyncValue<CourseModel?> courseAsync,
      ) {
    // Default values
    String courseId = "";
    String courseName = "";

    courseAsync.whenData((c) {
      if (c != null) {
        courseId = c.id;
        courseName = c.name;
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ---------- COURSE INFO ----------
        Text(
          courseId.isEmpty ? "No Course Assigned" : courseId,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          courseName.isEmpty ? "Course metadata missing" : courseName,
          style: const TextStyle(fontSize: 17, color: Colors.black54),
        ),

        const SizedBox(height: 10),
        _roomTag(roomNumber),

        const SizedBox(height: 20),

        // ---------- TEACHER CARD ----------
        if (teacherAsync != null)
          teacherAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text("Teacher load error: $e"),
            data: (list) {
              final t = list.first;
              bool isSameTeacher = t["id"] == tid;
              canEdit = canEdit || isSameTeacher;

              return _teacherCard(t, isSameTeacher);
            },
          ),

        const SizedBox(height: 30),

        // ---------- ATTENDANCE BUTTON ----------
        _actionButton(
          label: "Attendance",
          color: kPrimaryBlue,
          onPressed: () {
            // if (canEdit) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AttendanceListScreen(roomId: roomNumber),
                ),
              );
            // } else {
            //   _restricted(context);
            // }
          },
        ),

        const SizedBox(height: 15),

        // ---------- DEVICE CONTROL BUTTON ----------
        _actionButton(
          label: "Control Devices",
          color: Colors.white,
          textColor: Colors.black,
          border: Colors.grey.shade300,
          onPressed: () {
            // if (canEdit ) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceControlScreen(roomId: roomNumber),
                ),
              );
            // } else {
            //   _restricted(context);
            // }
          },
        ),

        const SizedBox(height: 30),

        // ---------- SENSOR VALUES ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sensor("Temp", "${room.temp}°C", Icons.thermostat),
            _sensor("Light", room.light == 1 ? "On" : "Off",
                Icons.light_mode_outlined),
            _sensor("Students", room.students.length.toString(),
                Icons.people_outline),
            _sensor(
              "Fire",
              room.fire == 1 ? "ALERT" : "Safe",
              Icons.warning_amber_rounded,
              warning: room.fire == 1,
            ),
          ],
        ),
      ]),
    );
  }

  // ---------------------------------------------------------
  // UI WIDGETS
  // ---------------------------------------------------------

  Widget _teacherCard(Map<String, dynamic> t, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t["name"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("ID: ${t["id"]}"),
        Text("Dept: ${t["dept"]}"),
      ]),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
    Color textColor = Colors.white,
    Color? border,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: border != null ? BorderSide(color: border) : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _sensor(String name, String value, IconData icon,
      {bool warning = false}) {
    return Column(
      children: [
        Icon(icon, size: 32, color: warning ? Colors.red : Colors.black),
        Text("$name: $value",
            style: TextStyle(
                color: warning ? Colors.red : Colors.black, fontSize: 14)),
      ],
    );
  }

  Widget _roomTag(String room) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: kGreenTag, borderRadius: BorderRadius.circular(8)),
      child: Text(
        room,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _restricted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Only administrators or assigned teachers can access this."),
      ),
    );
  }
}
