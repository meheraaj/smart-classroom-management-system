import 'package:flutter/material.dart';

Widget iconsItemBig(String text,IconData icon){

  return InkWell(
    onTap: (){},

    child: Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey,width: 0.05), // <-- ADDED COMMA HERE
        //   boxShadow: [ // BoxShadow takes a list of shadows
        //     BoxShadow(
        //       color: Colors.white, // Use opacity for a softer look
        //       blurRadius:200, // Controls the fuzziness of the shadow
        //       offset: Offset(0.1, 0.1), // Moves the shadow 3 pixels down
        //     ),
        //   ],
        // ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [

            Icon(icon,size: 60,color: Colors.deepPurple),

            Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
          ],
        ),
      ),
    ),
  );

}