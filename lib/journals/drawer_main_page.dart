import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getjournaled/db/abstraction/journal_service/journal_map_service.dart';
import 'package:getjournaled/journals/journal_object.dart';
import 'package:getjournaled/journals/journal_search_page.dart';
import 'package:getjournaled/journals/journal_card.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Drawer extends StatefulWidget {
  const Drawer({super.key});

  @override
  State<Drawer> createState() => _Drawer();
}

class _Drawer extends State<Drawer> {
  final JournalService _journalService = GetIt.I<JournalService>();

  Map<int, JournalObject> _journalMap = {};

  final List<_DayRatingsData> _graphList = [];

  StreamSubscription? _journalSub;

  bool _displayTitle = true;
  double _sbw = 70;

  @override
  void dispose() {
    _journalSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _journalService.getAllJournals().then((value) => setState(() {
          _journalMap = value;
        }));
    _journalSub = _journalService.stream.listen(_onJournalsUpdate);
  }

  @override
  Widget build(BuildContext context) {
    _graphList.clear();
    for (var entry in _journalMap.entries) {
      var tmp = _DayRatingsData(entry.value.getDateOfCreation().toString(),
          entry.value.getDayRating());
      _graphList.add(tmp);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 24)),
              // ---------------------------------------------------------------------------
              // Title and search bar
              Row(
                mainAxisAlignment: (_displayTitle)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  // ---------------------------------------------------------------------------
                  // Title
                  if (_displayTitle) ...{
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 8.0),
                      child: Text(
                        'Journals',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber.shade50,
                        ),
                      ),
                    ),
                  },
                  const Expanded(child: Text('')),
                  if (_displayTitle) ...{
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                      child: SizedBox(
                        width: _sbw,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            //updateSearchBarSize();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const JournalSearchPage()));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 24)),
              // ---------------------------------------------------------------------------
              // Row where journals are shown
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var entry in _journalMap.entries) ...[
                      GestureDetector(
                        onDoubleTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete page'),
                                  content: const Text(
                                      'Are you sure you want to delete this page?'),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                    TextButton(
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _journalService.remove(entry.key);
                                          });
                                          Navigator.pop(context, 'Ok');
                                        }),
                                  ],
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 6.0, left: 0.0),
                          child: DrawerCard(
                            title: entry.value.getTitle(),
                            body: entry.value.getBody(),
                            id: entry.value.getId(),
                            dateOfCreation: entry.value.getDateOfCreation(),
                            cardColor: entry.value.getCardColor(),
                            dayRating: entry.value.getDayRating(),
                            highlight: entry.value.getHighlight(),
                            lowlight: entry.value.getLowlight(),
                            noteWorthy: entry.value.getNoteWorthy(),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                title: const ChartTitle(text: 'Daily Ratings'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_DayRatingsData, String>>[
                  LineSeries<_DayRatingsData, String>(
                    dataSource: _graphList,
                    xValueMapper: (_DayRatingsData ratings, _) => ratings.date.replaceAll('00:00:00.000', ''),
                    yValueMapper: (_DayRatingsData ratings, _) =>
                        ratings.rating,
                    name: 'Ratings',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSearchBarSize() {
    setState(() {
      _displayTitle = !_displayTitle;
      _sbw = (!_displayTitle) ? 200.0 : 70.0;
    });
  }

  void _onJournalsUpdate(Map<int, JournalObject> event) {
    setState(() {
      _journalMap = event;
    });
  }
}

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: const Drawer(),
    ));
  }
}

class _DayRatingsData {
  _DayRatingsData(this.date, this.rating);

  final String date;
  final int rating;
}
