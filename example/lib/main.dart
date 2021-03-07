import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_annual_task/flutter_annual_task.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    List<AnnualTaskItem> taskItems = AnnualTaskItemHelper.generateAnnualTask();
    List<AnnualTaskItem> taskItemsWithColor =
        AnnualTaskItemHelper.generateAnnualTaskColorItem(taskItems);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('annual_task_view'),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future.delayed(Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSectionTitle('Default'),
                  _buildExample(
                    '',
                    AnnualTaskView(
                      taskItems,
                      showMonthLabel: false,
                      showWeekDayLabel: false,
                    ),
                  ),
                  // Examples for cellShape
                  _buildSectionTitle('Cell shape'),
                  _buildExample(
                    'square',
                    AnnualTaskView(
                      taskItems, // List<AnnualTaskItem>
                      activateColor: Colors.red,
                      cellShape: AnnualTaskCellShape.SQUARE,
                    ),
                  ),
                  _buildExample(
                    'circle',
                    AnnualTaskView(
                      taskItems, // List<AnnualTaskItem>
                      activateColor: Colors.red,
                      emptyColor: Colors.grey.withAlpha(80),
                      cellShape: AnnualTaskCellShape.CIRCLE,
                    ),
                  ),
                  _buildExample(
                    'AnnualTaskColorItem',
                    AnnualTaskView(
                      taskItemsWithColor,
                      weekDayLabels: [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ],
                    ),
                  ),

                  // Examples for label
                  _buildSectionTitle('Labels'),
                  _buildExample(
                    'without labels',
                    AnnualTaskView(
                      taskItems, // List<AnnualTaskItem>
                      showMonthLabel: false,
                      showWeekDayLabel: false,
                    ),
                  ),
                  _buildExample(
                    'custom labels',
                    AnnualTaskView(
                      taskItems, // List<AnnualTaskItem>
                      weekDayLabels: CUSTOM_WEEKDAY_LABEL,
                      monthLabels: CUSTOM_MONTH_LABEL,
                    ),
                  ),
                  _buildExample(
                    'labels style',
                    AnnualTaskView(
                      taskItems, // List<AnnualTaskItem>
                      weekDayLabels: CUSTOM_WEEKDAY_LABEL,
                      monthLabels: CUSTOM_MONTH_LABEL,
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget _buildExample(String title, AnnualTaskView child) {
    return Column(children: [
      title?.isNotEmpty == true ? Text(title) : Container(),
      SizedBox(height: 4.0),
      child,
      Divider(),
    ]);
  }
}

const List<String> CUSTOM_WEEKDAY_LABEL = ['', 'Mon', '', 'Wed', '', 'Fri', ''];
const List<String> CUSTOM_MONTH_LABEL = [
  'Jan',
  '',
  'Mar',
  '',
  'May',
  '',
  'Jul',
  '',
  'Sep',
  '',
  'Nov',
  ''
];

class AnnualTaskItemHelper {
  static List<AnnualTaskItem> generateAnnualTask({int year, int sampleSize}) {
    var rnd = new Random();
    sampleSize = sampleSize ?? max(80, min(365, rnd.nextInt(200)));
    year ??= DateTime.now().year;
    DateTime prevDate = DateTime(year, 1, 1);
    return List.generate(sampleSize, (idx) {
      int maxDiff =
          (365 - prevDate.difference(DateTime(year, 12, 31)).inDays) ~/
              (sampleSize - idx);
      prevDate = prevDate.add(Duration(days: rnd.nextInt(maxDiff) + 1));
      return AnnualTaskItem(prevDate, rnd.nextDouble());
    });
  }

  static List<AnnualTaskColorItem> generateAnnualTaskColorItem(
      List<AnnualTaskItem> items) {
    List<Color> colors = [Colors.red, Colors.blue, Colors.orange];
    return items
        .map((e) => AnnualTaskColorItem(
              e.date,
              proceeding: e.proceeding,
              color: colors[Random().nextInt(colors.length)],
            ))
        .toList();
  }
}
