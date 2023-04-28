import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:outshade_assignment/pages.dart/user_data_promt_page.dart';
import 'package:outshade_assignment/providers.dart/data_handler.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    
    context.read<DataHandler>().dataParser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: context.watch<DataHandler>().userData.length,
        itemBuilder: (context, index) {
          User currentUser =
              context.watch<DataHandler>().userData.elementAt(index);

          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Material(
                      child: UserDataPromptDialog(user: currentUser))));
            },
            title: Text(currentUser.name),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      currentUser.isSignedIn ? Colors.red : Colors.blue),
              child: Text(currentUser.isSignedIn ? "Sign In" : "Sign Up"),
              onPressed: currentUser.age == null && currentUser.gender == null
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Material(
                            child: UserDataPromptDialog(user: currentUser),
                          );
                        },
                      );
                    }
                  : currentUser.isSignedIn
                      ? () {
                          context.read<DataHandler>().signOut(currentUser);
                        }
                      : () {
                        context.read<DataHandler>().signIn(currentUser);
                      },
            ),
          );
        },
      ),
    );
  }
}
