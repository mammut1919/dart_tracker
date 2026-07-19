import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

class SettingsRepository {
  static const _baseline180Key = 'baseline180';
  static const _baseline171Key = 'baseline171';
  static const _baseline162Key = 'baseline162';
  static const _baselineHighFinishKey = 'baselineHighFinish';
  static const _baselineShortLegKey = 'baselineShortLeg';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      baseline180:
          prefs.getInt(_baseline180Key) ?? AppSettings.initial.baseline180,
      baseline171:
          prefs.getInt(_baseline171Key) ?? AppSettings.initial.baseline171,
      baseline162:
          prefs.getInt(_baseline162Key) ?? AppSettings.initial.baseline162,
      baselineHighFinish:
          prefs.getInt(_baselineHighFinishKey) ??
          AppSettings.initial.baselineHighFinish,
      baselineShortLeg:
          prefs.getInt(_baselineShortLegKey) ??
          AppSettings.initial.baselineShortLeg,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_baseline180Key, settings.baseline180);

    await prefs.setInt(_baseline171Key, settings.baseline171);

    await prefs.setInt(_baseline162Key, settings.baseline162);
    await prefs.setInt(_baselineHighFinishKey, settings.baselineHighFinish);

    await prefs.setInt(_baselineShortLegKey, settings.baselineShortLeg);
  }
}
