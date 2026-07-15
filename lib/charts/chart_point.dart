import 'package:fl_chart/fl_chart.dart';

class ChartPoint {
  const ChartPoint({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  FlSpot get spot => FlSpot(x, y);
}