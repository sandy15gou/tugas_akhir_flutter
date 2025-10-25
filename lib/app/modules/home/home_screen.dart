import 'package:flutter/material.dart';
import '../../data/models/classroom.dart';
import '../../data/services/database_service.dart';
import '../widgets/student_manager.dart';
import '../widgets/schedule_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedClass = '7A';
  int selectedTingkat = 7;
  Map<String, ClassRoom> classes = {};
  bool isLoading = true;
  final kelasPerTingkat = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await DatabaseService.init();
      await DatabaseService.initializeDefaultData();
      await loadClasses();
    } catch (e) {
      print('Error initializing data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadClasses() async {
    setState(() => isLoading = true);
    final allClasses = await DatabaseService.getAllClasses();
    setState(() {
      classes = allClasses;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FF), Color(0xFFF0E6FF)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data...'),
            ],
          ),
        ),
      );
    }

    final currentClass = classes[selectedClass];
    if (currentClass == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FF), Color(0xFFF0E6FF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTingkatSelector(),
                    const SizedBox(height: 24),
                    _buildKelasSelector(),
                    const SizedBox(height: 24),
                    _buildKelasInfo(currentClass),
                    const SizedBox(height: 24),
                    ScheduleManager(
                      classroom: currentClass,
                      onUpdate: loadClasses,
                    ),
                    const SizedBox(height: 24),
                    StudentManager(
                      classroom: currentClass,
                      onUpdate: loadClasses,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.indigo],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: const Row(
        children: [
          Icon(Icons.school, size: 40, color: Colors.white),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistem Manajemen Kelas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'SMP Negeri 1 Jakarta',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTingkatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Tingkat Kelas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [7, 8, 9].map((tingkat) {
            final isSelected = selectedTingkat == tingkat;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTingkat = tingkat;
                    selectedClass = '$tingkat${kelasPerTingkat[0]}';
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: isSelected ? Colors.white : Colors.grey[800],
                  backgroundColor: isSelected ? Colors.indigo : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: isSelected ? 4 : 1,
                ),
                child: Text(
                  'Kelas $tingkat',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKelasSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Kelas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: kelasPerTingkat.map((kelas) {
            final className = '$selectedTingkat$kelas';
            final isSelected = selectedClass == className;
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedClass = className;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: isSelected ? Colors.white : Colors.grey[800],
                backgroundColor: isSelected ? Colors.purple : Colors.white,
                padding: EdgeInsets.zero,
                elevation: isSelected ? 4 : 1,
              ),
              child: Text(
                className,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKelasInfo(ClassRoom classroom) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Kelas ${classroom.name}',
            subtitle: 'Wali Kelas: ${classroom.homeRoomTeacher}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.groups,
            iconColor: Colors.green,
            title: 'Jumlah Siswa',
            subtitle: '${classroom.students.length} Siswa',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
