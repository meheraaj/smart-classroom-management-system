import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scms/screens/teacher/AttendanceListScreen.dart';
import 'package:scms/screens/teacher/DeviceControlScreen.dart';

import '../providers/auth_providers.dart';
import '../providers/room_provider.dart';
import '../models/roommodel.dart';
import '../providers/teacher_provider.dart';

// --- Constants ---
const Color kPrimaryBlue = Color(0xFF4285F4);
const Color kGreenTag = Color(0xFF27AE60);
String tid = "";
bool canEdit = false;
class ClassDetailsScreen extends ConsumerWidget {
  final String courseCode = 'CSE-3524';
  final String courseName = 'Microprocessor';
  final String classTime = '10:40 AM - 11:30 AM';
  final String section = '5AM';
  final String roomNumber;

  const ClassDetailsScreen({super.key, required this.roomNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomNumber));
    final userAsync = ref.watch(userDataProvider);


    userAsync.whenData((user) {
      if (user != null && user["utype"] == "teacher") {
        tid= user['id'];// students CANNOT edit

      }else if(user!=null && user["utype"] ==  'admin'){
        canEdit = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Class Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: roomAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (room) {
              // Get teacherId from room
              final teacherId = (room.teacherId ?? "").toLowerCase();

              // Load teacher only if available
              AsyncValue<List<Map<String, dynamic>>>? teacherAsync;
              if (teacherId.isNotEmpty) {
                teacherAsync = ref.watch(teacherProvider(teacherId));
              }

              return _buildContent(context, room, teacherAsync);
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // MAIN UI CONTENT
  // ---------------------------------------------------------
  Widget _buildContent(
      BuildContext context,
      RoomModel room,
      AsyncValue<List<Map<String, dynamic>>>? teacherAsync,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Time
          Text(
            classTime,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Course Code
          Text(
            courseCode,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),

          // Course Name
          Text(
            courseName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          // Section
          Text(
            section,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          // Room Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kGreenTag,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              roomNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // TEACHER CARD (Only if teacherAsync != null)
          // ---------------------------------------------------------

          if (teacherAsync != null) ...[
            teacherAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Teacher Error: $e"),
              data: (list) {

                final t = list.first;
                bool isSameTeacher= t['id']==tid.toLowerCase();
                canEdit = canEdit ||isSameTeacher;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSameTeacher? Colors.blue:Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.badge, size: 20),
                          const SizedBox(width: 6),
                          Text("ID: ${t["id"]}"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.school, size: 20),
                          const SizedBox(width: 6),
                          Text("Dept: ${t["dept"]}"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],

          // --- Attendance Button ---
          _buildActionButton(
            text: 'Attendance',
            color: kPrimaryBlue,
            onPressed: () {
    if(canEdit || tid==''){ Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceListScreen(roomId: roomNumber),
                ),
              );  }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action restricted: Only administrators or class teachers can perform this function.')),
      );
    }
            },
          ),
          const SizedBox(height: 15),

          // --- Control Devices Button ---
          _buildActionButton(
            text: 'Control Devices',
            color: Colors.white,
            textColor: Colors.black87,
            borderColor: Colors.grey.shade300,
            onPressed: () {
              if(canEdit || tid==''){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceControlScreen(roomId: roomNumber),
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Action restricted: Only administrators or class teachers can perform this function.')),
                );
              }
            },
          ),

          const SizedBox(height: 40),

          // --- SENSOR VALUES ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSensorItem(
                icon: Icons.thermostat_outlined,
                label: 'Temp',
                value: '${room.temp}°C',
              ),
              _buildSensorItem(
                icon: Icons.wb_sunny_outlined,
                label: 'Light',
                value: room.light==0?"Off":room.light==1?"On":"Auto",
                isWarning: room.light==0?false:true
              ),
              _buildSensorItem(
                icon: Icons.person_outline,
                label: 'Students',
                value: '${room.students.length}',
              ),
              _buildSensorItem(
                icon: Icons.warning_amber_rounded,
                label: 'Alarm',
                value: room.fire == 1 ? "FIRE!" : "Safe",
                isWarning: room.fire == 1,
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // BUTTON WIDGET
  Widget _buildActionButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // SENSOR ITEM
  Widget _buildSensorItem({
    required IconData icon,
    required String label,
    String value = '',
    bool isWarning = false,
  }) {
    final String fullLabel =
    value.isNotEmpty ? '$label $value' : label;

    return Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: isWarning ? Colors.blue : Colors.black87,
        ),
        const SizedBox(height: 5),
        Text(
          fullLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isWarning ? Colors.blue : Colors.black87,
          ),
        ),
      ],
    );
  }
}
