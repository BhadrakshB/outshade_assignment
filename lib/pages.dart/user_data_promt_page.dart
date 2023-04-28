// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart/data_handler.dart';

class UserDataPromptDialog extends StatefulWidget {
  User user;
  UserDataPromptDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserDataPromptDialog> createState() => _UserDataPromptDialogState();
}

class _UserDataPromptDialogState extends State<UserDataPromptDialog> {
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Male';

  @override
  Widget build(BuildContext context) {
   return widget.user.age != null && widget.user.gender !=null ? Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.user.name,
          ),
          Text(
            widget.user.age.toString(),
          ),
          Text(widget.user.gender ?? 'Null'),

        ]
            .map((e) =>
                Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: e))
            .toList(),
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.user.name,
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text("Age")),
          ),
          DropdownButton(
              value: dropdownValue,
              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text("Female"),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Text("Other"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              }),
          ElevatedButton(
              onPressed: () {
                widget.user.changeAge(int.parse(ageController.text));
                widget.user.changeGender(dropdownValue);
                context.read<DataHandler>().signIn(widget.user);
                Navigator.of(context).pop();
              },
              child: Text("Submit")),
        ]
            .map((e) =>
                Padding(padding: EdgeInsets.symmetric(vertical: 20), child: e))
            .toList(),
      ),
    );
  }
}

