import 'package:csv/csv.dart';
import 'package:flutter_cpc_music_list/helper/dbFunctions.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:flutter_cpc_music_list/models/service.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

var musicLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=schedule';

var testingMusicLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=testing';

Future<Service?> fetchMusic() async {
  print('fetching music');
  var allServices = await DbFunctions().getServiceList();

  if (allServices == null) {
    updateMusicDb();
  }
  return await DbFunctions().getNextService();
}

Future<void> updateMusicDb() async {
  print('updating db');

  String musicURI;
  http.Response response;

  if (kDebugMode) {
    musicURI = testingMusicLink;
  } else {
    musicURI = musicLink;
  }

  try {
    response = await http.get((Uri.parse(musicURI)));
  } catch (e) {
    print(e);
    if (!kIsWeb) {
      Fluttertoast.showToast(
          msg: 'Failed to update music, check your internet connection');
    }
    return;
  }

  if (response.statusCode == 200) {
    var parsedMusic = parseCsv(response.body);
    if (parsedMusic.isEmpty) {
      return;
    }
    await DbFunctions().deleteAllMusic();
    await DbFunctions().addMultipleMusic(parsedMusic);
  } else {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to update music');
    }
  }
}

List<Music> parseCsv(String csv) {
  List<List<dynamic>> parsedList =
      const CsvToListConverter().convert(csv, eol: '\n');
  final keys = parsedList.first;

  var mappedList =
      parsedList.skip(1).map((v) => Map.fromIterables(keys, v)).toList();

  var musicList;

  try {
    musicList = mappedList.map((e) => Music.fromCsv(e)).toList();
  } on FormatException {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to update music');
    }
  }

  return musicList;
}

List<Service> groupMusic(List<Music> musicList) {
  var newMap = groupBy(musicList, (item) => '${item.date},${item.serviceType}');

  var serviceList = <Service>[];

  newMap.forEach((k, v) => serviceList.add(Service.createService(k, v)));
  // Service(
  //     date: k.split(',')[0],
  //     time: v[0].time,
  //     rehearsalTime: v[0].rehearsalTime,
  //     serviceType: k.split(',')[1],
  //     music: v)));
  return serviceList;
}
