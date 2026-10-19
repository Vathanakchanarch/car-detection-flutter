import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../model/violation.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});
  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  int _filter = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final visible = demoViolations.where((v) {
      final statusMatches = switch (_filter) {
        1 => v.status == ViolationStatus.confirmed,
        2 => [
          ViolationStatus.suspected,
          ViolationStatus.underReview,
          ViolationStatus.disputed,
        ].contains(v.status),
        3 => v.status == ViolationStatus.resolved,
        _ => true,
      };
      final queryMatches = '${v.title} ${v.location} ${v.plate}'
          .toLowerCase()
          .contains(_query.toLowerCase());
      return statusMatches && queryMatches;
    }).toList();
    const filters = ['All 6', 'To pay 2', 'In review 3', 'Done 1'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        const Text(
          'Violations',
          style: TextStyle(
            color: ink,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search plate or location',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8EF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8EF)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            filters.length,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: FittedBox(child: Text(filters[index])),
                  selected: _filter == index,
                  onSelected: (_) => setState(() => _filter = index),
                  showCheckmark: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'ⓘ  AI detections are only suspected. A fine exists after official confirmation.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 18),
        AppPanel(
          padding: EdgeInsets.zero,
          child: visible.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No matching violations.'),
                )
              : Column(
                  children: [
                    for (var i = 0; i < visible.length; i++) ...[
                      ViolationTile(
                        violation: visible[i],
                        onTap: () => openPage(
                          context,
                          ViolationDetailScreen(violation: visible[i]),
                        ),
                      ),
                      if (i < visible.length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}
