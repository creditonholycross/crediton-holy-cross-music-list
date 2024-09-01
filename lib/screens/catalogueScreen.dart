import 'package:flutter/material.dart';
import 'package:flutter_cpc_music_list/helper/dbFunctions.dart';
import 'package:flutter_cpc_music_list/helper/fetchCatalogue.dart';
import 'package:flutter_cpc_music_list/helper/search.dart';
import 'package:flutter_cpc_music_list/main.dart';
import 'package:flutter_cpc_music_list/models/catalogue.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

ItemScrollController _scrollController = ItemScrollController();

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  static const List<String> seasonMenuEntries = <String>[
    'Season (All)',
    'Epiphany',
    'Easter',
    'Whitsun',
    'Harvest',
    'Remem',
    'Advent',
    'Christmas'
  ];

  static const List<String> partsMenuEntries = <String>[
    'Parts (All)',
    'SATB',
    'Treble',
    'SSA',
    'Solo',
    'TTBB',
    'TB',
    'SS',
    'Upper'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ServiceState>();
    var catalogue = appState.filteredCatalogueList;
    var navIndex = appState.navIndex;
    var navScrollIndexMapping = appState.navScrollIndexMapping;
    var alphabetList = appState.alphabetList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Catalogue"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CatalogueSearchDelegate(
                      catalogueList: catalogue as List<Catalogue>))),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              updateCatalogueDb();
              setState(() {
                appState.setCatalogueList();
              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu(
                    initialSelection: seasonMenuEntries.first,
                    onSelected: (String? value) {
                      setState(() {
                        appState.seasonMenuValue = value!;
                        appState.filterCatalogueList();
                        appState.setNavIndex(0);
                        if (navScrollIndexMapping.isNotEmpty) {
                          _scrollController.scrollTo(
                              index: navScrollIndexMapping.values.toList()[0],
                              duration: const Duration(milliseconds: 500));
                        }
                      });
                    },
                    dropdownMenuEntries: seasonMenuEntries
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu(
                    initialSelection: partsMenuEntries.first,
                    onSelected: (String? value) {
                      setState(() {
                        appState.partsMenuValue = value!;
                        appState.filterCatalogueList();
                        appState.setNavIndex(0);
                        if (navScrollIndexMapping.isNotEmpty) {
                          _scrollController.scrollTo(
                              index: navScrollIndexMapping.values.toList()[0],
                              duration: const Duration(milliseconds: 500));
                        }
                      });
                    },
                    dropdownMenuEntries: partsMenuEntries
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
              ),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: CatalogueWidget(catalogue: catalogue)),
                SafeArea(child: LayoutBuilder(builder: (context, constraint) {
                  if (navScrollIndexMapping.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          destinations: alphabetList
                              .map<NavigationRailDestination>((String char) {
                            return NavigationRailDestination(
                                label: Text(char), icon: Text(char));
                          }).toList(),
                          selectedIndex: navIndex,
                          onDestinationSelected: (value) {
                            setState(() {
                              appState.setNavIndex(value);
                              _scrollController.scrollTo(
                                  index: navScrollIndexMapping.values
                                      .toList()[value],
                                  duration: const Duration(milliseconds: 500));
                            });
                          },
                        ),
                      ),
                    ),
                  );
                }))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogueWidget extends StatelessWidget {
  const CatalogueWidget({
    super.key,
    required this.catalogue,
  });

  final List<Catalogue>? catalogue;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: catalogue!.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: Text(catalogue![index].composer),
                subtitle: Text(
                  catalogue![index].title,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )),
          ],
        );
      },
    );
  }
}
