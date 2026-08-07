class ChartScale {
  const ChartScale._();

  static double calculateXInterval(int count) {
    if (count <= 4) return 1;
    if (count <= 10) return 2;
    if (count <= 20) return 5;
    if (count <= 60) return 10;
    if (count <= 120) return 20;

    return 30;
  }

  static double calculateYInterval(
    double minY,
    double maxY,
  ) {
    final range = maxY - minY;

    if (range <= 10) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 200) return 20;

    return 50;
  }

  static double calculateChartMaxY(
    double maxValue,
    double interval,
  ) {
    return ((maxValue + 1) / interval).ceil() * interval;
  }
}