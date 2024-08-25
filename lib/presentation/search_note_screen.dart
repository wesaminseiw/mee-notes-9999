import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/components/components.dart';
import '../shared/styles/colors.dart';
import 'home_page.dart';

class SearchNoteScreen extends StatefulWidget {
  const SearchNoteScreen({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<SearchNoteScreen> createState() => _SearchNoteScreenState();
}

late Database database;
late Note? note;


class _SearchNoteScreenState extends State<SearchNoteScreen> {

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
        ),
        title: Text(
          "Search Note",
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70.0,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: mySearchFormField(
                  borderType: InputBorder.none,
                  type: TextInputType.text,
                  controller: searchController,
                  onChanged: () {},
                  label: "Search by name...",
                  labelColor: primaryColor,
                  cursorColor: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
