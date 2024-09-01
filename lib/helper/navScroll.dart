import 'package:flutter_cpc_music_list/models/catalogue.dart';

Map<String, int> createIndexes(List<Catalogue> catalogueList) {
  var alphabet = List.generate(26, (index) => String.fromCharCode(index + 65));

  final mappings = <String, int>{};

  for (var element in alphabet) {
    int index = catalogueList.indexWhere(
        (c) => c.composer.toLowerCase().startsWith(element.toLowerCase()));

    if (index != -1) {
      mappings[element] = index;
    }
  }
  if (mappings.containsKey('A')) {
    mappings['A'] = 0;
  }

  if (mappings.length == 1) {
    mappings[''] = 0;
  }

  return mappings;
}
