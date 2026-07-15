import '../models/new_score_entry.dart';

class BackupMapper {
  const BackupMapper();

  Map<String, dynamic> entryToJson(
    NewScoreEntry entry,
  ) {
    return {
      'type': 'score_entry',
      'score': entry.score,
      'timestamp': entry.timestamp.toIso8601String(),
    };
  }

  NewScoreEntry entryFromJson(
  Map<String, dynamic> json,
  ) {
    if (json['type'] != 'score_entry') {
      throw UnsupportedError(
        'Unsupported entry type: ${json['type']}',
      );
    }

    return NewScoreEntry(
      score: json['score'] as int,
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
    );
  }
}