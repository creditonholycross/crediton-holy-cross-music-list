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

  var hymns = nextService.music.firstWhereOrNull((x) => x.musicType == "Hymns");

  hymns ??= const Music(
      date: '', time: '', serviceType: '', musicType: '', title: '-');

  var psalm =
      nextService.music.firstWhereOrNull((x) => x.musicType.contains("Psalm"));

  psalm ??= const Music(
      date: '', time: '', serviceType: '', musicType: '', title: '-');

  DataItem? dataItem = await flutterWearOsConnectivity.syncData(
      path: "/next-service",
      data: {
        "serviceType": nextService.serviceType,
        "serviceDate": nextService.date,
        "hymns": hymns.title,
        "psalm": '${psalm.title} ${psalm.composer}'
      },
      isUrgent: false);

  print(dataItem?.pathURI);
}
