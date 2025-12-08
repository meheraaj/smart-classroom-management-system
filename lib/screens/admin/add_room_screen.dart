import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _roomId = TextEditingController();
  final TextEditingController _roomName = TextEditingController();
  final TextEditingController _capacity = TextEditingController();

  bool loading = false;

  Future<void> addRoom() async {
    if (_roomId.text.isEmpty || _roomName.text.isEmpty) return;

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(_roomId.text.trim())
          .set({
        "roomId": _roomId.text.trim(),
        "name": _roomName.text.trim(),
        "capacity": int.tryParse(_capacity.text) ?? 0,
        "active": true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room added successfully")),
      );

      _roomId.clear();
      _roomName.clear();
      _capacity.clear();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Room")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _roomId,
              decoration: const InputDecoration(
                  labelText: "Room ID (CX401)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _roomName,
              decoration: const InputDecoration(
                  labelText: "Room Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _capacity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Capacity", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : addRoom,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Add Room"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
