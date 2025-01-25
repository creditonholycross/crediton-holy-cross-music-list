import 'package:flutter_cpc_music_list/models/music.dart';

class Service {
  final String date;
  final String time;
  final String? rehearsalTime;
  final String serviceType;
  final List<Music> music;

  const Service({
    required this.date,
    required this.time,
    required this.rehearsalTime,
    required this.serviceType,
    required this.music,
  });

  factory Service.createService(
      String id, time, rehearsalTime, List<Music> music) {
    var idSplit = id.split(',');
    return Service(
        date: idSplit[0],
        time: time,
        rehearsalTime: rehearsalTime,
        serviceType: idSplit[1],
        music: music);
  }
}
