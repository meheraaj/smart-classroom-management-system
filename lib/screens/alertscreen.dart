import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/room_alert_provider.dart';

class Alertscreen extends ConsumerWidget {
  const Alertscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(allRoomsAlertProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Alerts"),
        centerTitle: true,
      ),

      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),

        data: (rooms) {
          List<Widget> alerts = [];

          for (var room in rooms) {
            final roomId = room["roomId"];
            final int fire = room["fire"] ?? 0;
            final int temp = room["temp"] ?? 0;
            final int fan = room["fan"] ?? 0;
            final int light = room["light"] ?? 0;

            Map<String, dynamic> students = room["students"] ?? {};
            bool noStudents = students.isEmpty;

            String? teacherId = room["teacherId"];
            bool noTeacher = teacherId == null || teacherId.isEmpty;

            // 🔥 FIRE ALERT
            if (fire == 1) {
              alerts.add(_alertCard(
                roomId,
                "🔥 Fire Detected!",
                "Fire has been detected in room $roomId.",
                Colors.redAccent,
              ));
            }

            // 🌡 HIGH TEMPERATURE ALERT
            if (temp > 40) {
              alerts.add(_alertCard(
                roomId,
                "🌡 High Temperature",
                "Room $roomId temperature is above 40°C.",
                Colors.deepOrange,
              ));
            }

            // ⚡ ENERGY WASTE ALERT
            if ((noStudents && noTeacher) && (fan == 1 || light == 1)) {
              alerts.add(_alertCard(
                roomId,
                "⚡ Energy Wasting Alert",
                "Fan/light is ON in room $roomId but the room is empty.",
                Colors.amber.shade700,
              ));
            }
          }

          // If no alerts
          if (alerts.isEmpty) {
            return const Center(
              child: Text(
                "No active alerts 🎉",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          // Return all alert cards
          return ListView(
            padding: const EdgeInsets.all(16),
            children: alerts,
          );
        },
      ),
    );
  }

  // Alert Card UI
  Widget _alertCard(String roomId, String title, String msg, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),

                const SizedBox(height: 4),

                Text(msg,
                    style:
                    const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
