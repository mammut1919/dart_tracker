enum AnalyticsType {
  averageFinishDart;

  String get title {
    switch (this) {
      case AnalyticsType.averageFinishDart:
        return 'Ø letzter Dart';
    }
  }

  String get description {
    switch (this) {
      case AnalyticsType.averageFinishDart:
        return 'Der Chart zeigt den durchschnittlichen Punktwert des letzten '
            'Finish-Darts pro Trainingstag. Höhere Werte bedeuten im '
            'Durchschnitt anspruchsvollere Checkouts.';
    }
  }
}