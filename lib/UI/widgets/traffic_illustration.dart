import 'package:flutter/material.dart';

import '../../model/onboarding_page.dart';

class TrafficIllustration extends StatelessWidget {
  const TrafficIllustration({
    super.key,
    required this.artwork,
    required this.backgroundColor,
  });
  final OnboardingArtwork artwork;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final icon = switch (artwork) {
      OnboardingArtwork.camera => Icons.videocam_rounded,
      OnboardingArtwork.alert => Icons.notifications_active_rounded,
      OnboardingArtwork.shield => Icons.verified_user_rounded,
    };
    return Semantics(
      label: switch (artwork) {
        OnboardingArtwork.camera => 'Traffic camera illustration',
        OnboardingArtwork.alert => 'Violation notification illustration',
        OnboardingArtwork.shield => 'Secure licence illustration',
      },
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(42),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x180F2D4C),
                  blurRadius: 20,
                  offset: Offset(0, 9),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 104, color: const Color(0xFF102A43)),
                if (artwork == OnboardingArtwork.alert)
                  const Positioned(
                    right: 11,
                    top: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE13838),
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                if (artwork == OnboardingArtwork.camera)
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFF2563EB),
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
