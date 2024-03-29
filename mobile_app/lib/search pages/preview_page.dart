import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'dart:convert';
import 'dart:developer';
import 'bookSearch_page.dart';
import 'package:http/http.dart' as http;

// grey out the button when its already in the directory they are trying to reach
// need to account for epub files when the button is then changed to "open here"

/** These functions correlate to the async for accessing the phones local storage */
Future<String> downloadFile(String url, String fileName, String dir) async {
  HttpClient httpClient = new HttpClient();
  File file;
  String filePath = '';
  String myUrl = '';

  /** This will actually already create the link with directory seperations, 
     * so no need to pass that in the parameters 
     */
  try {
    myUrl = url;
    var request = await httpClient.getUrl(Uri.parse(myUrl));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else
      filePath = 'Error code: ' + response.statusCode.toString();
  } catch (ex) {
    filePath = 'Can not fetch url';
  }

  return filePath;
}

/** 
Page Author: Maaz Syed
*/

class Library_button extends StatefulWidget {
  final int index;
  final List<BookData> searchResults;
  final List<dynamic> additionalJSON;
  Library_button({required this.index, required this.searchResults, required this.additionalJSON});

  @override
  State<Library_button> createState() => _Library_button();
}

/** Each button will have its own state here */
class _Library_button extends State<Library_button> {
  bool doesFileExixt = false;
  bool downloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doesFileExist(widget.index, widget.searchResults, widget.additionalJSON),
        builder: (context, data) {
          if (!data.hasData || data.connectionState == ConnectionState.waiting) {
            return SizedBox(height: 100, width: 100, child: Center(child: CircularProgressIndicator(color: Colors.red)));
          }
          doesFileExixt = data.data as bool;
          if (downloading && !doesFileExixt) {
            WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
                  if (downloading && doesFileExixt) downloading = false;
                }));
            return SizedBox(height: 100, width: 100, child: Center(child: CircularProgressIndicator(color: Colors.red)));
          }
          if (doesFileExixt && downloading) {
            downloading = false;
          }
          return ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    doesFileExixt ? MaterialStateProperty.all(Colors.grey[700]) : MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
            onPressed: () async {
              String downloadLink = widget.additionalJSON[widget.index]["direct_url"];
              String extension = "." + widget.additionalJSON[widget.index]["direct_url"].split(".").last;
              String fullFileName = widget.searchResults[widget.index].title + "_" + widget.searchResults[widget.index].author + extension;
              Directory destinationDirect = await getApplicationDocumentsDirectory();
              String stringDestinationDirect = destinationDirect.path;

              if (doesFileExixt == false) {
                /** downloadlink : represents link to download the pdf, extension: the extension of the file, 
                                   * destinationDirect : the path to store into the local storage
                                   */
                downloadFile(downloadLink, fullFileName, stringDestinationDirect);

                Map<String, dynamic> singleMap = {
                  "title": widget.searchResults[widget.index].title,
                  "author": widget.searchResults[widget.index].author,
                  "image": widget.additionalJSON[widget.index]["cover_image"],
                  "file": fullFileName,
                  "recent": DateTime.now().toUtc().millisecondsSinceEpoch
                };

                /**If json exists overwrite by getting data from the file otherwise create the file and initial data */
                if (await File(stringDestinationDirect + "/" + "local_storage.json").exists()) {
                  writeToFile(singleMap, stringDestinationDirect);
                } else {
                  createFile(singleMap, stringDestinationDirect);
                }
                setState(() {
                  downloading = true;
                });
              } else {
                /*Since the file already exists here update the state */
                /*For viewing we want to view it a differnent way for epubs */
                String openFile = stringDestinationDirect + "/" + fullFileName;
                if (extension == ".pdf") {
                  await OpenFile.open(openFile);
                } else {
                  EpubViewer.setConfig(
                    themeColor: Theme.of(context).primaryColor,
                    identifier: "iosbook",
                    scrollDirection: EpubScrollDirection.VERTICAL,
                    allowSharing: true,
                    enableTts: true,
                  );
                  EpubViewer.open(openFile);
                }
                setState(() {
                  downloading = false;
                });
              }
              /** Once we set the state here we will change it so that once 
         * its passed in again 
        */
              // widget.libraryCallback(blockButton, widget.index);
            },
            child: doesFileExixt ? Text("View File") : Text("Add to library"),
          );
        });
  }
}

class Preview_page extends StatefulWidget {
  final List<BookData> searchResults;
  final int index;
  Preview_page({required this.searchResults, required this.index});

  @override
  State<Preview_page> createState() => _Preview_page();
}

