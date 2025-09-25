
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For formatting date

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> alarms = [];
  double? _savedLat;
  double? _savedLng;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
    _loadAlarms();
  }

  /// Load saved location from SharedPreferences
  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLat = prefs.getDouble('saved_lat');
      _savedLng = prefs.getDouble('saved_lng');
    });
  }

  /// Load alarms from SharedPreferences
  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = prefs.getStringList('alarms') ?? [];
    setState(() {
      alarms = alarmList.map((e) {
        final map = Map<String, dynamic>.from(Uri.splitQueryString(e));
        return {
          'time': map['time'] ?? '',
          'date': map['date'] ?? '',
          'enabled': map['enabled'] == 'true', // <-- convert to bool
        };
      }).toList();
    });
  }

  /// Save alarms to SharedPreferences
  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = alarms
        .map((e) => Uri(queryParameters: e.map((k, v) => MapEntry(k, v.toString())))
        .query)
        .toList();
    await prefs.setStringList('alarms', alarmList);
  }

  /// Toggle alarm on/off
  void _toggleAlarm(int index, bool value) {
    setState(() {
      alarms[index]['enabled'] = value;
    });
    _saveAlarms();
  }

  /// Delete alarm
  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
    _saveAlarms();
  }

  /// Show bottom sheet to add alarm using pickers
  void _showAddAlarmSheet() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return; // User canceled

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate == null) return; // User canceled

    // Format time and date
    final formattedTime = selectedTime.format(context);
    final formattedDate = DateFormat('EEE, dd MMM yyyy').format(selectedDate);

    // Add alarm
    setState(() {
      alarms.add({'time': formattedTime, 'date': formattedDate, 'enabled': true});
    });
    _saveAlarms();
  }

  /// Confirm delete alarm
  void _confirmDeleteAlarm(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Alarm?'),
        content: Text('Do you want to delete this alarm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAlarm(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
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
        decoration: BoxDecoration(
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
            // Saved Location Section
            Text(
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
                  Icon(Icons.location_on_outlined, size: 28, color: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _savedLat != null && _savedLng != null
                          ? '${_savedLat!.toStringAsFixed(6)}, ${_savedLng!.toStringAsFixed(6)}'
                          : 'Add your location',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Alarms Section
            Text('Alarms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
            SizedBox(height: 10),

            Expanded(
              child: alarms.isEmpty
                  ? Center(
                child: Text(
                  'No alarms set yet',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return GestureDetector(
                    onLongPress: () => _confirmDeleteAlarm(index),
                    child: AlarmTile(
                      index: index,
                      time: alarm['time'],
                      date: alarm['date'],
                      enabled: alarm['enabled'],
                      onToggle: _toggleAlarm,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Button to Add Alarm
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 45),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: _showAddAlarmSheet,
            backgroundColor: Color(0xFF5200FF),
            shape: CircleBorder(),
            child: Icon(Icons.add, size: 36, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AlarmTile extends StatelessWidget {
  final int index;
  final String time;
  final String date;
  final bool enabled;
  final Function(int, bool) onToggle;

  const AlarmTile({
    required this.index,
    required this.time,
    required this.date,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Spacer(),
          Text(
            date,
            style: TextStyle(color: Colors.white54),
          ),
          Switch(
            value: enabled,
            onChanged: (val) => onToggle(index, val),
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF5200FF),
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
