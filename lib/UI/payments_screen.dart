import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import 'review_payment_screen.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: demoStore,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: [
        const Text(
          'Payments',
          style: TextStyle(
            color: ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: SectionTitle('Fines to pay')),
            TextButton(
              onPressed: demoStore.clearFines,
              child: const Text('Clear'),
            ),
          ],
        ),
        AppPanel(
          padding: EdgeInsets.zero,
          child: demoStore.payable.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No fines to pay.'),
                )
              : Column(
                  children: [
                    for (var i = 0; i < demoStore.payable.length; i++) ...[
                      Row(
                        children: [
                          Semantics(
                            label: 'Select fine',
                            checked: demoStore.selectedFineIds.contains(
                              demoStore.payable[i].id,
                            ),
                            child: InkWell(
                              onTap: () =>
                                  demoStore.toggleFine(demoStore.payable[i].id),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          demoStore.selectedFineIds.contains(
                                            demoStore.payable[i].id,
                                          )
                                          ? blue
                                          : Colors.white,
                                      border: Border.all(color: blue, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        demoStore.selectedFineIds.contains(
                                          demoStore.payable[i].id,
                                        )
                                        ? const Icon(
                                            Icons.check,
                                            size: 19,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => openPage(
                                context,
                                ViolationDetailScreen(
                                  violation: demoStore.payable[i],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    demoStore.payable[i].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: ink,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '${demoStore.payable[i].plate} · ${demoStore.payable[i].date}',
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            riel(demoStore.payable[i].amount),
                            style: const TextStyle(
                              color: ink,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      if (i < demoStore.payable.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 16),
        AppPanel(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: demoStore.selectedTotal == 0
                ? null
                : () => openPage(
                    context,
                    ReviewPaymentScreen(
                      fines: demoStore.payable
                          .where(
                            (v) => demoStore.selectedFineIds.contains(v.id),
                          )
                          .toList(),
                    ),
                  ),
            icon: const Icon(Icons.lock_outline),
            label: Text('Pay ${riel(demoStore.selectedTotal)}'),
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('Payment history'),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const _HistoryRow(
                'Crossing stop line',
                '16 Aug 2026',
                '50,000 ៛',
                'Paid',
                Color(0xFF188653),
              ),
              const Divider(height: 1),
              const _HistoryRow(
                'Seatbelt fine',
                '12 Oct 2026',
                '20,000 ៛',
                'Pending',
                Color(0xFF9D6B00),
              ),
              const Divider(height: 1),
              const _HistoryRow(
                'Parking fine',
                '30 Jul 2026',
                '40,000 ៛',
                'Failed',
                Color(0xFFC32632),
              ),
              for (final fine in demoViolations.where(
                (v) => demoStore.paidFineIds.contains(v.id),
              )) ...[
                const Divider(height: 1),
                _HistoryRow(
                  fine.title,
                  'Demo payment',
                  riel(fine.amount),
                  'Paid',
                  const Color(0xFF188653),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow(
    this.title,
    this.date,
    this.amount,
    this.status,
    this.color,
  );
  final String title;
  final String date;
  final String amount;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      'Paid' => Icons.check_circle,
      'Pending' => Icons.hourglass_top,
      _ => Icons.error,
    };
    final background = switch (status) {
      'Paid' => const Color(0xFFE5F6EB),
      'Pending' => const Color(0xFFFFF4D9),
      _ => const Color(0xFFFDEBEC),
    };
    return InkWell(
      onTap: () => showDemoMessage(context, 'Payment history is demo data.'),
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
              child: const Icon(Icons.receipt_long_outlined, color: blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 13, color: color),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
