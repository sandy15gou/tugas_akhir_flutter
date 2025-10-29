import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/classroom.dart';
import '../models/student.dart';
import '../models/schedule.dart';

class DatabaseService extends GetxService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> initializeDefaultData() async {
    if (_prefs == null) {
      await init();
    }

    // Check if first run
    bool isFirstRun = _prefs!.getBool('isFirstRun') ?? true;
    if (!isFirstRun) return;

    // Set first run flag
    await _prefs!.setBool('isFirstRun', false);

    // Initialize default data here if needed
    // For example:
    // await _prefs!.setString('defaultTheme', 'light');
  }

  static Future<bool> saveString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> saveBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  static Future<bool> saveClass(String className, ClassRoom classData) async {
    try {
      final String data = jsonEncode(classData.toJson());
      await _prefs!.setString('class:$className', data);
      return true;
    } catch (error) {
      print('Error saving class: $error');
      return false;
    }
  }

  static Future<ClassRoom?> loadClass(String className) async {
    try {
      final String? data = _prefs!.getString('class:$className');
      if (data != null) {
        return ClassRoom.fromJson(jsonDecode(data));
      }
      return null;
    } catch (error) {
      print('Error loading class: $error');
      return null;
    }
  }

  static Future<Map<String, ClassRoom>> getAllClasses() async {
    try {
      final Set<String> keys = _prefs!.getKeys();
      final classKeys = keys.where((key) => key.startsWith('class:'));
      final Map<String, ClassRoom> classes = {};

      for (final key in classKeys) {
        final className = key.replaceFirst('class:', '');
        final classData = await loadClass(className);
        if (classData != null) {
          classes[className] = classData;
        }
      }

      return classes;
    } catch (error) {
      print('Error loading all classes: $error');
      return {};
    }
  }
}

