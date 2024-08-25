import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/components/components.dart';
import '../shared/styles/colors.dart';
import 'home_page.dart';

class EditNoteScreen extends StatefulWidget {
  final Database database;
  final Note? note;

  const EditNoteScreen({Key? key, required this.database, this.note}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote(context) async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;

      if (widget.note == null) {
        await widget.database.transaction((txn) async {
          await txn.rawInsert(
            'INSERT INTO notes(title, content) VALUES("$title", "$content")',
          );
        });
      } else {
        final id = widget.note!.id;
        await widget.database.transaction((txn) async {
          await txn.rawUpdate(
            'UPDATE notes SET title="$title", content="$content" WHERE id=$id',
          );
        });
      }

      Navigator.pop(context, true);
    }
  }

  void _deleteNote(context) async {
    final id = widget.note!.id;
    await widget.database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM notes WHERE id=$id');
    });
    Navigator.pop(context, true);
  }


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
          "Edit Note",
          //widget.note == null ? "Add Note" : "Edit Note",
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              child: Icon(
                Icons.delete_outline_rounded,
                color: primaryColor,
              ),
              onTap: () {
                _showDeleteDialog(context);
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        toolbarHeight: 70.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Title",
                    style: TextStyle(fontSize: 16.0, color: primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: myNormalTextFormField(
                      maxLength: 64,
                      counterText: "",
                      controller: _titleController,
                      type: TextInputType.text,
                      cursorColor: primaryColor,
                      errorStyle: TextStyle(color: primaryColor,),
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a title for your note";
                        }
                        return null;
                      }, borderType: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Content",
                    style: TextStyle(fontSize: 16.0, color: primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: myNormalTextFormField(
                          controller: _contentController,
                          type: TextInputType.multiline,
                          borderType: InputBorder.none,
                          maxLines: null,
                          cursorColor: primaryColor,
                          errorStyle: TextStyle(color: primaryColor,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        elevation: 0.0,
        highlightElevation: 0.0,
        focusElevation: 0.0,
        disabledElevation: 0.0,
        hoverElevation: 0.0,
        child: const Icon(Icons.check_rounded, color: Colors.white,),
        onPressed: () {
          _saveNote(context);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteNote(context); // Call the delete function
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.grey[100];
                      return null;
                    }
                ),
              ),
              child: Text(
                "Delete",
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.grey[100];
                      return null;
                    }
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}