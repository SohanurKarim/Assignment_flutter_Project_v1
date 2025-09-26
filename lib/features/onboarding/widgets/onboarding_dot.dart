import 'package:flutter/material.dart';

class OnboardingDot extends StatelessWidget {
  final bool isActive;

  const OnboardingDot({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5200FF) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
