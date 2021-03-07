import 'dart:ui';

class AnnualTaskItem {
  final DateTime _date;
  final double? proceeding;
  DateTime get date => _date;

  AnnualTaskItem(DateTime date, [this.proceeding = 1.0])
      : this._date = DateTime(date.year, date.month, date.day);

  int get alpha => ((255.0 - 80.0) * (proceeding ?? 0)).toInt();
  Color? fillColor(Color? activateColor) {
    if (alpha <= 0) return null;
    return activateColor?.withAlpha(alpha + 80);
  }
}

class AnnualTaskColorItem extends AnnualTaskItem {
  final Color? color;

  AnnualTaskColorItem(
    DateTime date, {
    double proceeding = 1.0,
    this.color,
  }) : super(date, proceeding);

  @override
  Color? fillColor(Color? activateColor) {
    return super.fillColor(color ?? activateColor);
  }
}
