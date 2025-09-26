import 'package:flutter/material.dart';

class TravelAlarmImage extends StatelessWidget {
  final String imagePath;

  const TravelAlarmImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imagePath,
        height: 400,
        width: 400,
        fit: BoxFit.cover,
      ),
    );
  }
}
