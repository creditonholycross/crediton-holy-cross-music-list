import 'package:flutter_cpc_music_list/helper/catalogueDatabase.dart';
import 'package:flutter_cpc_music_list/helper/database.dart';
import 'package:flutter_cpc_music_list/helper/fetchMusic.dart';
import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:flutter_cpc_music_list/models/service.dart';

class DbFunctions {
  Future addMusic(Music music) async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    await dbHelper.insertMusic(music);
  }

  Future addMultipleMusic(List<Music> musicList) async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    for (var music in musicList) {
      await dbHelper.insertMusic(music);
    }
  }

  Future<List<Service>?> getServiceList() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    var result = await dbHelper.getServiceList();
    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();
    return groupMusic(musicList);
  }

  Future<Service?> getNextService() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    final result = await dbHelper.getNextService();
    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();
    return groupMusic(musicList).first;
  }

  Future deleteAllMusic() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    await dbHelper.deleteAllMusic();
  }

  Future addCatalogue(List<Catalogue> catalogueList) async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    for (var music in catalogueList) {
      await dbHelper.insertMusic(music);
    }
  }

  Future<int?> getCatalogueCount() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    final result = await dbHelper.getCount();
    return result;
  }

  Future<List<Catalogue>?> getCatalogue() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    final result = await dbHelper.getCatalogue();
    if (result.isEmpty) {
      return null;
    }
    var catalogue = result.map((e) => Catalogue.fromDb(e)).toList();
    return catalogue;
  }

  Future deleteCatalogue() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    await dbHelper.deleteCatalogue();
  }
}
