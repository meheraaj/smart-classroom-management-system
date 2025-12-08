import 'package:flutter/material.dart';

Widget studentCard(String studentName, String studentId,String ownerId) {


  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: studentId.toUpperCase()==ownerId.toUpperCase()?Colors.blue:Colors.blue.shade200),
      borderRadius: BorderRadius.circular(5),
    ),
    child:InkWell(
  onTap: (){},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   studentName,
                   style: const TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                   ),
                 ),

                 Text(
                   "ID : $studentId",
                   style: const TextStyle(

                     fontSize: 15,
                   ),
                   textAlign: TextAlign.left,
                 ),
               ],

             ),
              studentId.toUpperCase()==ownerId.toUpperCase()?Text('You'):Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    ),
  );
}