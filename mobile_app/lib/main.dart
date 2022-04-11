import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'bookSearch_page.dart';
import 'library_page.dart';
import 'login_page.dart';
import 'preview_page.dart';


void main() {
  runApp(MaterialApp(
    home: SplashScreenView(
      navigateRoute: ListViewBuilder(),
      duration: 3000,
      imageSize: 500,
      imageSrc: "assets/webookslogo.png",
      text: "Welcome to WeBooks",
      textType: TextType.NormalText,
      textStyle: TextStyle(
        fontSize: 30.0,
        color: Colors.white
      ),
      backgroundColor: Colors.grey[900],
    ),
    debugShowCheckedModeBanner: false,
  ));
}

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
        backgroundColor: Colors.grey[850],
        unselectedItemColor: Colors.white,
        fixedColor: Colors.red,
        onTap: tabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: "Book Search",
          ),
        ],
      ),

      /*Each of these bodies will have its own state*/
      body: nav_pages[_selectedIndex],
    );
  }
} //ListViewBuilder Class

