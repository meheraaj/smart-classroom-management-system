import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/appbar_custom.dart';
import '../../providers/auth_providers.dart';
import '../../providers/room_provider.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get logged-in user
    final authUser = ref.watch(authStateProvider).value;
    final userAsync = ref.watch(userDataProvider);
    String studentId = '';
    String studentName = '';
    userAsync.whenData((user) {
      if (user != null && user["utype"] == "student") {
        studentId = user['id'];
        studentName = user['name'];
      }
    });

    // Fetch student’s current room
    final currentRoomAsync =
    ref.watch(studentCurrentRoomProvider(studentId));

    return Scaffold(
      appBar: appbarCustom("Student Dashboard"),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  studentName,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 25),

                // GRID CARDS
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.1,
                  children: [
                    _dashboardCard(
                      icon: Icons.book_outlined,
                      title: "My Courses",
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      onTap: () {},
                    ),
                    _dashboardCard(
                      icon: Icons.fact_check_outlined,
                      title: "Attendance",
                      color: Colors.green.shade50,
                      iconColor: Colors.green,
                      onTap: () {},
                    ),
                    _dashboardCard(
                      icon: Icons.schedule_outlined,
                      title: "Routine",
                      color: Colors.orange.shade50,
                      iconColor: Colors.orange,
                      onTap: () {},
                    ),
                    _dashboardCard(
                      icon: Icons.notifications_none,
                      title: "Notices",
                      color: Colors.purple.shade50,
                      iconColor: Colors.purple,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // UPCOMING CLASS
                const Text(
                  "Upcoming Class",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Microprocessor",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "10:40 AM - Room CX401",
                            style:
                            TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // CURRENT ROOM INDICATOR
                const Text(
                  "Your Current Room",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                currentRoomAsync.when(
                  loading: () => const Text(
                      "Checking room status...",
                      style: TextStyle(fontSize: 15)),
                  error: (e, _) =>
                      Text("Error: $e", style: const TextStyle(color: Colors.red)),
                  data: (roomId) {
                    if (roomId == null) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "You are not currently inside any room.",
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.meeting_room,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "You are currently in Room $roomId",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // ----------------------------
                // SIGN OUT BUTTON
                // ----------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authServiceProvider).signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text("Sign Out"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dashboard Card widget
  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
