import 'package:assignment_v1/features/alarm/AlarmScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TravelAlarmScreen extends StatefulWidget {
  @override
  _TravelAlarmScreenState createState() => _TravelAlarmScreenState();
}

class _TravelAlarmScreenState extends State<TravelAlarmScreen> {
  bool _loading = false;
  double? _savedLat;
  double? _savedLng;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLat = prefs.getDouble('saved_lat');
      _savedLng = prefs.getDouble('saved_lng');
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);

    try {
      // 1) Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled. Please enable them.');
        setState(() => _loading = false);
        return;
      }

      // 2) Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permission denied.');
          setState(() => _loading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission permanently denied — ask user to open app settings
        final opened = await Geolocator.openAppSettings();
        _showSnack('Permission permanently denied. Open app settings: ${opened ? "opened" : "failed"}');
        setState(() => _loading = false);
        return;
      }

      // 3) Obtain current location
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4) Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('saved_lat', pos.latitude);
      await prefs.setDouble('saved_lng', pos.longitude);

      // 5) Update UI
      setState(() {
        _savedLat = pos.latitude;
        _savedLng = pos.longitude;
      });

      _showSnack('Location saved: (${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)})');
    } catch (e) {
      _showSnack('Error getting location: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  // Future<void> _clearSavedLocation() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('saved_lat');
  //   await prefs.remove('saved_lng');
  //   setState(() {
  //     _savedLat = null;
  //     _savedLng = null;
  //   });
  //   _showSnack('Saved location cleared.');
  // }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.purple, // Set background color to purple
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003F95),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Welcome! Your Smart Travel Alarm',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Stay on schedule and enjoy every moment of your journey.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white70),
              ),
            ),
            SizedBox(height: 30),
            ClipOval(
              child: Image.asset('assets/images/image4.png', height: 400, width: 400, fit: BoxFit.cover),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Use Current Location (Outlined)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _loading ? null : _getCurrentLocation,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white54, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        backgroundColor: Colors.transparent,
                      ),
                      child: _loading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Use Current Location', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.location_on, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Home button (navigates to AlarmScreen)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {

                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AlarmScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5200FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),

                  // SizedBox(height: 20),
                  //
                  // // Display saved coordinates if any
                  // if (_savedLat != null && _savedLng != null)
                  //   Column(
                  //     children: [
                  //       Text('Saved location:', style: TextStyle(color: Colors.white70)),
                  //       SizedBox(height: 6),
                  //       Text('${_savedLat!.toStringAsFixed(6)}, ${_savedLng!.toStringAsFixed(6)}',
                  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  //       TextButton(
                  //         onPressed: _clearSavedLocation,
                  //         child: Text('Clear saved location', style: TextStyle(color: Colors.white70)),
                  //       ),
                  //     ],
                  //   )
                  // else
                  //   Text('No saved location yet.', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
