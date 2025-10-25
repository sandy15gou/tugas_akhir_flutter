import 'package:flutter/material.dart';
import '../../data/models/student.dart';
import '../../data/models/classroom.dart';
import '../../data/services/database_service.dart';

class StudentManager extends StatefulWidget {
  final ClassRoom classroom;
  final VoidCallback onUpdate;

  const StudentManager({
    Key? key,
    required this.classroom,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<StudentManager> createState() => _StudentManagerState();
}

class _StudentManagerState extends State<StudentManager> {
  bool isAdding = false;
  String? editingId;
  final formNameController = TextEditingController();
  final formNisnController = TextEditingController();

  @override
  void dispose() {
    formNameController.dispose();
    formNisnController.dispose();
    super.dispose();
  }

  Future<void> handleAdd() async {
    if (formNameController.text.isEmpty || formNisnController.text.isEmpty) return;

    final newStudent = Student(
      id: '${widget.classroom.name}-${DateTime.now().millisecondsSinceEpoch}',
      name: formNameController.text,
      nisn: formNisnController.text,
    );

    widget.classroom.addStudent(newStudent);
    await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
    widget.onUpdate();

    setState(() {
      isAdding = false;
      formNameController.clear();
      formNisnController.clear();
    });
  }

  Future<void> handleEdit(Student student) async {
    final updatedStudent = Student(
      id: student.id,
      name: formNameController.text,
      nisn: formNisnController.text,
    );

    widget.classroom.updateStudent(student.id, updatedStudent);
    await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
    widget.onUpdate();

    setState(() {
      editingId = null;
      formNameController.clear();
      formNisnController.clear();
    });
  }

  Future<void> handleDelete(String studentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus siswa ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.classroom.removeStudent(studentId);
      await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.purple[600], size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Daftar Siswa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => isAdding = !isAdding),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Siswa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            if (isAdding) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: formNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Siswa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: formNisnController,
                      decoration: const InputDecoration(
                        labelText: 'NISN',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: handleAdd,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => setState(() => isAdding = false),
                          icon: const Icon(Icons.close),
                          label: const Text('Batal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.classroom.students.length,
              itemBuilder: (context, index) {
                final student = widget.classroom.students[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Colors.purple[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: editingId == student.id
                        ? _buildEditForm(student)
                        : _buildStudentItem(student, index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(Student student) {
    return Column(
      children: [
        TextField(
          controller: formNameController,
          decoration: const InputDecoration(
            labelText: 'Nama Siswa',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: formNisnController,
          decoration: const InputDecoration(
            labelText: 'NISN',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => handleEdit(student),
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => setState(() => editingId = null),
              icon: const Icon(Icons.close),
              label: const Text('Batal'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentItem(Student student, int index) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'NISN: ${student.nisn}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          color: Colors.blue,
          onPressed: () {
            setState(() {
              editingId = student.id;
              formNameController.text = student.name;
              formNisnController.text = student.nisn;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () => handleDelete(student.id),
        ),
      ],
    );
  }
}
