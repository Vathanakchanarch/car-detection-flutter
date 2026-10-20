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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: [
        const Text(
          'Violations',
          style: TextStyle(
            color: ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search plate or location',
            prefixIcon: const Icon(Icons.search, color: muted),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFC9D5E2).withValues(alpha: .6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(
              filters.length,
              (index) => Expanded(
                child: InkWell(
                  onTap: () => setState(() => _filter = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _filter == index
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _filter == index
                          ? const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 3,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      filters[index],
                      maxLines: 1,
                      style: TextStyle(
                        color: _filter == index ? ink : muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'ⓘ  AI detections are only suspected. A fine exists after official confirmation.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
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
