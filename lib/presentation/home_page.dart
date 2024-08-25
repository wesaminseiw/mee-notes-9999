import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:mee_notes/presentation/settings_screen.dart';
import 'package:mee_notes/shared/components/components.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../shared/styles/colors.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class Note {
  final int id;
  final String title;
  final String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database _database;
  List<Note> _notes = [];
  final List<Note> _pinnedNotes = [];
  bool contentIsShown = true;

  @override
  void initState() {
    super.initState();
    _openDatabase().then((value) {
      _loadNotes();
    });
  }

  Future<void> _openDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertNote(String title, String content) async {
    await _database.insert(
      'notes',
      {
        'title': title,
        'content': content,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> _getNotes() async {
    final List<Map<String, dynamic>> maps = await _database.query('notes');
    return List.generate(
      maps.length,
      (i) => Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
      ),
    );
  }

  Future<void> _loadNotes() async {
    final notes = await _getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddNoteScreen(database: _database),
      ),
    );
    if (result != null && result) {
      _loadNotes();
    }
  }

  void navigateToEditScreen(BuildContext context, {Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            EditNoteScreen(database: _database, note: note),
      ),
    );
    if (result != null && result) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          child: Text(
            "MeeNotes",
            style: TextStyle(color: primaryColor),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: InkWell(
              child: Icon(
                Icons.settings,
                color: primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: _notes.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 200.0,
                      height: 200.0,
                      child: Image(
                        image: AssetImage("assets/images/icon.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "You don't have any notes yet.",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: contentIsShown
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              note.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              note.content,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey[500]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0, 0, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          navigateToEditScreen(context,
                                              note: note);
                                        },
                                        child: Icon(Icons.edit,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              note.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0, 0, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          navigateToEditScreen(context,
                                              note: note);
                                        },
                                        child: Icon(Icons.edit,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15.0,
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          navigateToAddScreen(context);
        },
      ),
    );
  }
}
