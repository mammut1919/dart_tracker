import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

class SettingsRepository {
  static const _baseline180Key = 'baseline180';
  static const _baseline171Key = 'baseline171';
  static const _baseline162Key = 'baseline162';
  static const _baselineHighFinishKey = 'baselineHighFinish';
  static const _baselineShortLegKey = 'baselineShortLeg';
  static const _score180ColorKey = 'score180Color';
  static const _score171ColorKey = 'score171Color';
  static const _score162ColorKey = 'score162Color';
  static const _highFinishColorKey = 'highFinishColor';
  static const _shortLegColorKey = 'shortLegColor';
  static const _themeModeKey = 'themeMode';

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
      score180ColorValue:
          prefs.getInt(_score180ColorKey) ??
          AppSettings.initial.score180ColorValue,

      score171ColorValue:
          prefs.getInt(_score171ColorKey) ??
          AppSettings.initial.score171ColorValue,

      score162ColorValue:
          prefs.getInt(_score162ColorKey) ??
          AppSettings.initial.score162ColorValue,

      highFinishColorValue:
          prefs.getInt(_highFinishColorKey) ??
          AppSettings.initial.highFinishColorValue,

      shortLegColorValue:
          prefs.getInt(_shortLegColorKey) ??
          AppSettings.initial.shortLegColorValue,

      themeMode:
          prefs.getString(_themeModeKey) ??
          AppSettings.initial.themeMode,
    );

  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_baseline180Key, settings.baseline180);
    await prefs.setInt(_baseline171Key, settings.baseline171);
    await prefs.setInt(_baseline162Key, settings.baseline162);
    await prefs.setInt(_baselineHighFinishKey, settings.baselineHighFinish);
    await prefs.setInt(_baselineShortLegKey, settings.baselineShortLeg);
    await prefs.setInt(_score180ColorKey, settings.score180ColorValue);
    await prefs.setInt(_score171ColorKey, settings.score171ColorValue);
    await prefs.setInt(_score162ColorKey, settings.score162ColorValue);
    await prefs.setInt(_highFinishColorKey, settings.highFinishColorValue);
    await prefs.setInt(_shortLegColorKey, settings.shortLegColorValue);
    await prefs.setString(_themeModeKey, settings.themeMode);
  }
}
