import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../model/vehicle.dart';
import '../model/violation.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key, required this.vehicle});
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Vehicle details',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ink,
            border: Border.all(color: const Color(0xFFC9D5E2)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                vehicle.type == 'Car'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: Colors.white,
                size: 44,
              ),
              const SizedBox(height: 10),
              Text(
                vehicle.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                      style: TextStyle(color: blue, fontSize: 9),
                    ),
                    Text(
                      vehicle.plate,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Details'),
        AppPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              InfoRow('Type', vehicle.type),
              const Divider(height: 1),
              InfoRow('Colour', vehicle.colour),
              const Divider(height: 1),
              InfoRow('Year', '${vehicle.year}'),
              const Divider(height: 1),
              InfoRow('Registration expires', vehicle.expiry),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Verification'),
        const AppPanel(
          child: Column(
            children: [
              _VerificationStep('Submitted'),
              _VerificationStep('Matched to registry'),
              _VerificationStep('Verified', last: true),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Linked violations'),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (index, violation)
                  in demoViolations
                      .where((v) => v.plate == vehicle.plate)
                      .indexed) ...[
                if (index > 0) const Divider(height: 1),
                _LinkedViolationRow(violation: violation),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _LinkedViolationRow extends StatelessWidget {
  const _LinkedViolationRow({required this.violation});
  final Violation violation;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => openPage(context, ViolationDetailScreen(violation: violation)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              switch (violation.id) {
                'red-light' => Icons.traffic,
                'speeding' => Icons.speed,
                'parking' => Icons.local_parking,
                _ => Icons.traffic,
              },
              color: blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  violation.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  violation.date,
                  style: const TextStyle(color: muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          StatusBadge(violation.status),
        ],
      ),
    ),
  );
}

class _VerificationStep extends StatelessWidget {
  const _VerificationStep(this.label, {this.last = false});

  final String label;
  final bool last;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF188653),
            child: Icon(Icons.check, color: Colors.white, size: 16),
          ),
          if (!last)
            Container(width: 2, height: 24, color: const Color(0xFF188653)),
        ],
      ),
      const SizedBox(width: 12),
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          label,
          style: const TextStyle(
            color: ink,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
