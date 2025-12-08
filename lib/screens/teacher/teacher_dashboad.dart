import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scms/components/appbar_custom.dart';
import 'package:scms/components/iconsitem.dart';

import '../../providers/auth_providers.dart';
import '../admin/add_user_screen.dart';
import '../admin/user_list_screen.dart';

class TeacherDashboad extends ConsumerWidget {
  const TeacherDashboad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);

    String name = "Loading...";
    String dept = "";
    String utype = "";
    String id = "";

    userAsync.whenData((user) {
      if (user != null) {
        name = user["name"] ?? "";
        dept = user["dept"] ?? "";
        utype = user["utype"] ?? "";
        id = user["id"] ?? "";
      }
    });

    final bool isAdmin = utype.toLowerCase() == "admin";

    return Scaffold(
      appBar: appbarCustom(isAdmin ? "Admin Dashboard" : "Teacher Dashboard"),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // -------------------------------------------------
                // USER INFO CARD
                // -------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$dept • ${utype.toUpperCase()}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ID: $id",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black45),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // -------------------------------------------------
                // FEATURE BUTTONS GRID (DISABLED FOR NOW)
                // -------------------------------------------------
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.1,
                  children: [
                    // These are visually present but non-functional (disabled)
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child: iconsItemBig("Attendance", Icons.note_add),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child: iconsItemBig("Device Control", Icons.settings),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child:
                        iconsItemBig("Room Occupancy", Icons.people_alt_rounded),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child:
                        iconsItemBig("Class Schedule", Icons.calendar_today),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child: iconsItemBig("Fire Panel", Icons.fireplace),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        child: iconsItemBig(
                            "Security Alerts", Icons.notifications_sharp),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // -------------------------------------------------
                // ADMIN ONLY ACTIONS
                // -------------------------------------------------
                if (isAdmin) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Admin Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add New User
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text("Add New User"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddUserScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // View All Users
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.people_outline),
                      label: const Text("View All Users"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserListScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],

                // -------------------------------------------------
                // SIGN OUT BUTTON
                // -------------------------------------------------
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
}
