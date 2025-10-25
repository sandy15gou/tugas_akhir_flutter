class JadwalModel {
  final String mapel;
  final String jam;
  final String guru;

  JadwalModel({
    required this.mapel,
    required this.jam,
    required this.guru,
  });
}

class KelasData {
  final List<String> students;
  final String waliKelas;
  final List<JadwalModel> jadwalHariIni;

  KelasData({
    required this.students,
    required this.waliKelas,
    required this.jadwalHariIni,
  });
}

Map<String, KelasData> classData = {
  '7A': KelasData(
    students: [
      'Ahmad Rizki',
      'Siti Nurhaliza',
      'Budi Santoso',
      'Dewi Lestari',
      'Eko Prasetyo',
      'Fatimah Zahra',
      'Gilang Ramadhan',
      'Hana Pertiwi'
    ],
    waliKelas: 'Ibu Sri Wahyuni, S.Pd',
    jadwalHariIni: [
      JadwalModel(
        mapel: 'Matematika',
        jam: '07:00 - 08:30',
        guru: 'Pak Budi Hartono',
      ),
      JadwalModel(
        mapel: 'Bahasa Indonesia',
        jam: '08:30 - 10:00',
        guru: 'Ibu Ani Suryani',
      ),
      JadwalModel(
        mapel: 'IPA',
        jam: '10:15 - 11:45',
        guru: 'Pak Darmawan',
      ),
    ],
  ),
  // Add more classes here
};

Map<String, KelasData> generateAllClasses() {
  final allClasses = <String, KelasData>{};
  final tingkat = [7, 8, 9];
  final kelas = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  for (var t in tingkat) {
    for (var k in kelas) {
      final className = '$t$k';
      if (classData.containsKey(className)) {
        allClasses[className] = classData[className]!;
      } else {
        // Generate dummy data for other classes
        allClasses[className] = KelasData(
          students: List.generate(
            8,
            (i) => 'Siswa ${i + 1} Kelas $className',
          ),
          waliKelas: 'Guru Wali Kelas $className',
          jadwalHariIni: [
            JadwalModel(
              mapel: 'Matematika',
              jam: '07:00 - 08:30',
              guru: 'Pak Guru 1',
            ),
            JadwalModel(
              mapel: 'Bahasa Indonesia',
              jam: '08:30 - 10:00',
              guru: 'Ibu Guru 2',
            ),
            JadwalModel(
              mapel: 'IPA',
              jam: '10:15 - 11:45',
              guru: 'Pak Guru 3',
            ),
          ],
        );
      }
    }
  }
  return allClasses;
}
