class Student {
  final String id;
  final String name;
  final String nisn;

  Student({
    required this.id,
    required this.name,
    required this.nisn,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nisn': nisn,
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    name: json['name'],
    nisn: json['nisn'],
  );
}
