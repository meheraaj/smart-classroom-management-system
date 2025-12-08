import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageRoomsScreen extends StatelessWidget {
  const ManageRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Rooms")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("rooms").snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No rooms added yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final room = docs[i];
              return Card(
                child: ListTile(
                  title: Text("${room['name']} (${room['roomId']})"),
                  subtitle: Text("Capacity: ${room['capacity']}"),
                  trailing: Switch(
                    value: room["active"],
                    onChanged: (v) {
                      FirebaseFirestore.instance
                          .collection("rooms")
                          .doc(room.id)
                          .update({"active": v});
                    },
                  ),
                  onTap: () => _editRoom(context, room),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editRoom(BuildContext context, DocumentSnapshot room) {
    final TextEditingController nameCtrl =
    TextEditingController(text: room["name"]);
    final TextEditingController capCtrl =
    TextEditingController(text: room["capacity"].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Room"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Room Name"),
            ),
            TextField(
              controller: capCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Capacity"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("rooms")
                  .doc(room.id)
                  .update({
                "name": nameCtrl.text.trim(),
                "capacity": int.tryParse(capCtrl.text) ?? 0,
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
