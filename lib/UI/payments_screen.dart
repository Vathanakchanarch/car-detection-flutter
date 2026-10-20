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
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: Checkbox(
                              value: demoStore.selectedFineIds.contains(
                                demoStore.payable[i].id,
                              ),
                              onChanged: (_) =>
                                  demoStore.toggleFine(demoStore.payable[i].id),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: blue, width: 2),
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
                              fontWeight: FontWeight.w700,
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
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    leading: Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.receipt_long_outlined, color: blue),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: ink,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
      ),
    ),
    subtitle: Text(date),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount,
          style: const TextStyle(color: ink, fontWeight: FontWeight.w700),
        ),
        Text(status, style: TextStyle(color: color, fontSize: 12)),
      ],
    ),
    onTap: () => showDemoMessage(context, 'Payment history is demo data.'),
  );
}