/*This class will generate horizontal cards that can 
be scrolled on either direction based on length of 
the previous search results */
class _Preview_page extends State<Preview_page> {
  /** Temporary styles using here for now, can be moved somewhere else later */
  titles() => const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white);
  info() => const TextStyle(fontSize: 14, color: Colors.red);
  sub_info() => const TextStyle(fontSize: 12, color: Colors.white);
  List<dynamic> additionalJSON = [];
  bool isLoading = false;

  /** This is a function that will check our local storage for files to create an intiail state for  
    * the buttons at the start : without using Future Builder  true = view, false = add to the library
   */
  void setButtonDefault(List<BookData> searchResults) async {
    Map<String, dynamic> localMap = {};
    List<dynamic> additionalData = [];
    String url = "http://192.168.73.170/get_download_links?mirror=";

    for (int i = 0; i < widget.searchResults.length; i++) {
      try {
        /** Request the image here and the download link via a different endpoint using mirror_url */
        setState(() {
          isLoading = true;
        });
        final response = await http.get(Uri.parse(url + widget.searchResults[i].mirror_url));
        if (response.statusCode == 200) {
          localMap = jsonDecode(response.body);
          additionalData.add(localMap);
        } else {
          throw Exception('Error');
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    // bool fileExistence = false;
    // List<bool> returnList = List.filled(searchResults.length, false);
    // for (int i = 0; i < searchResults.length; i++) {
    //   fileExistence = await doesFileExist(i, searchResults, additionalData);
    //   if (fileExistence == true) {
    //     //If a file here exists then it means we only need to show a view of it
    //     debugPrint("***************** Current file existence is $fileExistence");
    //     returnList[i] = true;
    //   }
    // }

    /** copy this list into the state variable that we have*/
    setState(() {
      additionalJSON = List.from(additionalData);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setButtonDefault(widget.searchResults);
  }

  /** Checks the value of all 3 and only displays publisher. year and page count if it's there */
  bool isSubInfoNull(String publisher, String year, String pageCount) {
    if (publisher.isEmpty == true || year.isEmpty == true || pageCount.isEmpty == true) {
      return true;
    }
    return false;
  }

  _horizontalDivider(double width) {
    return Container(
      height: 2,
      width: width - 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
          color: Colors.white.withOpacity(0.15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    /** Grab any accurate device dimensions */
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final controller = PageController(initialPage: widget.index);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black.withOpacity(0.90),
        ),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        /** We want to have cards that can be scrolled horizontally 
         * while allowing the user to snap the card in place
        */
        body: PageView.builder(
            controller: controller,
            itemCount: widget.searchResults.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              /** The sub information, displayed if present*/
              String publisher = widget.searchResults[index].publisher.toString();
              String year = widget.searchResults[index].year.toString();
              String pageCount = widget.searchResults[index].page_count.toString();
              bool isContentNull = isSubInfoNull(publisher, year, pageCount);

              return Container(
                height: height,
                width: width,
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Colors.grey[850],
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      children: [
                        /*X icon on the top right of the card */
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 10.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.cancel, color: Colors.grey[400]))),
                        ),
                        /* The main image for the book*/
                        Align(
                            alignment: Alignment.topCenter,
                            child: isLoading
                                ? SizedBox(height: 100, width: 100, child: Center(child: CircularProgressIndicator(color: Colors.red)))
                                : SimpleShadow(
                                    opacity: 0.1,
                                    color: Colors.white,
                                    offset: const Offset(5, 5),
                                    sigma: 10,
                                    child: Image.network(additionalJSON[index]["cover_image"], width: 250, height: 450))),
                        /*Any further  information regarding the author*/
                        Column(
                          children: [
                            Text(widget.searchResults[index].title, textAlign: TextAlign.center, style: titles()),
                            Container(height: 10),
                            Text(
                              widget.searchResults[index].author,
                              style: info(),
                              textAlign: TextAlign.center,
                            ),
                            Container(height: isContentNull ? 0 : 15),
                            isSubInfoNull(publisher, year, pageCount) ? Container(height: 0) : _horizontalDivider(width),
                            Container(height: isContentNull ? 0 : 15),

                            /** The sub info text */
                            isContentNull
                                ? Container(height: 0)
                                : Text("publisher: " + widget.searchResults[index].publisher.toString(),
                                    textAlign: TextAlign.center, style: sub_info()),
                            isContentNull
                                ? Container(height: 0)
                                : Text("year: " + widget.searchResults[index].year.toString(),
                                    textAlign: TextAlign.center, style: sub_info()),
                            isContentNull
                                ? Container(height: 0)
                                : Text("page count: " + widget.searchResults[index].page_count.toString(),
                                    textAlign: TextAlign.center, style: sub_info()),
                            Container(height: isContentNull ? 0 : 15),
                            isSubInfoNull(publisher, year, pageCount) ? Container(height: 0) : _horizontalDivider(width),
                            Container(height: 25),

                            /* Container responsible for the elevated button*/
                            Container(
                                padding: const EdgeInsets.only(bottom: 30),
                                width: width - 30,
                                height: 80,
                                child: Library_button(
                                  index: index,
                                  searchResults: widget.searchResults,
                                  additionalJSON: additionalJSON,
                                )),
                            Container(height: 50)
                          ],
                        ),
                      ],
                    )),
              );
            }));
  }
}

/*Function returns the full path to the file, and where its located within the local storage */
Future<bool> doesFileExist(int index, List<BookData> searchResults, List<dynamic> additionalJSON) async {
  Directory destinationDirectory = await (getApplicationDocumentsDirectory());
  String dest = destinationDirectory.path;

  String extension = "." + additionalJSON[index]["direct_url"].split(".").last;
  String fullPath = dest + "/" + searchResults[index].title + "_" + searchResults[index].author + extension; //file to be located is formed

  /** Check if this file currently exists in the local storage */
  if (await File(fullPath).exists()) {
    return true;
  }

  return false;
}

/** Following functions involve functions that allow you to write to a json file */
void createFile(Map<String, dynamic> element, String directory) {
  List<dynamic> content = [];
  File jsonFile = new File(directory + "/" + "local_storage.json");
  jsonFile.createSync(); //for some null protection
  content.add(element);
  jsonFile.writeAsStringSync(jsonEncode(content)); //writes to the file synchronously and overwrites the data
}

void writeToFile(Map<String, dynamic> element, String directory) {
  File jsonFile = File(directory + "/" + "local_storage.json");

  /** Before we write to the file we need to see what we currently have in it */
  List<dynamic> jsonFileContent = jsonDecode(jsonFile.readAsStringSync());
  jsonFileContent.add(element);

  /** This is what we are essentially appening and overwriting with */
  jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
}
