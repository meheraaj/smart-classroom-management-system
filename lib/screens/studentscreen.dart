import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scms/components/studentcard.dart';
import '../providers/auth_providers.dart';
import '../providers/student_provider.dart';

class Studentscreen extends ConsumerWidget {
  const Studentscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(allStudentsProvider);
    final userAsync = ref.watch(userDataProvider);

    String id = '';
    userAsync.whenData((user) {
      if (user != null && user["utype"] == "student") {
        id= user['id'];
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        centerTitle: true,
      ),

      body: studentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),

        data: (students) {
          if (students.isEmpty) {
            return const Center(
              child: Text("No students found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final s = students[index];

              return studentCard(
                s.name,
                s.id.toUpperCase(), // THIS IS FIRESTORE DOC ID (e.g. C233267)
                id
              );
            },
          );
        },
      ),
    );
  }
}
