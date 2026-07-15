import 'chart_point.dart';

class ChartData {
  const ChartData({
    required this.points,
    required this.firstDate,
    required this.lastDate,
  });

  final List<ChartPoint> points;

  final DateTime firstDate;
  final DateTime lastDate;

  double get maxX =>
      lastDate.difference(firstDate).inDays.toDouble();

  DateTime dateAt(double x) {
    return firstDate.add(
      Duration(days: x.round()),
    );
  }
}