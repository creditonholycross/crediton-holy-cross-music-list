import 'package:csv/csv.dart';
import 'package:flutter_cpc_music_list/helper/dbFunctions.dart';
import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:flutter_cpc_music_list/models/service.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";

var catalogueLink =
    'https://docs.google.com/spreadsheets/d/1Re82nHjPfZdGTDCeb88xeXOSXZFfK3x4oPe5fkxmb_o/gviz/tq?tqx=out:csv&sheet=sheet1';

Future<void> fetchCatalogue() async {
  final count = await DbFunctions().getCatalogueCount();
  if (count == 0) {
    print('fetching catalogue');
    updateCatalogueDb();
  }
  // return await DbFunctions().getCatalogue();
}

void updateCatalogueDb() async {
  print('updating db');
  final response = await http.get((Uri.parse(catalogueLink)));
  if (response.statusCode == 200) {
    var parsedCatalogue = parseCsv(response.body);
    if (parsedCatalogue.isEmpty) {
      return null;
    }
    await DbFunctions().deleteCatalogue();
    await DbFunctions().addCatalogue(parsedCatalogue);
  } else {
    throw Exception('Failed to load music.');
  }
}

List<Catalogue> parseCsv(String csv) {
  List<List<dynamic>> parsedList =
      const CsvToListConverter().convert(csv, eol: '\n');
  final keys = parsedList.first;

  var mappedList =
      parsedList.skip(1).map((v) => Map.fromIterables(keys, v)).toList();

  var catalogueList = mappedList.map((e) => Catalogue.fromCsv(e)).toList();

  return catalogueList;
}

List<Service> groupMusic(List<Music> musicList) {
  var newMap = groupBy(musicList, (item) => '${item.date},${item.serviceType}');

  var serviceList = <Service>[];

  newMap.forEach((k, v) => serviceList.add(
      Service(date: k.split(',')[0], serviceType: k.split(',')[1], music: v)));
  return serviceList;
}
