import 'dart:io';
import 'dart:convert';
import 'constants.dart';
import 'package:path_provider/path_provider.dart';


Future<List> getUserData() async {
  String appDocumDirPath = await getADDPath();
  String wholePath = '$appDocumDirPath/$PATH_NAME_USER_DATA';
  bool isExists = await File(wholePath).exists();

  if( isExists ){
    String readData = await readFile(wholePath);
    return json.decode(readData);
  } else {
    return [];
  }
}

void createUserData(data) async {
  String appDocumDirPath = await getADDPath();
  String wholePath = '$appDocumDirPath/$PATH_NAME_USER_DATA';
  writeFile(wholePath, json.encode(data));
}

Future<String> getADDPath() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  return appDocPath;
}

void writeFile(path, data) {
  var file = File(path);
  var sink = file.openWrite();
  sink.write(data);
  sink.close();
}

Future<String> readFile(path) async {
  var file = File(path);
  return await file.readAsString();
}
