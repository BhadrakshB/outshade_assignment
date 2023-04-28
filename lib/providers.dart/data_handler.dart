// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

part 'data_handler.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? gender;
  @HiveField(2)
  int? age;
  @HiveField(3)
  bool isSignedIn;
  @HiveField(4)
  String atype;
  @HiveField(5)
  int id;

  User(
      {required this.name,
      this.gender,
      this.age,
      this.isSignedIn = false,
      required this.atype,
      required this.id});

  void changeGender(String gend) {
    gender = gend;
  }

  void changeAge(int userAge) {
    age = userAge;
  }

  void changeSignIn(bool val) {
    isSignedIn = val;
  }

}


class DataHandler extends ChangeNotifier {
  DataHandler({required this.box});
  final Box<User> box;
  String dataPath = 'assets/data.json';
  List<User> userData = [];

  void fromJson() async {
    String rawData = await rootBundle.loadString(dataPath);
    List parsedData = jsonDecode(rawData);
    List users = parsedData.elementAt(0)['users'];
    for (var element in users) {
      userData.add(User(
        name: element['name'],
        id: int.parse(element['id']),
        atype: element['atype'],
      ));
    }
    box.addAll(userData);
  }

  void hive() async {
    userData = box.toMap().values.toList();

    log("values: ${box.toMap().values}");
  }

  void checkUsers() async {
    String rawData = await rootBundle.loadString(dataPath);
    List parsedData = jsonDecode(rawData);
    List users = parsedData.elementAt(0)['users'];
    List temp = box.toMap().values.toList();
    if (temp.length != users.length) {
      for (var element in userData) {}
    }
  }

  void dataParser() async {
    log(box.isEmpty.toString());
    box.isEmpty ? fromJson() : hive();
  }

  

  void signIn(User user) async {
    user.changeSignIn(true);
    int index = userData.indexWhere((element) => element.id == user.id);
    if (index >= 0) {
      userData.removeAt(index);
      userData.insert(index, user);
      
      box.putAt(index, user);
      
    }
    notifyListeners();
  }

  void signOut(User user) async {
    user.changeSignIn(false);

    int index = userData.indexWhere((element) => element.id == user.id);
    if (index >= 0) {
      userData.removeAt(index);
      userData.insert(index, user);
      box.putAt(index, user);
    }
    notifyListeners();
  }

  void getAllUsers() async {
    userData = box.toMap().values.toList();
  }
}
