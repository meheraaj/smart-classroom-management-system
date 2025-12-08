import 'package:flutter/material.dart';

import '../screens/ClassDetailScreen.dart';

Widget roomCard(String roomNumber, String status,BuildContext context) {
  final Color c;
  if (status == 'occupied') {
    c = const Color(0xFF2ECC71);
  } else if (status == 'students only') {
    c = const Color(0xFFF39C12);
  } else {
    c = const Color(0xFFBDC3C7);
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue.shade200),
      borderRadius: BorderRadius.circular(5),
    ),
    child: InkWell(
      onTap: (){
//ClassDetailsScreen()
       Navigator.push(context,  MaterialPageRoute(
         builder: (context) => ClassDetailsScreen(roomNumber: roomNumber),
       ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                roomNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: c,
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}