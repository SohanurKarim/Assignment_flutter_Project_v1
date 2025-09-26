import 'package:flutter/material.dart';

class TravelAlarmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const TravelAlarmButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF5200FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
