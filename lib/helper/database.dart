import 'package:flutter/material.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MusicDatabaseHelper {
  static MusicDatabaseHelper? _musicDatabaseHelper;
  static Database? _database;

  String musicTable = 'musicTable';

  Future<Database> get database async {
    _database ??= await initialiseDatabase();
    return _database!;
  }

  Future<Database> initialiseDatabase() async {
    var path = "";
    if (!kIsWeb) {
      final databasePath = await getDatabasesPath();
      path = '$databasePath/$musicTable';
    } else {
      path = '/db/path/$musicTable';
    }
    print('Opening db $musicTable');

    var musicDatabase =
        await openDatabase(path, version: 1, onCreate: _createTable);

    return musicDatabase;
  }

  void _createTable(Database db, int newVersion) async {
    var query =
        'CREATE TABLE $musicTable (id STRING PRIMARY KEY, service_date INT, service_time INT, serviceType String, musicType STRING, title STRING, composer STRING, link STRING)';
    print('Executing query $query');
    await db.execute(query);
    print('Table created');
  }

  Future<int> insertMusic(Music music) async {
    Database db = await database;
    var result = await db.insert(musicTable, music.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getServiceList() async {
    Database db = await database;
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    var timeFormatter = DateFormat('HHmmss');
    String formattedTime = timeFormatter.format(now);

    List<Map<String, dynamic>>? result;

    if (kIsWeb) {
      result = await db.rawQuery(
          'SELECT *, service_date FROM $musicTable WHERE CAST(service_date as integer) >= $formattedDate ORDER BY service_date');
    } else {
      result = await db.rawQuery(
          'SELECT *, service_date FROM $musicTable WHERE CAST(service_datetime as integer) >= $formattedDate ORDER BY service_date');
    }
    // var result = await db.rawQuery(
    //     'SELECT *, service_date || substr("000000"||service_time, -6, 6)  as service_datetime FROM $musicTable ORDER BY service_date');
    return result;
  }

  Future<List<Map<String, dynamic>?>> getNextService() async {
    Database db = await database;
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    var timeFormatter = DateFormat('HHmmss');
    String formattedTime = timeFormatter.format(now);

    List<Map<String, dynamic>>? result;

    if (kIsWeb) {
      result = await db.rawQuery(
          'WITH nextService(serviceType, service_date) as (SELECT DISTINCT serviceType, service_date FROM $musicTable WHERE CAST(service_date as integer) >= $formattedDate ORDER BY service_date ASC LIMIT 1) SELECT * FROM $musicTable, nextService WHERE $musicTable.service_date = nextService.service_date AND $musicTable.serviceType = nextService.serviceType');
    } else {
      result = await db.rawQuery(
          'WITH nextService(serviceType, service_date, service_time, service_datetime) as (SELECT DISTINCT serviceType, service_date, service_time, service_date || substr("000000"||service_time, -6, 6) as service_datetime FROM $musicTable WHERE CAST(service_datetime as integer) >= $formattedDate$formattedTime ORDER BY service_date, service_time ASC LIMIT 1) SELECT * FROM $musicTable, nextService WHERE $musicTable.service_date = nextService.service_date AND $musicTable.serviceType = nextService.serviceType');
    }

    if (result.isEmpty) {
      return List.empty();
    }
    return result;
  }

  Future<int> deleteAllMusic() async {
    Database db = await database;
    var result = await db.delete(musicTable);
    return result;
  }
}
