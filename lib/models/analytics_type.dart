enum AnalyticsType {
  averageFinish,
  averageFinishDart,
  activity;

  String get title {
    switch (this) {
      case AnalyticsType.averageFinish:
        return 'Ø Finish';

      case AnalyticsType.averageFinishDart:
        return 'Ø letzter Dart';

      case AnalyticsType.activity:
        return 'Aktivität';
    }
  }

  String get menuTitle {
    switch (this) {
      case AnalyticsType.averageFinish:
        return 'Durchschnitt Finish';

      case AnalyticsType.averageFinishDart:
        return 'Durchschnitt Punkte letzter Dart';

      case AnalyticsType.activity:
        return 'Aktivität';
    }
  }

  String get description {
    switch (this) {
      case AnalyticsType.averageFinish:
        return 'Diese Auswertung zeigt den durchschnittlichen Punktwert deiner vollständigen Finishes. Finish-Erfassung kann in den Einstellungen eingeschaltet werden.';

      case AnalyticsType.averageFinishDart:
        return 'Der Chart zeigt den durchschnittlichen Punktwert aller Finish-Darts pro Trainingszeitraum. Höhere Werte bedeuten im Durchschnitt höhere Checkouts.';

      case AnalyticsType.activity:
        return 'Diese Auswertung zeigt deine Trainingsaktivität. Der Chart stellt die Anzahl erfolgreicher Finishes pro Trainingszeitraum dar. Darunter findest du Kennzahlen zu deinen Trainingsserien.';
    }
  }
}