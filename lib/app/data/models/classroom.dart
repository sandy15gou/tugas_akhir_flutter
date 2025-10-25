import 'student.dart';
import 'schedule.dart';

class ClassRoom {
  final int grade;
  final String section;
  final String homeRoomTeacher;
  List<Student> students;
  List<Schedule> schedules;

  ClassRoom({
    required this.grade,
    required this.section,
    required this.homeRoomTeacher,
    List<Student>? students,
    List<Schedule>? schedules,
  })  : students = students ?? [],
        schedules = schedules ?? [];

  String get name => '$grade$section';

  void addStudent(Student student) {
    students.add(student);
  }

  void removeStudent(String studentId) {
    students.removeWhere((s) => s.id == studentId);
  }

  void updateStudent(String studentId, Student updatedStudent) {
    final index = students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      students[index] = updatedStudent;
    }
  }

  void addSchedule(Schedule schedule) {
    schedules.add(schedule);
  }

  void removeSchedule(String scheduleId) {
    schedules.removeWhere((s) => s.id == scheduleId);
  }

  void updateSchedule(String scheduleId, Schedule updatedSchedule) {
    final index = schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      schedules[index] = updatedSchedule;
    }
  }

  List<Schedule> getTodaySchedule() {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final today = days[DateTime.now().weekday % 7];
    return schedules.where((s) => s.day == today).toList();
  }

  Map<String, dynamic> toJson() => {
    'grade': grade,
    'section': section,
    'homeRoomTeacher': homeRoomTeacher,
    'students': students.map((s) => s.toJson()).toList(),
    'schedules': schedules.map((s) => s.toJson()).toList(),
  };

  factory ClassRoom.fromJson(Map<String, dynamic> json) => ClassRoom(
    grade: json['grade'],
    section: json['section'],
    homeRoomTeacher: json['homeRoomTeacher'],
    students: (json['students'] as List)
        .map((s) => Student.fromJson(s))
        .toList(),
    schedules: (json['schedules'] as List)
        .map((s) => Schedule.fromJson(s))
        .toList(),
  );
}
