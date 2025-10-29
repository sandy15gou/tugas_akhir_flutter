class Schedule {
  final String id;
  final String subject;
  final String startTime;
  final String endTime;
  final String teacher;
  final String day;

  Schedule({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.day,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'startTime': startTime,
    'endTime': endTime,
    'teacher': teacher,
    'day': day,
  };

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json['id'],
    subject: json['subject'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    teacher: json['teacher'],
    day: json['day'],
  );
}