import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class MusicDatabaseHelper {
  static MusicDatabaseHelper? _musicDatabaseHelper;
  static Database? _database;

  String musicTable = 'musicTable';

  Future<Database> get database async {
    _database ??= await initialiseDatabase();
    return _database!;
  }

  Future<Database> initialiseDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$musicTable';
    print('Opening db $musicTable');

    var musicDatabase =
        await openDatabase(path, version: 1, onCreate: _createTable);

    return musicDatabase;
  }

  void _createTable(Database db, int newVersion) async {
    var query =
        'CREATE TABLE $musicTable (id STRING PRIMARY KEY, service_date STRING, serviceType String, musicType STRING, title STRING, composer STRING, link STRING)';
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
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    var result = await db.rawQuery(
        'SELECT *, DATE(service_date) as service_date_1 FROM $musicTable WHERE DATE(service_date) >= DATE($formattedDate)');
    return result;
  }

  Future<List<Map<String, dynamic>?>> getNextService() async {
    Database db = await database;
    var result = await db.rawQuery(
        'WITH nextService(service_date, serviceType) as (SELECT DISTINCT service_date, serviceType FROM $musicTable ORDER BY service_date ASC LIMIT 1) SELECT * FROM $musicTable, nextService WHERE $musicTable.service_date = nextService.service_date AND $musicTable.serviceType = nextService.serviceType');
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
