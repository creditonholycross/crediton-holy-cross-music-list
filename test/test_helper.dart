import 'package:test/test.dart';
import 'package:flutter_cpc_music_list/helper/fetchMusic.dart';

void main() {
  test('CSV is parsed correctly', () {
    var csv =
        'date,service,type,title,composer,link\n2023-11-12,Eucharist,Hymns,580|582|569|565|715,,';
    var result = parseCsv(csv);
    expect(result.length, 1);
    expect(result[0].serviceType, 'Eucharist');
  });
}
