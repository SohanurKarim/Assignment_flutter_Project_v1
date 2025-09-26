// lib/features/travel_alarm/services/alarm_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class AlarmStorage {
  static const String _alarmsKey = 'alarms';
  static const String _latKey = 'saved_lat';
  static const String _lngKey = 'saved_lng';

  /// Save alarms
  static Future<void> saveAlarms(List<Map<String, dynamic>> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = alarms
        .map((e) => Uri(queryParameters: e.map((k, v) => MapEntry(k, v.toString()))).query)
        .toList();
    await prefs.setStringList(_alarmsKey, alarmList);
  }

  /// Load alarms
  static Future<List<Map<String, dynamic>>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = prefs.getStringList(_alarmsKey) ?? [];
    return alarmList.map((e) {
      final map = Map<String, dynamic>.from(Uri.splitQueryString(e));
      return {
        'time': map['time'] ?? '',
        'date': map['date'] ?? '',
        'enabled': map['enabled'] == 'true',
      };
    }).toList();
  }

  /// Save location
  static Future<void> saveLocation(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
  }

  /// Load location
  static Future<Map<String, double?>> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'lat': prefs.getDouble(_latKey),
      'lng': prefs.getDouble(_lngKey),
    };
  }
}
