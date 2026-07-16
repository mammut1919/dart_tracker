import 'package:flutter/material.dart';

import 'chart_data.dart';

class ChartSeries {
  const ChartSeries({
    required this.label,
    required this.color,
    required this.chart,
  });

  final String label;
  final Color color;
  final ChartData chart;
}