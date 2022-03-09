/**
Page Author: Karan Swatch
*/

//TODO: fix styling everywhere
// fix top two buttons to not be expanded
// link to other pages
// add sort functionality
// bottom nav bar?
// pulling real data from phone
// how will "new" stuff work
// if time change list and grid view to rearrangleable version for manually sort

import 'package:flutter/material.dart';
//TODO: CHANGE DIS
import 'attractions.dart';

class library_page extends StatefulWidget {
  @override
  State<library_page> createState() => _library_pageState();
}

class _library_pageState extends State<library_page> {
  bool _tappedList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Library",
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          sortAndList(
            updateParent: refresh,
          ),
          Expanded(child: _tappedList ? BooksListView() : BooksGridView()),
        ],
      ),
    );
  }

  refresh() {
    setState(() {
      _tappedList = !_tappedList;
    });
  }
}

class BooksGridView extends StatefulWidget {
  @override
  State<BooksGridView> createState() => _BooksGridViewState();
}

class _BooksGridViewState extends State<BooksGridView> {
  @override
  Widget build(BuildContext context) {
    // TODO: CHANGE DIS
    List books = dummy_data;
    return GridView.count(
      crossAxisCount: 2,
      children: [
        for (int i = 0; i < books.length; i++)
          SingleBookGridView(books[i]['image'])
      ],
    );
  }

  Widget SingleBookGridView(String url) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Expanded(
            child: Card(
              child: Image.network(
                url,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text("New"),
        ],
      ),
    );
  }
}

class BooksListView extends StatefulWidget {
  @override
  State<BooksListView> createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  @override
  Widget build(BuildContext context) {
    // TODO: CHANGE DIS
    List books = dummy_data;
    return ListView(
      children: [
        for (int i = 0; i < books.length; i++)
          SingleBookListView(
              books[i]['image'], books[i]['author'], books[i]['title'])
      ],
    );
  }

  Widget SingleBookListView(String url, String author, String title) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Image.network(
              url,
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
              height: 100,
              width: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                Text(author),
                Text("new"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class sortAndList extends StatefulWidget {
  final Function() updateParent;
  const sortAndList({Key? key, required this.updateParent}) : super(key: key);

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
              Text("Sort"),
              DropdownButton(
                items: <String>['Recent', 'Title', 'Author']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
                value: _dropdownValue,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: _tappedList ? Colors.grey : null,
            child: IconButton(
              icon: Icon(
                Icons.list,
              ),
              onPressed: () {
                setState(() {
                  _tappedList = !_tappedList;
                  widget.updateParent();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
