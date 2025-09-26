import 'package:flutter/material.dart';

class LocationButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const LocationButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.transparent,
        ),
        child: loading
            ? const SizedBox(
            height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Use Current Location', style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.location_on, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
