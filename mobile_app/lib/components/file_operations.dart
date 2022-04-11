import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'bookdata.dart';
import 'package:path_provider/path_provider.dart';

class FileOperations {
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
}
