import 'package:flutter/material.dart';
import '../../data/models/schedule.dart';
import '../../data/models/classroom.dart';
import '../../data/services/database_service.dart';

class ScheduleManager extends StatefulWidget {
  final ClassRoom classroom;
  final VoidCallback onUpdate;

  const ScheduleManager({
    Key? key,
    required this.classroom,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ScheduleManager> createState() => _ScheduleManagerState();
}

class _ScheduleManagerState extends State<ScheduleManager> {
  bool isAdding = false;
  String? editingId;
  final formSubjectController = TextEditingController();
  final formTeacherController = TextEditingController();
  final formStartTimeController = TextEditingController();
  final formEndTimeController = TextEditingController();
  String selectedDay = 'Senin';

  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  void dispose() {
    formSubjectController.dispose();
    formTeacherController.dispose();
    formStartTimeController.dispose();
    formEndTimeController.dispose();
    super.dispose();
  }

  Future<void> handleAdd() async {
    if (formSubjectController.text.isEmpty ||
        formTeacherController.text.isEmpty ||
        formStartTimeController.text.isEmpty ||
        formEndTimeController.text.isEmpty) return;

    final newSchedule = Schedule(
      id: '${widget.classroom.name}-${DateTime.now().millisecondsSinceEpoch}',
      subject: formSubjectController.text,
      startTime: formStartTimeController.text,
      endTime: formEndTimeController.text,
      teacher: formTeacherController.text,
      day: selectedDay,
    );

    widget.classroom.addSchedule(newSchedule);
    await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
    widget.onUpdate();

    setState(() {
      isAdding = false;
      _clearForm();
    });
  }

  Future<void> handleEdit(Schedule schedule) async {
    final updatedSchedule = Schedule(
      id: schedule.id,
      subject: formSubjectController.text,
      startTime: formStartTimeController.text,
      endTime: formEndTimeController.text,
      teacher: formTeacherController.text,
      day: selectedDay,
    );

    widget.classroom.updateSchedule(schedule.id, updatedSchedule);
    await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
    widget.onUpdate();

    setState(() {
      editingId = null;
      _clearForm();
    });
  }

  void _clearForm() {
    formSubjectController.clear();
    formTeacherController.clear();
    formStartTimeController.clear();
    formEndTimeController.clear();
    selectedDay = 'Senin';
  }

  Future<void> handleDelete(String scheduleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus jadwal ini?'),
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
      widget.classroom.removeSchedule(scheduleId);
      await DatabaseService.saveClass(widget.classroom.name, widget.classroom);
      widget.onUpdate();
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.indigo[600], size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Jadwal Pelajaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => isAdding = !isAdding),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Jadwal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (isAdding) ...[
                const SizedBox(height: 16),
                _buildScheduleForm(),
              ],
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.classroom.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = widget.classroom.schedules[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: Colors.indigo[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: editingId == schedule.id
                            ? _buildScheduleForm(schedule: schedule)
                            : _buildScheduleItem(schedule),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleForm({Schedule? schedule}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedDay,
              decoration: const InputDecoration(
                labelText: 'Hari',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: days
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedDay = value);
                }
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: formSubjectController,
              decoration: const InputDecoration(
                labelText: 'Mata Pelajaran',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: formTeacherController,
              decoration: const InputDecoration(
                labelText: 'Nama Guru',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: formStartTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Waktu Mulai',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await _selectTime(context);
                      if (time != null) {
                        setState(() {
                          formStartTimeController.text =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: formEndTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Waktu Selesai',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await _selectTime(context);
                      if (time != null) {
                        setState(() {
                          formEndTimeController.text =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: schedule == null ? handleAdd : () => handleEdit(schedule),
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (schedule != null) {
                        editingId = null;
                      } else {
                        isAdding = false;
                      }
                      _clearForm();
                    });
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Batal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Schedule schedule) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.book,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                schedule.teacher,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                schedule.day,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.indigo[600]),
                const SizedBox(width: 4),
                Text(
                  '${schedule.startTime} - ${schedule.endTime}',
                  style: TextStyle(
                    color: Colors.indigo[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      editingId = schedule.id;
                      selectedDay = schedule.day;
                      formSubjectController.text = schedule.subject;
                      formTeacherController.text = schedule.teacher;
                      formStartTimeController.text = schedule.startTime;
                      formEndTimeController.text = schedule.endTime;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: () => handleDelete(schedule.id),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
