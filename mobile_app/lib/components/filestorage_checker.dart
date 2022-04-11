import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'bookdata.dart';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  Future<bool> doesFileExist(int index, List<BookData> searchResults, List<dynamic> additionalJSON) async {
    Directory destinationDirectory = await (getApplicationDocumentsDirectory());
    String dest = destinationDirectory.path;

    String extension = "." + additionalJSON[index]["direct_url"].split(".").last;
    String fullPath =
        dest + "/" + searchResults[index].title + "_" + searchResults[index].author + extension; //file to be located is formed

    /** Check if this file currently exists in the local storage */
    if (await File(fullPath).exists()) {
      return true;
    }

    return false;
  }
}
