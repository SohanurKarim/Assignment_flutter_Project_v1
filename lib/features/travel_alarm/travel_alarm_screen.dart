import 'package:assignment_v1/features/alarm/alarm_screen.dart';
import 'package:assignment_v1/features/travel_alarm/%20widgets/location_button.dart';
import 'package:assignment_v1/features/travel_alarm/%20widgets/travel_alarm_button.dart';
import 'package:assignment_v1/features/travel_alarm/%20widgets/travel_alarm_header.dart';
import 'package:assignment_v1/features/travel_alarm/%20widgets/travel_alarm_image.dart';
import 'package:flutter/material.dart';

import 'services/location_service.dart';


class TravelAlarmScreen extends StatefulWidget {
  const TravelAlarmScreen({super.key});

  @override
  State<TravelAlarmScreen> createState() => _TravelAlarmScreenState();
}

class _TravelAlarmScreenState extends State<TravelAlarmScreen> {
  final LocationService _locationService = LocationService();
  bool _loading = false;

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);
    try {
      final pos = await _locationService.getCurrentLocation();
      _showSnack("Location saved: (${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)})");
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003F95),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            const TravelAlarmHeader(),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Stay on schedule and enjoy every moment of your journey.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),
            const TravelAlarmImage(imagePath: 'assets/images/image4.png'),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  LocationButton(
                    loading: _loading,
                    onPressed: _getCurrentLocation,
                  ),
                  const SizedBox(height: 16),
                  TravelAlarmButton(
                    text: "Home",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>  AlarmScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
