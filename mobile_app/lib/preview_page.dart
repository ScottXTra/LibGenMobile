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

// grey out the button when its already in the directory they are trying to reach
// need to account for epub files when the button is then changed to "open here"

/** 
 * DUMMY DATA : List Dummy_data
 * 
 */
List dummy_data = [
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/918s2eM4pSL.jpg",
    "author": "Rick Riordan",
    "title": "The Last Olympian",
    "file":
        "http://31.42.184.140/main/480000/cdd04c59e2f8e0f34488ca3dc4278ede/%28Percy%20Jackson%20and%20the%20Olympians%205%29%20Rick%20Riordan%20-%20The%20Last%20Olympian%20%28Percy%20Jackson%20%26%20the%20Olympians%2C%20Book%205%29-Disney%20Hyperion%20Books%20for%20Children%20%282009%29.pdf"
  },
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/91RQ5d-eIqL.jpg",
    "author": "Rick Riordan",
    "title": "The Lightning Thief",
    "file":
        "http://31.42.184.140/main/737000/3cf9de57b22129d085748d6169787b0e/Rick%20Riordan%20-%20The%20Lightning%20Thief%20%28Percy%20Jackson%20and%20the%20Olympians%2C%20Book%201%29%20%20-Disney-Hyperion%20%282005%29.epub"
  },
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/9117OFw0G4L.jpg",
    "author": "Rick Riordan",
    "title": "The Sea of Monsters",
    "file":
        "http://31.42.184.140/main/773000/cc8bdd3cf019c5267d33c9eb68ac56a2/%28Percy%20Jackson%20%26%20the%20Olympians%202%29%20Rick%20Riordan%20-%20The%20Sea%20of%20Monsters%20%20-Disney-Hyperion%20%282006%29.epub"
  },
];

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
class Preview_page extends StatefulWidget {
  @override
  State<Preview_page> createState() => _Preview_page();
}

class Library_button extends StatefulWidget {
  final int index;
  final Function libraryCallback;
  final List<bool> buttonStates;
  Library_button({required this.index, required this.libraryCallback, required this.buttonStates});

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
    // blockButton = widget.buttonStates[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doesFileExist(widget.index),
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
              /** Check first if the file we are working with already exists */
              // bool doesFileExixt = await doesFileExist(widget.index);

              String downloadLink = dummy_data[widget.index]["file"];
              String extension = "." + dummy_data[widget.index]["file"].split(".").last;
              String fullFileName = dummy_data[widget.index]["title"] + "_" + dummy_data[widget.index]["author"] + extension;
              Directory destinationDirect = await getApplicationDocumentsDirectory();
              String stringDestinationDirect = destinationDirect.path;

              if (doesFileExixt == false) {
                /** downloadlink : represents link to download the pdf, extension: the extension of the file, 
                                   * destinationDirect : the path to store into the local storage
                                   */
                downloadFile(downloadLink, fullFileName, stringDestinationDirect);

                Map<String, dynamic> singleMap = {
                  "title": dummy_data[widget.index]["title"],
                  "author": dummy_data[widget.index]["author"],
                  "image": dummy_data[widget.index]["image"],
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

/*This class will generate horizontal cards that can 
be scrolled on either direction based on length of 
the previous search results */
class _Preview_page extends State<Preview_page> {
  /** Temporary styles using here for now, can be moved somewhere else later */
  titles() => const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
  info() => const TextStyle(fontSize: 14, color: Colors.red);

  List<bool> individualButtons = List.filled(dummy_data.length, false);

  /** This is a callback function thats sent to the buttons to 
   * reflect a change in the array
   */
  void changeMainArray(bool changeBool, int index) {
    setState(() {
      individualButtons[index] = changeBool;
    });
  }

  /** This is a function that will check our local storage for files to create an intiail state for  
    * the buttons at the start : without using Future Builder  true = view, false = add to the library
   */
  void setButtonDefault(List<bool> initialList) async {
    bool fileExistence = false;
    List<bool> returnList = List.filled(dummy_data.length, false);
    for (int i = 0; i < dummy_data.length; i++) {
      fileExistence = await doesFileExist(i);
      if (fileExistence == true) {
        //If a file here exists then it means we only need to show a view of it
        debugPrint("***************** Current file existence is $fileExistence");
        returnList[i] = true;
      }
    }

    /** copy this list into the state variable that we have*/
    setState(() {
      individualButtons = List.from(returnList);
    });
  }

  @override
  void initState() {
    super.initState();
    setButtonDefault(individualButtons);
  }

  @override
  Widget build(BuildContext context) {
    /** Grab any accurate device dimensions */
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
            itemCount: dummy_data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
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
                            child: SimpleShadow(
                                opacity: 0.1,
                                color: Colors.white,
                                offset: const Offset(5, 5),
                                sigma: 10,
                                child: Image.network(dummy_data[index]["image"], width: 250, height: 450))),
                        /*Any further  information regarding the author*/
                        Column(
                          children: [
                            Text(dummy_data[index]["title"], style: titles()),
                            Container(height: 10),
                            Text(
                              dummy_data[index]["author"],
                              style: info(),
                            ),
                            Container(height: 25),

                            /* Container responsible for the elevated button*/
                            Container(
                                padding: const EdgeInsets.only(bottom: 30),
                                width: width - 30,
                                height: 80,
                                child: Library_button(
                                  index: index,
                                  libraryCallback: changeMainArray,
                                  buttonStates: individualButtons,
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
Future<bool> doesFileExist(int index) async {
  Directory destinationDirectory = await (getApplicationDocumentsDirectory());
  String dest = destinationDirectory.path;

  String extension = "." + dummy_data[index]["file"].split(".").last;
  String fullPath = dest + "/" + dummy_data[index]["title"] + "_" + dummy_data[index]["author"] + extension; //file to be located is formed

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
