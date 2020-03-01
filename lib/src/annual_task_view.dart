import 'dart:async';

import 'package:flutter/material.dart';
import './annual_task_item.dart';

enum AnnualTaskCellShape { SQUARE, CIRCLE, ROUNDED_SQUARE }

class AnnualTaskView extends StatefulWidget {
  final List<AnnualTaskItem> items;
  final Color activateColor;
  final Color emptyColor;
  final int year;

  final bool showWeekDayLabel;
  final List<String> weekDayLabels;
  final bool showMonthLabel;
  final List<String> monthLabels;
  final AnnualTaskCellShape cellShape;

  final bool swipeEnabled;
  final TextStyle labelStyle;

  AnnualTaskView(
    this.items, {
    int year,
    this.activateColor,
    this.emptyColor,
    this.cellShape,
    this.showWeekDayLabel = true,
    this.showMonthLabel = true,
    List<String> weekDayLabels,
    List<String> monthLabels,
    this.labelStyle,
    this.swipeEnabled = true,
  })  : assert(showWeekDayLabel == false ||
            (weekDayLabels == null || weekDayLabels.length == 7)),
        assert(showMonthLabel == false ||
            (monthLabels == null || monthLabels.length == 12)),
        this.year = year ?? DateTime.now().year,
        this.weekDayLabels =
            (weekDayLabels?.length ?? 0) == 7 ? weekDayLabels : _WEEKDAY_LABELS,
        this.monthLabels =
            (monthLabels?.length ?? 0) == 12 ? monthLabels : _MONTH_LABELS;

  @override
  _AnnualTaskViewState createState() => _AnnualTaskViewState();
}

class _AnnualTaskViewState extends State<AnnualTaskView> {
  double contentsWidth;
  bool _refreshing;

  final StreamController<Map<DateTime, AnnualTaskItem>> _streamController =
      StreamController();

  @override
  void didUpdateWidget(AnnualTaskView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildListToMap();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _layoutManagerView(),
        StreamBuilder<Map<DateTime, AnnualTaskItem>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            double opacity = 1.0;
            if (contentsWidth == null) {
              opacity = 0.0;
            } else if (_refreshing == true) {
              opacity = 0.5;
            }
            return AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: opacity == 1.0 ? 500 : 0),
              child: _AnnualTaskGrid(
                widget.year,
                snapshot.data,
                widget.activateColor ?? Theme.of(context).primaryColor,
                widget.emptyColor,
                widget.showWeekDayLabel,
                widget.showMonthLabel,
                widget.weekDayLabels,
                widget.monthLabels,
                widget.cellShape,
                widget.labelStyle,
                contentsWidth,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<Map<DateTime, AnnualTaskItem>> _buildListToMap() {
    Map<DateTime, AnnualTaskItem> resultMap = Map();
    _refreshing = true;
    _streamController.add(null);
    widget.items?.forEach((item) {
      resultMap[item.date] = item;
    });
    return Future.delayed(Duration.zero, () {
      _streamController.add(resultMap);
      _refreshing = false;
      return resultMap;
    });
  }

  Widget _layoutManagerView() {
    if (contentsWidth != null) return Container();
    return Container(
      height: 0,
      child: Row(
        children: <Widget>[
          (widget.showWeekDayLabel != false)
              ? Column(
                  children: List.generate(7, (idx) {
                  return Text(
                    widget.weekDayLabels[idx] ?? '',
                    style: widget.labelStyle ?? _LABEL_STYLE,
                  );
                }))
              : Container(),
          Expanded(
            child: LayoutBuilder(builder: (_, layout) {
              Future.delayed(
                Duration.zero,
                () => setState(() => contentsWidth = layout.maxWidth),
              );
              return Container();
            }),
          )
        ],
      ),
    );
  }
}

class _AnnualTaskGrid extends StatelessWidget {
  final DateTime firstDate;
  final Map<DateTime, AnnualTaskItem> resultMap;
  final int firstDay;

