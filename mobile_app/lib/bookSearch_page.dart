import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'preview_page.dart';
import 'settings_page.dart';

class book_search extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _HomePageState extends State<book_search> {
  final _debouncer = Debouncer();
  String term = "demo";
  List<BookData> ulist = [];
  List<BookData> userLists = [];
  //API call for All BookData List

  String url = 'http://192.168.2.27:3000/search_book?term=';

  Future<List<BookData>> getAllulistList() async {
    try {
      final response = await http.get(Uri.parse(url + term));
      if (response.statusCode == 200) {
        // print(response.body);
        List<BookData> list = parseAgents(response.body);
        return list;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<BookData> parseAgents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<BookData>((json) => BookData.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    getAllulistList().then((subjectFromServer) {
      setState(() {
        ulist = subjectFromServer;
        userLists = ulist;
      });
    });
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Book Search", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          //Search Bar to List of typed BookData
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              style: TextStyle(color: Colors.red),
              cursorColor: Colors.white,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                ),
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search ',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              onSubmitted: (string) {
                _debouncer.run(() {
                  term = string.toLowerCase();
                  getAllulistList().then((subjectFromServer) {
                    setState(() {
                      ulist = subjectFromServer;
                      userLists = ulist;
                    });
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(5),
              itemCount: userLists.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Preview_page(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              userLists[index].title,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            subtitle: Text(
                              userLists[index].author ?? "null",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Declare BookData class for json data or parameters of json string/data
//Class For BookData
class BookData {
  var id;
  var author;
  String title;

  BookData({
    required this.id,
    required this.author,
    required this.title,
  });

  factory BookData.fromJson(Map<dynamic, dynamic> json) {
    return BookData(
      id: json['id'],
      author: json['author'],
      title: json['title'],
    );
  }
}
