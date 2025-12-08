

import 'package:flutter/material.dart';
import 'package:scms/screens/ClassDetailScreen.dart';
import 'package:scms/screens/alertscreen.dart';
import 'package:scms/screens/roomscreen.dart';
import 'package:scms/screens/studentscreen.dart';
import 'package:scms/screens/teacher/teacher_dashboad.dart';

class NavHolder extends StatefulWidget {
  const NavHolder({super.key});

  @override
  State<NavHolder> createState() => _NavHolderState();
}

int _currentIndex = 0;
final _pages = [TeacherDashboad(),Roomscreen(),Studentscreen(),Alertscreen()];
class _NavHolderState extends State<NavHolder> {

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 430), // <-- Use 430.0
      child: Scaffold(
      
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black, // Example: Dark background
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue, // Active item is bright amber
        currentIndex: _currentIndex,
          showUnselectedLabels: true,
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.roofing),label: "Rooms"),BottomNavigationBarItem(icon: Icon(Icons.person),label: "Students"),BottomNavigationBarItem(icon: Icon(Icons.notification_important_rounded),label: "Alerts"),
        ],
        onTap: (val){
          setState(() {
            _currentIndex = val;
          });
        },),
      
        body: _pages[_currentIndex],
      ),
    );
  }
}



class PlaceHolderPage extends StatelessWidget {
  const PlaceHolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hey'),),
    );
  }
}
