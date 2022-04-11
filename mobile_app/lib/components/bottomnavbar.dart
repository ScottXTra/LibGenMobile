import 'package:flutter/material.dart';

class MainNavBar extends StatefulWidget {
  @override
  State<MainNavBar> createState() => _MainNavBar();
}

class _MainNavBar extends State<MainNavBar> {
  int _selectedIndex = 0;
  void tabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber,
      onTap: tabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Attractions",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Scheduled",
        ),
      ],
    );
  }
}
