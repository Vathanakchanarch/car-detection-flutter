import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';
import '../l10n/demo_labels.dart';

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
      padding: EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: [
        Text(
          context.l10n.payments,
          style: TextStyle(
            fontFamily: aicaFontFamily,
            fontFamilyFallback: khmerFontFallback,
            color: aicaInk(context),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: SectionTitle(context.l10n.finesToPay)),
            TextButton(
              onPressed: demoStore.clearFines,
              child: Text(context.l10n.clear),
            ),
          ],
        ),
        AppPanel(
          padding: EdgeInsets.zero,
          child: demoStore.payable.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(context.l10n.noFinesToPay),
                )
              : Column(
                  children: [
                    for (var i = 0; i < demoStore.payable.length; i++) ...[
                      Row(
                        children: [
                          Semantics(
                            label: context.l10n.selectFine,
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
                                          ? aicaBlue(context)
                                          : aicaSurface(context),
                                      border: Border.all(
                                        color: aicaBlue(context),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        demoStore.selectedFineIds.contains(
                                          demoStore.payable[i].id,
                                        )
                                        ? Icon(
                                            Icons.check,
                                            size: 19,
                                            color: aicaSurface(context),
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
                                    violationTitle(
                                      context,
                                      demoStore.payable[i],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: aicaFontFamily,
                                      fontFamilyFallback: khmerFontFallback,
                                      color: aicaInk(context),
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '${demoStore.payable[i].plate} · ${demoStore.payable[i].date}',
                                    style: TextStyle(
                                      fontFamily: aicaFontFamily,
                                      fontFamilyFallback: khmerFontFallback,
                                      color: aicaMuted(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            riel(demoStore.payable[i].amount),
                            style: TextStyle(
                              fontFamily: aicaFontFamily,
                              fontFamilyFallback: khmerFontFallback,
                              color: aicaInk(context),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                      if (i < demoStore.payable.length - 1) Divider(height: 1),
                    ],
                  ],
                ),
        ),
        SizedBox(height: 16),
        AppPanel(
          padding: EdgeInsets.all(12),
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
            icon: Icon(Icons.lock_outline),
            label: Text(context.l10n.payAmount(riel(demoStore.selectedTotal))),
          ),
        ),
        SizedBox(height: 28),
        SectionTitle(context.l10n.paymentHistory),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _HistoryRow(
                context.l10n.crossingStopLine,
                '16 Aug 2026',
                '50,000 ៛',
                'Paid',
                aicaTone(context, Color(0xFF188653)),
              ),
              Divider(height: 1),
              _HistoryRow(
                context.l10n.seatbeltFine,
                '12 Oct 2026',
                '20,000 ៛',
                'Pending',
                aicaTone(context, Color(0xFF9D6B00)),
              ),
              Divider(height: 1),
              _HistoryRow(
                context.l10n.parkingFine,
                '30 Jul 2026',
                '40,000 ៛',
                'Failed',
                aicaTone(context, Color(0xFFC32632)),
              ),
              for (final fine in demoViolations.where(
                (v) => demoStore.paidFineIds.contains(v.id),
              )) ...[
                Divider(height: 1),
                _HistoryRow(
                  violationTitle(context, fine),
                  context.l10n.demoPayment,
                  riel(fine.amount),
                  'Paid',
                  aicaTone(context, Color(0xFF188653)),
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
      'Paid' => aicaTone(context, Color(0xFFE5F6EB)),
      'Pending' => aicaTone(context, Color(0xFFFFF4D9)),
      _ => aicaTone(context, Color(0xFFFDEBEC)),
    };
    return InkWell(
      onTap: () =>
          showDemoMessage(context, context.l10n.paymentHistoryIsDemoData),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aicaTone(context, Color(0xFFEAF1FF)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: aicaBlue(context),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: aicaInk(context),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: aicaMuted(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaInk(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: aicaTone(context, background),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 13, color: color),
                      SizedBox(width: 4),
                      Text(
                        paymentStatusLabel(context, status),
                        style: TextStyle(
                          fontFamily: aicaFontFamily,
                          fontFamilyFallback: khmerFontFallback,
                          color: aicaTone(context, color),
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
