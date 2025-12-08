import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scms/components/roomcard.dart';
import '../providers/room_provider.dart';

class Roomscreen extends ConsumerWidget {
  const Roomscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRooms = ref.watch(allRoomsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rooms',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),

          // -----------------------------
          // ⭐ REALTIME ROOM LIST
          // -----------------------------
          Expanded(
            child: asyncRooms.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (rooms) {
                if (rooms.isEmpty) {
                  return const Center(child: Text("No rooms found"));
                }

                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    // Determine room status
                    String status = "empty";

                     if ( room.teacherId.isNotEmpty) {
                    status = "occupied";
                    }else if (room.students.isNotEmpty) {
                      status = "students only";
                    }

                    return roomCard(room.id, status,context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
