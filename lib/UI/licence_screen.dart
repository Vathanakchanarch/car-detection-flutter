import 'package:flutter/material.dart';

import '../data/demo_store.dart';
import 'widgets/app_components.dart';

class LicenceScreen extends StatefulWidget {
  const LicenceScreen({super.key});
  @override
  State<LicenceScreen> createState() => _LicenceScreenState();
}

class _LicenceScreenState extends State<LicenceScreen> {
  bool _previewPoints = false;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Driving Licence',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF20507F), Color(0xFF10253C)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'D R I V I N G  L I C E N C E',
                style: TextStyle(color: Color(0xFFB8C9D9), fontSize: 11),
              ),
              const Text(
                'Demo card · not an official document',
                style: TextStyle(color: Color(0xFFB8C9D9), fontSize: 12),
              ),
              const SizedBox(height: 34),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white70, size: 64),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        demoStore.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        '0412 ···· 7731',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'DOB ·· ··· 19··',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LicenceField('Category', 'A1 · B'),
                  _LicenceField('Issued', '12 Mar 2024'),
                  _LicenceField('Expires', '12 Mar 2029'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('Official points'),
        AppPanel(
          child: _previewPoints
              ? Column(
                  children: [
                    const Icon(Icons.donut_large, color: blue, size: 66),
                    const Text(
                      '9 / 12',
                      style: TextStyle(
                        color: ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'DEMO DATA · Sample balance for design preview only',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _previewPoints = false),
                      child: const Text('Back to unavailable state'),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Icon(
                      Icons.link_off,
                      color: Color(0xFF9D6B00),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Points unavailable',
                      style: TextStyle(color: ink, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Your licence is not connected to an official points service. We never show estimated points as official records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => showDemoMessage(
                        context,
                        'Official points service is not connected.',
                      ),
                      child: const Text('Check connection'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _previewPoints = true),
                      child: const Text('Preview verified state (demo data)'),
                    ),
                  ],
                ),
        ),
        if (_previewPoints) ...[
          const SizedBox(height: 24),
          const SectionTitle('Point deduction history'),
          const AppPanel(
            child: Column(
              children: [
                InfoRow('Red-light violation · 09 Sep 2026', '−2'),
                Divider(height: 1),
                InfoRow('Speeding · 11 Jan 2026', '−1'),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

class _LicenceField extends StatelessWidget {
  const _LicenceField(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
