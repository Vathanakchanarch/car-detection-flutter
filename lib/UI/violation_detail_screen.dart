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
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10253C), Color(0xFF25446D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: CustomPaint(painter: _EvidencePainter()),
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xEFFFFFFF),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: ink,
                          size: 34,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 12,
                      child: Text(
                        '●  CAM-017',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      child: Text(
                        '${violation.date} ${violation.time}:07',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 12),
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
          const SizedBox(height: 24),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: Colors.white,
                        border: Border.all(color: ink, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                            style: TextStyle(
                              color: blue,
                              fontSize: 6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            violation.plate,
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
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    violation.plate == '2AB-1234'
                        ? 'Toyota Prius'
                        : 'Honda Click 125i',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
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
                : const Row(
                    children: [
                      Icon(
                        Icons.gpp_maybe_outlined,
                        color: Color(0xFF9D6B00),
                        size: 26,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No official fine has been issued for this event.',
                          style: TextStyle(color: muted, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _EvidencePainter extends CustomPainter {
  const _EvidencePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final road = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * .38, size.height * .48)
      ..lineTo(size.width * .62, size.height * .48)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(road, Paint()..color = const Color(0xFF0D1623));
    canvas.drawLine(
      Offset(size.width / 2, size.height * .5),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = Colors.white38
        ..strokeWidth = 2,
    );
    final vehicle = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .55, size.height * .60, 52, 30),
      const Radius.circular(6),
    );
    canvas.drawRRect(vehicle, Paint()..color = const Color(0xFFD9E2EC));
    canvas.drawRect(
      Rect.fromLTWH(size.width * .52, size.height * .54, 70, 52),
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFF59E0B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
