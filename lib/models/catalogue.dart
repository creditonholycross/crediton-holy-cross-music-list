class Catalogue {
  final String? id;
  final String composer;
  final String title;
  final String parts;
  final String? publisher;
  final String? season;

  const Catalogue(
      {this.id,
      required this.composer,
      required this.title,
      required this.parts,
      this.publisher,
      this.season});

  Map<String, Object?> toMap() {
    return {
      'id': '$composer$title$parts$publisher',
      'composer': composer,
      'title': title,
      'parts': parts,
      'publisher': publisher,
      'season': season
    };
  }

  factory Catalogue.fromCsv(Map<dynamic, dynamic> dict) {
    return Catalogue(
        composer: dict['COMPOSER'],
        title: dict['TITLE'],
        parts: dict['PARTS'],
        publisher: dict['PUBLISHER']!,
        season: dict['SEASON']!);
  }

  factory Catalogue.fromDb(Map<dynamic, dynamic> dict) {
    return Catalogue(
        composer: dict['composer'],
        title: dict['title'],
        parts: dict['parts'],
        publisher: dict['publisher']!,
        season: dict.containsKey('season') ? dict['season'] : "");
  }
}
