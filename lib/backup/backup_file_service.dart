import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class BackupFileService {
  const BackupFileService();

  Future<File?> createBackupFile() async {
    final formatter = DateFormat('yyyy-MM-dd');

    final fileName =
        'dart_tracker_backup_${formatter.format(DateTime.now())}.json';

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Backup speichern',
      fileName: fileName,
    );

    if (path == null) {
      return null;
    }

    return File(path);
  }

  Future<bool> saveBackup(
    String json,
  ) async {
    final file = await createBackupFile();

    if (file == null) {
      return false;
    }

    await file.writeAsString(json);

    return true;
  }

  Future<String?> loadBackup() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Backup auswählen',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return null;
    }

    final path = result.files.single.path;

    if (path == null) {
      return null;
    }

    final file = File(path);

    return file.readAsString();
  }
}