import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_annual_task/flutter_annual_task.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AnnualTaskItem> get taskItemsWithColor =>
      AnnualTaskItemHelper.colorItemList;

  @override
  Widget build(BuildContext context) {
    List<AnnualTaskItem> taskItems = AnnualTaskItemHelper.generateAnnualTask();
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
                    AnnualTaskView(taskItems),
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
                      emptyColor: Colors.grey.withAlpha(40),
                      cellShape: AnnualTaskCellShape.CIRCLE,
                    ),
                  ),
                  _buildExample(
                    'AnnualTaskColorItem',
                    AnnualTaskView(
                      taskItemsWithColor,
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
      child: Text(title, style: Theme.of(context).textTheme.title),
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
  static final List<AnnualTaskColorItem> colorItemList = List();
  static List<AnnualTaskItem> generateAnnualTask({int year, int sampleSize}) {
    colorItemList.clear();
    var rnd = new Random();
    year = year ?? DateTime.now().year;
    sampleSize = sampleSize ?? rnd.nextInt(200);
    sampleSize = max(40, min(365, sampleSize));
    DateTime prevDate = DateTime(year, 1, 1);
    return List.generate(sampleSize, (idx) {
      int maxDiff =
          (365 - prevDate.difference(DateTime(year, 12, 31)).inDays) ~/
              (sampleSize - idx);
      prevDate = prevDate.add(Duration(days: rnd.nextInt(maxDiff) + 1));

      colorItemList.add(
        AnnualTaskColorItem(
          prevDate,
          color: Color.fromARGB(
            255,
            rnd.nextInt(180),
            rnd.nextInt(180),
            rnd.nextInt(180),
          ),
        ),
      );
      return AnnualTaskItem(
        prevDate,
        rnd.nextDouble(),
      );
    });
  }
}
