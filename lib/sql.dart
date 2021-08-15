import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

class SQLHelper {
  static final _dbName = "Database.db";

  SQLHelper._privateConstructor();

  static final SQLHelper instance = SQLHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
          CREATE TABLE MOVIES (
            movieID TEXT PRIMARY KEY AUTOINCREMENT,
            movieName TEXT,
            movieDirector TEXT,
            movieImageUrl TEXT
          )
          ''');
  }

  Future<List<Movies>> fetchAllMovies() async {
    Database database = _database;
    List<Map<String, dynamic>> maps = await database.query('Movies');
    if (maps.isNotEmpty) {
      return maps.map((map) => Movies.fromDbMap(map)).toList();
    }
    return null;
  }

  Future<int> addMovies(Movies movie) async {
    Database database = _database;
    return database.insert(
      'Movies',
      movie.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMovie(Movies movie) async {
    Database database = _database;
    return database.update(
      'Movies',
      movie.toDbMap(),
      where: 'id = ?',
      whereArgs: [movie.movieID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteMovie(String id) async {
    Database database = _database;
    return database.delete(
      'Movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
