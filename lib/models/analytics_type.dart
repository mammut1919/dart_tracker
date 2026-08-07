enum AnalyticsType {
  averageFinishDart,
  activity;

  String get title {
    switch (this) {
      case AnalyticsType.averageFinishDart:
        return 'Ø letzter Dart';
      case AnalyticsType.activity:
        return 'Aktivität';
    }
  }

  String get menuTitle {
    switch (this) {
      case AnalyticsType.averageFinishDart:
        return 'Durchschnitt Punkte letzter Dart';
      case AnalyticsType.activity:
        return 'Aktivität';
    }
  }

  String get description {
    switch (this) {
      case AnalyticsType.averageFinishDart:
        return 'Der Chart zeigt den durchschnittlichen Punktwert des letzten Finish-Darts pro Trainingstag. Höhere Werte bedeuten im Durchschnitt anspruchsvollere Checkouts.';

      case AnalyticsType.activity:
        return 'Diese Auswertung zeigt deine Trainingsaktivität. Der Chart stellt die Anzahl erfolgreicher Finishes pro Trainingstag dar. Darunter findest du Kennzahlen zu deinen Trainingsserien.';
    }
  }
}