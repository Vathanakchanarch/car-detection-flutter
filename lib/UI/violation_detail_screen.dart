import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../model/violation.dart';
import 'appeal_screen.dart';
import 'review_payment_screen.dart';
import 'widgets/app_components.dart';

class ViolationDetailScreen extends StatelessWidget {
  const ViolationDetailScreen({super.key, required this.violation});
  final Violation violation;

  @override
  Widget build(BuildContext context) {
    final confirmed = violation.status == ViolationStatus.confirmed;
    return DetailPage(
      title: 'Violation details',
      bottom: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () =>
                  openPage(context, AppealScreen(violation: violation)),
              child: Text(confirmed ? 'Appeal' : 'Appeal or dispute'),
            ),
          ),
          if (confirmed) ...[
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  openPage(context, ReviewPaymentScreen(fines: [violation]));
                },
                child: const Text('🔒 Pay Fine'),
              ),
            ),
          ],
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => showDemoMessage(
              context,
              'Video evidence is a demo placeholder.',
            ),
            child: Container(
              height: 235,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10253C), Color(0xFF25446D)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 66,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 12,
                    child: Text(
                      '● CAM-017',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 12,
                    child: Text(
                      '${violation.date} ${violation.time}:07',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    bottom: 12,
                    child: Text(
                      'DEMO PLACEHOLDER',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: confirmed
                  ? const Color(0xFFFDEBEC)
                  : const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  confirmed
                      ? '✹  Officially confirmed'
                      : '✦  AI-suspected only',
                  style: TextStyle(
                    color: confirmed ? const Color(0xFFC32632) : blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  confirmed ? 'Review the details. You may pay or appeal.' : 'No fine exists. An officer must review this clip first.',
                  style: const TextStyle(color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  violation.title,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StatusBadge(violation.status),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (sheetContext) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'What does this mean?',
                        style: TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Our camera system noticed that your vehicle may have broken a traffic rule at this place and time. This is a plain-language summary for demo purposes, not legal advice.',
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '✓ AI marks clips it is unsure about. People make the final decision.\n\n✓ You can watch the evidence and appeal if it looks wrong.\n\n✓ You only pay after an official confirmation.',
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.help_outline),
            label: const Text('Explain this violation'),
          ),
          const SizedBox(height: 26),
          const SectionTitle('Incident'),
          AppPanel(
            child: Column(
              children: [
                InfoRow('Location', violation.location),
                const Divider(height: 1),
                InfoRow('Date & time', '${violation.date} · ${violation.time}'),
                const Divider(height: 1),
                InfoRow('Reference', violation.reference),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Vehicle'),
          AppPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                  style: TextStyle(color: blue, fontSize: 11),
                ),
                Text(
                  violation.plate,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  violation.plate == '2AB-1234'
                      ? 'Toyota Prius'
                      : 'Honda Click 125i',
                  style: const TextStyle(color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Official fine'),
          AppPanel(
            child: confirmed
                ? Column(
                    children: [
                      InfoRow('Base fine', riel(violation.amount)),
                      const Divider(height: 1),
                      const InfoRow('Service fee', '0 ៛'),
                      const Divider(height: 1),
                      const InfoRow('Pay by', '31 Oct 2026'),
                      const Divider(height: 1),
                      InfoRow('Total', riel(violation.amount)),
                    ],
                  )
                : const Text(
                    'No official fine has been issued for this event.',
                    style: TextStyle(color: muted),
                  ),
          ),
        ],
      ),
    );
  }
}
