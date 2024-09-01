import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:sqflite/sqflite.dart';

class CatalogueDatabaseHelper {
  static CatalogueDatabaseHelper? _catalogueDatabaseHelper;
  static Database? _database;

  String catalogueTable = 'catalogueTable';

  Future<Database> get database async {
    _database ??= await initialiseDatabase();
    return _database!;
  }

  Future<Database> initialiseDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$catalogueTable';
    print('Opening db $catalogueTable');

    var catalogueDatabase =
        await openDatabase(path, version: 1, onCreate: _createTable);

    return catalogueDatabase;
  }

  void _createTable(Database db, int newVersion) async {
    var query =
        'CREATE TABLE $catalogueTable (id STRING PRIMARY KEY, composer STRING, title String, parts STRING, publisher STRING, season STRING)';
    print('Executing query $query');
    await db.execute(query);
    print('Table created');
  }

  Future<int> insertMusic(Catalogue catalogue) async {
    Database db = await database;
    var result = await db.insert(catalogueTable, catalogue.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getCatalogue() async {
    Database db = await database;
    var result = await db
        .rawQuery('SELECT * FROM $catalogueTable ORDER BY composer, title');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await database;
    var result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $catalogueTable'));
    return result;
  }

  Future<int> deleteCatalogue() async {
    Database db = await database;
    var result = await db.delete(catalogueTable);
    return result;
  }
}
