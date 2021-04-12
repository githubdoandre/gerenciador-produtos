import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "nextar.db");

    var database = await openDatabase(path,
        version: 3, onCreate: initDB, onUpgrade: onUpgrade);

    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    dropAllTables(database);
    createTables(database);
  }

  void initDB(Database database, int version) async {
    createTables(database);
  }

  Future<void> createTables(Database database) async {
    await createProductTable(database);
  }

  Future<void> dropAllTables(Database database) async {
    await database.execute('''
      DROP TABLE IF EXISTS product
      ''');
  }

  Future<void> createProductTable(Database database) async {
    await database.execute(
        'CREATE TABLE product (code INTEGER PRIMARY KEY, name TEXT, price REAL, amount REAL)');
  }
}
