import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  final int index;
  final String time;
  final String date;
  final bool enabled;
  final Function(int, bool) onToggle;
  final VoidCallback onDelete; // delete callback

  const AlarmTile({
    super.key,
    required this.index,
    required this.time,
    required this.date,
    required this.enabled,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Text(date, style: TextStyle(color: Colors.white54)),
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
      ),
    );
  }
}
