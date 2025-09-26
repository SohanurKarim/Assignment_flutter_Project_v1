import 'package:assignment_v1/features/alarm/services/alarm_storage.dart';
import 'package:assignment_v1/features/alarm/widgets/alarm_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> alarms = [];
  double? _savedLat;
  double? _savedLng;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedAlarms = await AlarmStorage.loadAlarms();
    final location = await AlarmStorage.loadLocation();
    setState(() {
      alarms = loadedAlarms;
      _savedLat = location['lat'];
      _savedLng = location['lng'];
    });
  }

  Future<void> _saveAlarms() async => AlarmStorage.saveAlarms(alarms);

  void _toggleAlarm(int index, bool value) {
    setState(() {
      alarms[index]['enabled'] = value;
    });
    _saveAlarms();
  }

  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
    _saveAlarms();
  }

  Future<void> _showAddAlarmSheet() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) return;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate == null) return;

    final formattedTime = selectedTime.format(context);
    final formattedDate = DateFormat('EEE, dd MMM yyyy').format(selectedDate);

    setState(() {
      alarms.add({'time': formattedTime, 'date': formattedDate, 'enabled': true});
    });
    _saveAlarms();
  }

  void _confirmDeleteAlarm(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Alarm?'),
        content: const Text('Do you want to delete this alarm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAlarm(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C0327), Color(0xFF003F95)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Location',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 28, color: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _savedLat != null && _savedLng != null
                          ? '${_savedLat!.toStringAsFixed(6)}, ${_savedLng!.toStringAsFixed(6)}'
                          : 'Add your travel alarm',
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Alarms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
            const SizedBox(height: 10),
            Expanded(
              child: alarms.isEmpty
                  ? const Center(
                child: Text('No alarms set yet', style: TextStyle(color: Colors.white70, fontSize: 18)),
              )
                  : ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return AlarmTile(
                    index: index,
                    time: alarm['time'],
                    date: alarm['date'],
                    enabled: alarm['enabled'],
                    onToggle: _toggleAlarm,
                    onDelete: () => _confirmDeleteAlarm(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 45),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: _showAddAlarmSheet,
            backgroundColor: const Color(0xFF5200FF),
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 36, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
