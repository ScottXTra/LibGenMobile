import 'package:flutter/material.dart';
import 'package:loginscreen/search%20pages/bookSearch_page.dart';
import 'library_page.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
              constraints: BoxConstraints.expand(height: 300.0),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/webookslogo.png'), fit: BoxFit.cover)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.width * 0.60,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text("Welcome to WeBooks", style: TextStyle(fontSize: 38.0, color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width * 0.60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ListViewBuilder(),
                    ),
                  );
                },
                padding: EdgeInsets.only(top: 15, bottom: 15),
                color: Color.fromARGB(255, 254, 3, 55),
                textColor: Colors.white,
                child: Text("Get Started".toUpperCase(), style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
