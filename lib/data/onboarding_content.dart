import 'package:flutter/material.dart';

import '../model/onboarding_page.dart';

const onboardingPages = <OnboardingPage>[
  OnboardingPage(
    title: 'Smart traffic monitoring',
    description: 'AI reviews CCTV footage on public roads and flags possible violations for officers to check.',
    artwork: OnboardingArtwork.camera,
    backgroundColor: Color(0xFFE3EDFE),
  ),
  OnboardingPage(
    title: 'Instant violation notifications',
    description: 'Get alerted with video evidence, location and time. See what is suspected and what is officially confirmed.',
    artwork: OnboardingArtwork.alert,
    backgroundColor: Color(0xFFFFF0DE),
  ),
  OnboardingPage(
    title: 'Secure fine & licence management',
    description: 'Review fines, appeal when something looks wrong, and keep your vehicles and licence in one place.',
    artwork: OnboardingArtwork.shield,
    backgroundColor: Color(0xFFDCF5E9),
  ),
];
