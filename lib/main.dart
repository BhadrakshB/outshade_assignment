import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:outshade_assignment/providers.dart/data_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'pages.dart/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory root = await getApplicationDocumentsDirectory();
  String directoryPath = root.path + '/user/data';
  await Hive.initFlutter(directoryPath);
  Hive.registerAdapter(UserAdapter());
  Box<User> box = await Hive.openBox('usersStates');

  runApp(MyApp(
    box: box,
  ));
}

class MyApp extends StatelessWidget {
  final Box<User> box;
  const MyApp({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataHandler(box: box),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'main_page',
        routes: {
          'main_page': (context) => const MainPage(),
        },
      ),
    );
  }
}
