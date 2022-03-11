import 'package:flutter/material.dart';
import 'attractions.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:path/path.dart' as p;
import 'settings_page.dart';

class library_page extends StatefulWidget {
  @override
  State<library_page> createState() => _library_pageState();
}

class _library_pageState extends State<library_page> {
  bool _tappedList = false;
  String sortMethod = 'Recent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          "Library",
        ),
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
        children: [
          sortAndList(
            updateParentGridList: refreshGridList,
            updateParentSorting: refreshSorting,
          ),
          Expanded(
            child: _tappedList
                ? BooksListView(sortingMethod: sortMethod)
                : BooksGridView(sortingMethod: sortMethod),
          ),
        ],
      ),
    );
  }

  refreshGridList() {
    setState(() {
      _tappedList = !_tappedList;
    });
  }

  refreshSorting(String value) {
    setState(() {
      sortMethod = value;
    });
  }
}

class BooksGridView extends StatefulWidget {
  final String sortingMethod;
  const BooksGridView({Key? key, this.sortingMethod = ""}) : super(key: key);

  @override
  State<BooksGridView> createState() => _BooksGridViewState();
}

class _BooksGridViewState extends State<BooksGridView> {
  @override
  Widget build(BuildContext context) {
    List books = dummy_data;

    books.sort((a, b) {
      return a[widget.sortingMethod.toLowerCase()]
          .compareTo(b[widget.sortingMethod.toLowerCase()]);
    });
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      children: [
        for (int i = 0; i < books.length; i++)
          SingleBookGridView(books[i]['image'],
              books[i]['title'] + "_" + books[i]['author'], books[i]['title'])
      ],
    );
  }

  Widget SingleBookGridView(String imageUrl, String bookPath, String title) {
    return GestureDetector(
      onTap: () async {
        Directory doucmentsDir = await getApplicationDocumentsDirectory();
        String doucmentsPath = doucmentsDir.path;

        String fullBookPath = doucmentsPath + '/' + bookPath;

        if (await File(fullBookPath + ".pdf").exists()) {
          //for opening pdf
          OpenFile.open(fullBookPath + ".pdf");
        } else if (await File(fullBookPath + ".epub").exists()) {
          //for opening epub
          EpubViewer.setConfig(
            themeColor: Theme.of(context).primaryColor,
            identifier: "iosBook",
            scrollDirection: EpubScrollDirection.VERTICAL,
            allowSharing: true,
            enableTts: true,
          );
          EpubViewer.open(fullBookPath + ".epub");
        }

        // for opening pdf
      },
      child: Column(
        children: [
          Expanded(
            child: Card(
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class BooksListView extends StatefulWidget {
  final String sortingMethod;
  const BooksListView({Key? key, this.sortingMethod = ""}) : super(key: key);
  @override
  State<BooksListView> createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  @override
  Widget build(BuildContext context) {
    List books = dummy_data;
    books.sort((a, b) {
      return a[widget.sortingMethod.toLowerCase()]
          .compareTo(b[widget.sortingMethod.toLowerCase()]);
    });
    return ListView(
      children: [
        for (int i = 0; i < books.length; i++)
          SingleBookListView(books[i]['image'], books[i]['author'],
              books[i]['title'], books[i]['title'] + "_" + books[i]['author'])
      ],
    );
  }

  Widget SingleBookListView(
      String url, String author, String title, String bookPath) {
    return GestureDetector(
      onTap: () async {
        Directory doucmentsDir = await getApplicationDocumentsDirectory();
        String doucmentsPath = doucmentsDir.path;

        String fullBookPath = doucmentsPath + '/' + bookPath;

        if (await File(fullBookPath + ".pdf").exists()) {
          //for opening pdf
          OpenFile.open(fullBookPath + ".pdf");
        } else if (await File(fullBookPath + ".epub").exists()) {
          //for opening epub
          EpubViewer.setConfig(
            themeColor: Theme.of(context).primaryColor,
            identifier: "iosBook",
            scrollDirection: EpubScrollDirection.VERTICAL,
            allowSharing: true,
            enableTts: true,
          );
          EpubViewer.open(fullBookPath + ".epub");
        }

        // for opening pdf
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        child: Card(
          color: Colors.grey[800],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                url,
                fit: BoxFit.fill,
                alignment: Alignment.centerLeft,
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      author,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class sortAndList extends StatefulWidget {
  final Function() updateParentGridList;
  final Function(String value) updateParentSorting;
  const sortAndList(
      {Key? key,
      required this.updateParentGridList,
      required this.updateParentSorting})
      : super(key: key);

  @override
  State<sortAndList> createState() => _sortAndListState();
}

class _sortAndListState extends State<sortAndList> {
  String _dropdownValue = "Recent";
  bool _tappedList = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("Sort", style: TextStyle(color: Colors.white)),
              Padding(padding: EdgeInsets.only(left: 5)),
              DropdownButton(
                dropdownColor: Colors.grey[850],
                underline: Container(
                  color: Colors.white,
                ),
                items: <String>['Recent', 'Title', 'Author']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                    widget.updateParentSorting(_dropdownValue);
                  });
                },
                value: _dropdownValue,
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          color: _tappedList ? Colors.grey : null,
          child: IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _tappedList = !_tappedList;
                widget.updateParentGridList();
              });
            },
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 35)),
      ],
    );
  }
}
