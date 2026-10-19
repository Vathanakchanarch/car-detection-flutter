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
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _addVehicle(context),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ),
        const SizedBox(height: 8),
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
                      Icon(
                        vehicle.type == 'Car'
                            ? Icons.directions_car
                            : Icons.two_wheeler,
                        color: blue,
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
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              vehicle.type,
                              style: const TextStyle(color: muted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: muted),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.plate,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Text(
                        '● Verified',
                        style: TextStyle(
                          color: Color(0xFF188653),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
