import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:vokast/models/db_model.dart';

abstract class DB {
  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      String path = p.join(databasesPath, 'RadioApp.db');
      _db = await openDatabase(path, version: _version, onCreate: onCreate);
    } catch (e) {
      print(e);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE radio (changeuuid STRING PRIMARY KEY NOT NULL, name STRING, url_resolved STRING, homepage STRING, favicon STRING)');
    await db.execute('CREATE TABLE station (changeuuid STRING PRIMARY KEY NOT NULL, isFavourite INTEGER)');
  }

static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insert(String table, DBBaseModel model) async {
    return _db!.insert(table, model.toMap());
  }
}