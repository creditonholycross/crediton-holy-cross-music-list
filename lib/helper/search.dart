import 'package:flutter/material.dart';
import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:flutter_cpc_music_list/screens/catalogueScreen.dart';

class CatalogueSearchDelegate extends SearchDelegate {
  CatalogueSearchDelegate({required this.catalogueList});

  final List<Catalogue> catalogueList;
  List<Catalogue> results = <Catalogue>[];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query.isEmpty ? close(context, null) : query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
          child: Text('No results', style: TextStyle(fontSize: 24)));
    } else {
      return CatalogueWidget(catalogue: results);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    results = catalogueList.where((Catalogue music) {
      final String composer = music.composer.toLowerCase();
      final String title = music.title.toLowerCase();
      final String input = query.toLowerCase();

      return composer.contains(input) || title.contains(input);
    }).toList();

    return results.isEmpty
        ? const Center(
            child: Text('No Results', style: TextStyle(fontSize: 24)),
          )
        : CatalogueWidget(catalogue: results);
  }
}
