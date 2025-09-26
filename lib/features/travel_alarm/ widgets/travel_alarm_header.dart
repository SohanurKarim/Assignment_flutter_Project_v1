import 'package:flutter/material.dart';

class TravelAlarmHeader extends StatelessWidget {
  const TravelAlarmHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        'Welcome! Your Smart Travel Alarm',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
