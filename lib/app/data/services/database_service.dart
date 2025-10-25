import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/classroom.dart';
import '../models/student.dart';
import '../models/schedule.dart';

class DatabaseService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveClass(String className, ClassRoom classData) async {
    try {
      if (_prefs == null) await init();
      final String data = jsonEncode(classData.toJson());
      return await _prefs!.setString('class:$className', data);
    } catch (error) {
      print('Error saving class: $error');
      return false;
    }
  }

  static Future<ClassRoom?> loadClass(String className) async {
    try {
      if (_prefs == null) await init();
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
      if (_prefs == null) await init();
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

  static Future<void> initializeDefaultData() async {
    try {
      if (_prefs == null) await init();

      final existingClasses = await getAllClasses();
      if (existingClasses.isNotEmpty) return;

      final grades = [7, 8, 9];
      final sections = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

      for (final grade in grades) {
        for (final section in sections) {
          final classroom = ClassRoom(
            grade: grade,
            section: section,
            homeRoomTeacher: 'Guru Wali Kelas $grade$section',
          );

          // Add sample students
          for (var i = 1; i <= 5; i++) {
            classroom.addStudent(Student(
              id: '$grade$section-$i',
              name: 'Siswa $i Kelas $grade$section',
              nisn: '$grade$section${i.toString().padLeft(3, '0')}',
            ));
          }

          // Add sample schedules
          final subjects = ['Matematika', 'Bahasa Indonesia', 'IPA', 'Bahasa Inggris', 'IPS'];
          final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

          for (var dayIdx = 0; dayIdx < days.length; dayIdx++) {
            final subject = subjects[dayIdx % subjects.length];
            classroom.addSchedule(Schedule(
              id: '$grade$section-schedule-$dayIdx',
              subject: subject,
              startTime: '07:00',
              endTime: '08:30',
              teacher: 'Pak/Bu Guru $subject',
              day: days[dayIdx],
            ));
          }

          await saveClass(classroom.name, classroom);
        }
      }
    } catch (error) {
      print('Error initializing default data: $error');
    }
  }

  static Future<void> clearAllData() async {
    try {
      if (_prefs == null) await init();
      final keys = _prefs!.getKeys().where((key) => key.startsWith('class:'));
      for (final key in keys) {
        await _prefs!.remove(key);
      }
    } catch (error) {
      print('Error clearing data: $error');
    }
  }
}
