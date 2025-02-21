import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cpc_music_list/helper/dbFunctions.dart';
import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:flutter_cpc_music_list/models/service.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";

var catalogueLink =
    'https://docs.google.com/spreadsheets/d/1VwqZ7_RjaS58UwxXzdzG6TeZtXDPLdj0N3t894Sm_iQ/gviz/tq?tqx=out:csv&sheet=sheet1';

Future<void> fetchCatalogue() async {
  final count = await DbFunctions().getCatalogueCount();
  if (count == 0) {
    print('fetching catalogue');
    updateCatalogueDb();
  }
}

Future<void> updateCatalogueDb() async {
  print('updating db');
  final response = await http.get((Uri.parse(catalogueLink)));
  if (response.statusCode == 200) {
    var parsedCatalogue = parseCsv(response.body);
    if (parsedCatalogue.isEmpty) {
      return;
    }
    await DbFunctions().deleteCatalogue();
    await DbFunctions().addCatalogue(parsedCatalogue);
  } else {
    return;
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
