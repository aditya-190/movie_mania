import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/model.dart';

class SQLHelper {
  static const String TABLE_MOVIE = "movie";
  static const String COLUMN_ID = "movieID";
  static const String COLUMN_NAME = "movieName";
  static const String COLUMN_DIRECTOR = "movieDirector";
  static const String COLUMN_IMAGE = "movieImageUrl";

  SQLHelper._();

  static final SQLHelper db = SQLHelper._();
  Database _database;

  Future<Database> get database async {
    print("Aditya: database getter called");

    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'tanu.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Aditya: Creating table");

        await database.execute(
          "CREATE TABLE $TABLE_MOVIE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_DIRECTOR TEXT,"
          "$COLUMN_IMAGE TEXT"
          ")",
        );

        await database.insert(
          TABLE_MOVIE,
          Movies(0, "Nature", "MS Dhoni",
                  "https://images.unsplash.com/photo-1628810786231-3bbda71718d9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80")
              .toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
    );
  }

  Future fetchAllMovies() async {
    final db = await database;
    var movies = await db.query(TABLE_MOVIE,
        columns: [COLUMN_ID, COLUMN_NAME, COLUMN_DIRECTOR, COLUMN_IMAGE]);

    print("Aditya: Movie List $movies");
    return movies.toList();
  }

  Future<void> addMovies(Movies movies) async {
    final db = await database;

    print("Aditya: Movie Item to Add: ${movies.movieName}");

    return await db.insert(
      TABLE_MOVIE,
      movies.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> editMovie(Movies movies) async {
    final db = await database;

    print("Aditya: Movie Item to Edit: ${movies.movieName}");

    return await db.update(
      TABLE_MOVIE,
      movies.toMap(),
      where: 'movieID = ?',
      whereArgs: [movies.movieID],
    );
  }

  Future<void> deleteMovie(int id) async {
    final db = await database;

    print("Aditya: Movie Item to Delete: $id");

    return await db.delete(
      TABLE_MOVIE,
      where: 'movieID = ?',
      whereArgs: [id],
    );
  }
}
