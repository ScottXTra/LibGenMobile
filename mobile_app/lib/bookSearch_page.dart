
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

<<<<<<< HEAD

=======
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
>>>>>>> f0f77ea2d0e803a2712647a6ece106a31c340c27
class _HomePageState extends State<HomePage> {
  late Map data;
  List userData = [];
  Uri uri = Uri.parse('http://10.0.0.22:3000/search_book?term=Potato');
  Future getData() async {
    http.Response response = await http.get(uri);
    print(response.body);
    setState(() {
      userData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        " ${userData[index]["author"]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),


                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        " ${userData[index]["title"]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                
                  
                
                
                
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