  final Color activateColor;
  final Color emptyColor;

  final bool showWeekDayLabel;
  final List<String> weekDayLabels;
  final bool showMonthLabel;
  final List<String> monthLabels;
  final AnnualTaskCellShape cellShape;
  final TextStyle labelStyle;

  final double contentsWidth;

  _AnnualTaskGrid(
    int year,
    this.resultMap,
    this.activateColor,
    Color emptyColor,
    this.showWeekDayLabel,
    this.showMonthLabel,
    this.weekDayLabels,
    this.monthLabels,
    AnnualTaskCellShape cellShape,
    TextStyle labelStyle,
    this.contentsWidth,
  )   : firstDate = DateTime(year, 1, 1),
        firstDay = DateTime(year, 1, 1).weekday % 7,
        this.emptyColor = emptyColor ?? const Color(0xFFD0D0D0),
        this.cellShape = cellShape ?? AnnualTaskCellShape.ROUNDED_SQUARE,
        this.labelStyle = labelStyle ?? _LABEL_STYLE;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, layout) {
        double maxWidth = contentsWidth ?? layout.maxWidth;
        final double cellSize = (maxWidth / 53) * 0.85;
        return Column(
          children: List.generate(
            _rowCnt,
            (days) {
              if (showMonthLabel == true && days == 0) {
                return _buildMonthLabelRow(
                  cellSize,
                  paddingLeft: layout.maxWidth - maxWidth,
                );
              }
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: (maxWidth / 53) * 0.075),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_colCnt, (weeks) {
                    if (showWeekDayLabel == true && weeks == 0) {
                      return _buildWeekdayLabel(days,
                          width: layout.maxWidth - maxWidth);
                    }
                    AnnualTaskItem result = _getResult(weeks, days);
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        cellShape == AnnualTaskCellShape.SQUARE
                            ? 0
                            : cellShape == AnnualTaskCellShape.CIRCLE
                                ? 200
                                : cellSize / 4,
                      ),
                      child: Container(
                        width: cellSize,
                        height: cellSize,
                        color: result?.fillColor(activateColor) ??
                            (emptyColor ?? Colors.grey.withAlpha(50)),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        );
      },
    );
  }

  AnnualTaskItem _getResult(int weeksIdx, int daysIdx) {
    if (resultMap == null) return null;
    if (showWeekDayLabel) weeksIdx--;
    if (showMonthLabel) daysIdx--;
    int days = weeksIdx * 7 + daysIdx - firstDay;
    DateTime date = firstDate.add(Duration(days: days));
    return resultMap[date];
  }

  int get _colCnt => showWeekDayLabel == true ? 54 : 53;
  int get _rowCnt => showMonthLabel == true ? 8 : 7;

  Widget _buildMonthLabelRow(double cellSize, {double paddingLeft}) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft ?? 0),
      child: Row(
        children: List.generate(12, (idx) {
          return _buildMonthLabel(idx, cellSize);
        }),
      ),
    );
  }

  Widget _buildMonthLabel(int idx, double cellSize) {
    DateTime date =
        DateTime(firstDate.year, idx + 2, 1).subtract(Duration(days: 1));
    return Container(
      width: (cellSize / 0.85) * (date.day / 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: cellSize * 1.5),
            child: Text(
              monthLabels[idx] ?? '',
              style: labelStyle,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeekdayLabel(int weekIdx, {double width}) {
    return Container(
      width: width ?? 0,
      alignment: Alignment.center,
      child: Text(
        weekDayLabels[weekIdx - (showMonthLabel ? 1 : 0)] ?? '',
        style: labelStyle,
      ),
    );
  }
}

const List<String> _WEEKDAY_LABELS = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
const List<String> _MONTH_LABELS = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
const TextStyle _LABEL_STYLE = TextStyle(fontSize: 8);
