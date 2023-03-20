import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:vokast/models/db_model.dart';

abstract class DB {
  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async {
    print("DB init: ${_db == null}");
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      String path = p.join(databasesPath, 'radios.db');
      _db = await openDatabase(path, version: _version, onCreate: onCreate);
    } catch (e) {
      print(e);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE radio (radio_id STRING PRIMARY KEY NOT NULL, radio_name STRING, radio_url STRING, radio_image STRING, genre STRING)');
    await db.execute('CREATE TABLE radio_favorite (radio_id STRING PRIMARY KEY NOT NULL, isFavourite INTEGER)');
  }

static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insert(String table, DBBaseModel model) async {
    return _db!.insert(table, model.toMap());
  }
}