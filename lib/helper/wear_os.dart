import 'package:flutter/physics.dart';
import 'package:flutter_cpc_music_list/models/music.dart';
import 'package:flutter_cpc_music_list/models/service.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:collection/collection.dart';

Future<void> wearOsSync(Service? nextService) async {
  FlutterWearOsConnectivity flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  flutterWearOsConnectivity.configureWearableAPI();

  if (nextService == null) {
    return;
  }

  var allHymns = nextService.music.where((x) => x.title.contains('#'));

  var splitHymnNumbers = <String>[];

  allHymns.forEach((hymn) {
    splitHymnNumbers.add(hymn.title.split('#').first);
  });

  var hymnTitle = splitHymnNumbers.join(', ');

  if (hymnTitle == '') {
    var hymns =
        nextService.music.firstWhereOrNull((x) => x.musicType.contains("Hymn"));

    hymns ??= const Music(
        date: '', time: '', serviceType: '', musicType: '', title: '-');

    hymnTitle == hymns.title;
  }

  print(hymnTitle);

  var psalm =
      nextService.music.firstWhereOrNull((x) => x.musicType.contains("Psalm"));

  psalm ??= const Music(
      date: '', time: '', serviceType: '', musicType: '', title: '-');

  var watchData = {
    "serviceType": nextService.serviceType,
    "serviceDate": nextService.date,
    "hymns": hymnTitle,
    "psalm": psalm.title
  };

  print(watchData);

  DataItem? dataItem = await flutterWearOsConnectivity.syncData(
      path: "/next-service-info", data: watchData, isUrgent: true);

  print(dataItem?.pathURI);
  print(dataItem?.mapData);
}
