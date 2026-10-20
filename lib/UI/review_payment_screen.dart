import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';
import '../l10n/demo_labels.dart';

import '../data/demo_data.dart';
import '../model/violation.dart';
import 'payment_flow_screens.dart';
import 'widgets/app_components.dart';

class ReviewPaymentScreen extends StatefulWidget {
  const ReviewPaymentScreen({super.key, required this.fines});
  final List<Violation> fines;
  @override
  State<ReviewPaymentScreen> createState() => _ReviewPaymentScreenState();
}

class _ReviewPaymentScreenState extends State<ReviewPaymentScreen> {
  bool _demoSelected = false;

  int get total => widget.fines.fold(0, (sum, fine) => sum + fine.amount);

  Future<void> _confirm() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: aicaSurface(dialogContext),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 358),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: aicaTone(dialogContext, const Color(0xFFEAF1FF)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 34,
                    color: aicaBlue(dialogContext),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  dialogContext.l10n.confirmPayment,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaInk(dialogContext),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  dialogContext.l10n.confirmPaymentBody(
                    widget.fines.length,
                    riel(total),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaMuted(dialogContext),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  dialogContext.l10n.demoPaymentDisclaimer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaMuted(dialogContext),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(dialogContext.l10n.confirmAndPay),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(dialogContext.l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (accepted != true || !mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            ProcessingPaymentScreen(fines: widget.fines, amount: total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: context.l10n.reviewPay,
    bottom: SafeArea(
      top: false,
      child: FilledButton.icon(
        onPressed: _demoSelected ? _confirm : null,
        icon: Icon(Icons.lock_outline),
        label: Text(context.l10n.payAmount(riel(total))),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: aicaTone(context, Color(0xFFFFF4D9)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.science,
                color: aicaTone(context, Color(0xFF9D6B00)),
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.paymentsAreNotConnectedToAnAuthorised,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaTone(context, Color(0xFF9D6B00)),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SectionTitle(context.l10n.fines),
        AppPanel(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final fine in widget.fines)
                InfoRow(violationTitle(context, fine), riel(fine.amount)),
              Divider(height: 1),
              InfoRow(context.l10n.total, riel(total)),
            ],
          ),
        ),
        SizedBox(height: 20),
        SectionTitle(context.l10n.paymentMethod),
        Opacity(
          opacity: .55,
          child: _PaymentOption(
            icon: Icons.account_balance,
            title: context.l10n.bankApp,
            subtitle: context.l10n.notConnectedYet,
            selected: true,
          ),
        ),
        SizedBox(height: 8),
        Opacity(
          opacity: .55,
          child: _PaymentOption(
            icon: Icons.phone_android,
            title: context.l10n.mobileWallet,
            subtitle: context.l10n.notConnectedYet,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _demoSelected = true),
          borderRadius: BorderRadius.circular(16),
          child: _PaymentOption(
            icon: Icons.science_outlined,
            title: context.l10n.demoSimulation,
            subtitle: context.l10n.prototypeOnly,
            selected: _demoSelected,
          ),
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, size: 14, color: aicaMuted(context)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                context.l10n.weNeverAskForOrStoreCard,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: aicaMuted(context),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: selected
          ? aicaTone(context, Color(0xFFEAF1FF))
          : aicaSurface(context),
      border: Border.all(
        color: selected ? aicaBlue(context) : aicaBorder(context),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aicaTone(context, Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: aicaInk(context)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: aicaInk(context),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
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
        Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: selected ? aicaBlue(context) : aicaBorder(context),
        ),
      ],
    ),
  );
}
