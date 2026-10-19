import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../model/vehicle.dart';
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
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Icon(
                vehicle.type == 'Car'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: Colors.white,
                size: 38,
              ),
              const SizedBox(height: 10),
              Text(
                vehicle.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🟢  Submitted', style: TextStyle(color: ink)),
              SizedBox(height: 18),
              Text('🟢  Matched to registry', style: TextStyle(color: ink)),
              SizedBox(height: 18),
              Text('🟢  Verified', style: TextStyle(color: ink)),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Linked violations'),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final violation in demoViolations.where(
                (v) => v.plate == vehicle.plate,
              ))
                ViolationTile(
                  violation: violation,
                  onTap: () => openPage(
                    context,
                    ViolationDetailScreen(violation: violation),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
