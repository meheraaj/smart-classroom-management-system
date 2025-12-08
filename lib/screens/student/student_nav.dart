

import 'package:flutter/material.dart';
import 'package:scms/screens/alertscreen.dart';
import 'package:scms/screens/roomscreen.dart';
import 'package:scms/screens/student/student_dashboard.dart';
import 'package:scms/screens/studentscreen.dart';

class StudentNav extends StatefulWidget {
  const StudentNav({super.key});

  @override
  State<StudentNav> createState() => _StudentNavState();
}

class _StudentNavState extends State<StudentNav> {
  int _currentIndex = 0;

  final List _pages = [StudentDashboard(),Roomscreen(),Alertscreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i){
            setState(() {
              _currentIndex = i;
            });
          },
          items: [
        BottomNavigationBarItem(icon:Icon(Icons.home_filled),label: "Home"),
        BottomNavigationBarItem(icon:Icon(Icons.roofing_sharp),label: "Rooms"),
            BottomNavigationBarItem(icon:Icon(Icons.notification_important_sharp),label: "Alert"),
      ]),
      body: _pages[_currentIndex],
    );
  }
}
