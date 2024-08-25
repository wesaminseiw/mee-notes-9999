import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;

Future<void> createDatabase() async {
  // Get the path for the database file
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my_database.db');

  // Check if the database file already exists
  bool exists = await databaseExists(dbPath);
  if (exists) {
    // If the database already exists, return without creating it again
    return;
  }

  // Open the database
  Database database = await openDatabase(dbPath, version: 1,
      onCreate: (Database db, int version) async {
        // Create the table
        await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY,
        title TEXT,
        date INTEGER,
        content TEXT,
      )
    ''');
      });

  // Perform any initial data insertion or setup if needed
  // ...

  // Close the database
  await database.close();
}

Future<void> deleteItem(int id) async {
  // Get the path for the database file
  String databasesPath = await getDatabasesPath();
  String dbPath = Path.join(databasesPath, 'my_database.db');

  // Open the database
  Database database = await openDatabase(dbPath, version: 1);

  // Delete the item with the specified ID
  await database.delete('my_table', where: 'id = ?', whereArgs: [id]);

  // Close the database
  await database.close();
}

Future<List<Map<String, dynamic>>> searchByName(String query) async {
Database db = await openDatabase(query);

List<Map<String, dynamic>> results = await db.query(
'my_table',
where: 'title LIKE ?',
whereArgs: ['%$query%'],
);

await db.close();
return results;
}

