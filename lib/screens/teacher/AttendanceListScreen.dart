import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_providers.dart';
import '../../providers/course_provider.dart';

const Color kPrimaryBlue = Color(0xFF4285F4);
const Color kGreenTag = Color(0xFF27AE60);
const Color kRedTag = Color(0xFFE74C3C);

String oid = '';

class AttendanceListScreen extends ConsumerWidget {
  final String roomId;

  const AttendanceListScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider(roomId));
    final userAsync = ref.watch(userDataProvider);
    final courseAsync = ref.watch(courseProvider(roomId));

    // Course Info
    String courseId = "No Course";
    String courseName = "No Active Class";

    courseAsync.whenData((course) {
      if (course != null) {
        courseId = course.id;
        courseName = course.name;
      }
    });

    // Logged in student
    userAsync.whenData((user) {
      if (user != null && user["utype"] == "student") {
        oid = user['id'];
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

          // -------------------------------------------------------
          // SPLIT BY STATUS ONLY (NO TIMESTAMP LOGIC ANYMORE)
          // -------------------------------------------------------
          final inStudents = <Map<String, dynamic>>[];
          final outStudents = <Map<String, dynamic>>[];

          for (var s in students) {
            final status = s["status"]?.toString().toLowerCase().trim() ?? "in";

            if (status == "out") {
              outStudents.add(s);
            } else {
              inStudents.add(s);
            }
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildHeader(courseId, courseName, inStudents.length),

                    // -------------------------------
                    // SECTION - IN CLASS
                    // -------------------------------
                    if (inStudents.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Currently In Class",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: kGreenTag),
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: inStudents.length,
                        itemBuilder: (context, index) {
                          final s = inStudents[index];
                          return _buildStudentCard(
                            name: s["name"],
                            id: s["id"],
                            status: "In",
                            tagColor: kGreenTag,
                            highlight: oid.toLowerCase() == s["id"].toLowerCase(),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 15),

                    // -------------------------------
                    // SECTION - OUT OF CLASS
                    // -------------------------------
                    if (outStudents.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Left Class",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: outStudents.length,
                        itemBuilder: (context, index) {
                          final s = outStudents[index];
                          return _buildStudentCard(
                            name: s["name"],
                            id: s["id"],
                            status: "Out",
                            tagColor: kRedTag,
                            isDimmed: true,
                            highlight: false,
                          );
                        },
                      ),
                    ],

                    if (inStudents.isEmpty && outStudents.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(child: Text("No attendance records found.")),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER UI
  // ---------------------------------------------------------
  Widget _buildHeader(String courseId, String courseName, int presentCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('10:40 AM - 11:30 AM',
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 5),

          Text(courseId,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(courseName,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
          const Text('5AM',
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Present: $presentCount',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              _buildExportButton(),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // EXPORT BUTTON
  // ---------------------------------------------------------
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

  // ---------------------------------------------------------
  // STUDENT CARD
  // ---------------------------------------------------------
  Widget _buildStudentCard({
    required String name,
    required String id,
    required String status,
    required Color tagColor,
    bool isDimmed = false,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: isDimmed ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: highlight ? Colors.blue : Colors.transparent, width: highlight ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Student info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDimmed ? Colors.black54 : Colors.black)),
              const SizedBox(height: 4),
              Text("ID: $id",
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),

          // Status tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: tagColor),
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: tagColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
