import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import 'vehicle_detail_screen.dart';
import 'widgets/app_components.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  void _addVehicle(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        String type = 'Car';
        return StatefulBuilder(
          builder: (context, setSheetState) => Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add a vehicle',
                  style: TextStyle(
                    color: ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('🚙  Car'),
                        selected: type == 'Car',
                        onSelected: (_) => setSheetState(() => type = 'Car'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('🏍  Motorcycle'),
                        selected: type == 'Motorcycle',
                        onSelected: (_) =>
                            setSheetState(() => type = 'Motorcycle'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Plate number',
                  style: TextStyle(color: ink, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                TextField(
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: '2AB-1234',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Official registry verification is not connected in this demo.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => showDemoMessage(
                    context,
                    'Vehicle verification needs an official registry connection.',
                  ),
                  child: const Text('Submit for verification'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'My Vehicles',
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: FilledButton.tonalIcon(
          onPressed: () => _addVehicle(context),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
    child: Column(
      children: [
        for (final vehicle in demoVehicles) ...[
          InkWell(
            onTap: () =>
                openPage(context, VehicleDetailScreen(vehicle: vehicle)),
            child: AppPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          vehicle.type == 'Car'
                              ? Icons.directions_car
                              : Icons.two_wheeler,
                          color: blue,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.name,
                              style: const TextStyle(
                                color: ink,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              vehicle.type,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: muted),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: ink, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                                  style: TextStyle(color: blue, fontSize: 6),
                                ),
                                Text(
                                  vehicle.plate,
                                  style: const TextStyle(
                                    color: ink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE5F6EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✓ Verified',
                          style: TextStyle(
                            color: Color(0xFF188653),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    ),
  );
}
