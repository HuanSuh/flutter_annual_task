import 'dart:ui';

class AnnualTaskItem {
  final DateTime date;
  final double proceeding;

  AnnualTaskItem(this.date, this.proceeding);

  int get alpha => ((255.0 - 80.0) * proceeding).toInt();
  Color fillColor(Color activateColor) {
    return activateColor?.withAlpha(alpha + 80);
  }
}

class AnnualTaskColorItem extends AnnualTaskItem {
  final Color color;

  AnnualTaskColorItem(
    DateTime date, {
    double proceeding = 1.0,
    this.color,
  }) : super(date, proceeding);

  int get alpha => ((255.0 - 80.0) * proceeding).toInt();
  Color fillColor(Color activateColor) {
    return (color ?? activateColor)?.withAlpha(alpha + 80);
  }
}
