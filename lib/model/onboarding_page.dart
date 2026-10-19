import 'package:flutter/material.dart';

enum OnboardingArtwork { camera, alert, shield }

@immutable
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.artwork,
    required this.backgroundColor,
  });

  final String title;
  final String description;
  final OnboardingArtwork artwork;
  final Color backgroundColor;
}
