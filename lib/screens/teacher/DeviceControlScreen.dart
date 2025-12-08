import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/roommodel.dart';
import '../../providers/auth_providers.dart';
import '../../providers/device_control_provider.dart';
import '../../providers/room_provider.dart';


const Color kPrimaryBlue = Color(0xFF4285F4);
bool enableEdit = true;
class DeviceControlScreen extends ConsumerWidget {
  final String roomId;

  const DeviceControlScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomId));
    final userAsync = ref.watch(userDataProvider);


    userAsync.whenData((user) {
      if (user != null && user["utype"] == "student") {
        enableEdit = false; // students CANNOT edit
      } else {
        enableEdit = true; // teachers CAN edit
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
          'Classroom Device Control',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: roomAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (room) => _buildContent(context, ref, room),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, RoomModel room) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 430),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDeviceCard(
                context: context,
                ref: ref,
                room: room,
                icon: Icons.lightbulb_outline,
                label: 'Light',
                field: "light",
                value: room.light,
              ),
              _buildDeviceCard(
                context: context,
                ref: ref,
                room: room,
                icon: Icons.power_settings_new_rounded,
                label: 'Fan',
                field: "fan",
                value: room.fan,
              ),
              _buildDeviceCard(
                context: context,
                ref: ref,
                room: room,
                icon: Icons.monitor,
                label: 'Projector',
                field: "projector",
                value: room.projector,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required BuildContext context,
    required WidgetRef ref,
    required RoomModel room,
    required IconData icon,
    required String label,
    required String field,
    required int value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 30, color: Colors.black87),
              const SizedBox(width: 15),
              Text(label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),

          _buildToggleButtons(ref, room.id, field, value,context),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(
      WidgetRef ref,
      String roomIdd,
      String field,
      int value,
  BuildContext context
      ) {
    return ToggleButtons(
      isSelected: [
        value == 1,
        value == 0,
        value == 2,
      ],

      onPressed: (index) {
        int newVal = index == 0 ? 1 : index == 1 ? 0 : 2;

        enableEdit
            ? ref.read(deviceControllerProvider.notifier).updateDevice(
          roomId: roomId,
          field: field,
          value: newVal,
        ):ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action restricted: Only administrators or teachers can perform this function'),backgroundColor: Colors.red,),
        );
      },


      constraints: const BoxConstraints(minHeight: 35, minWidth: 60),
      renderBorder: false,
      selectedColor: Colors.white,
      fillColor: kPrimaryBlue,
      color: enableEdit ? Colors.black87 : Colors.grey,
      borderRadius: BorderRadius.circular(5),
      children: const [
        Text("ON"),
        Text("Off"),
        Text("Auto"),
      ],
    );
  }

}
