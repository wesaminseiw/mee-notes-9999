import 'package:flutter/material.dart';

import '../shared/styles/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: primaryColor,),
        toolbarHeight: 70.0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          child: Text(
            "Settings",
            style: TextStyle(color: primaryColor),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(),
    );
  }
}
