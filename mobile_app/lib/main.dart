import 'package:flutter/material.dart';
import 'bookSearch_page.dart';
import 'library_page.dart';
import 'login_page.dart';
import 'preview_page.dart';

void main() {runApp(MaterialApp(home: LoginPage(),));}

class ListViewBuilder extends StatefulWidget {


  @override
  State<ListViewBuilder> createState() => _ListViewBuilder();
}
class _ListViewBuilder extends State<ListViewBuilder> {
  /*The selectedIndex would be the page we are currently on*/
  int _selectedIndex = 0;
  List<Widget> nav_pages = [library_page(), book_search()];

  /*Selection of the tabs*/
  void tabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      

      /*The floating action button on the bottom right of the bottom nav bar  */
      

      /*Will be at the bottom of the screen  */
      bottomNavigationBar: BottomNavigationBar(
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
      ),

      /*Each of these bodies will have its own state*/
      body: nav_pages[_selectedIndex],
    );
  }
} //ListViewBuilder Class

