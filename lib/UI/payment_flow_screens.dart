import 'dart:async';

import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import '../l10n/l10n_context.dart';
import '../model/violation.dart';
import '../theme/app_colors.dart';
import 'app_shell.dart';
import 'widgets/app_components.dart';

class ProcessingPaymentScreen extends StatefulWidget {
  const ProcessingPaymentScreen({
    super.key,
    required this.fines,
    required this.amount,
    this.processingDuration = const Duration(milliseconds: 1400),
  });

  final List<Violation> fines;
  final int amount;
  final Duration processingDuration;

  @override
  State<ProcessingPaymentScreen> createState() =>
      _ProcessingPaymentScreenState();
}

class _ProcessingPaymentScreenState extends State<ProcessingPaymentScreen> {
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.processingDuration, _completePayment);
  }

  void _completePayment() {
    if (!mounted || _completed) return;
    _completed = true;
    demoStore.payFines(widget.fines.map((fine) => fine.id));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            PaymentSuccessScreen(fines: widget.fines, amount: widget.amount),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: mobileContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: aicaTone(context, const Color(0xFFFFF4D9)),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: aicaTone(context, const Color(0xFF9D6B00)),
                        backgroundColor: aicaTone(
                          context,
                          const Color(0xFFFFE4A3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    context.l10n.processingPayment,
                    textAlign: TextAlign.center,
                    style: _flowTitleStyle(context),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.pleaseDontCloseTheApp,
                    textAlign: TextAlign.center,
                    style: _flowBodyStyle(context),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    riel(widget.amount),
                    key: const Key('processing-payment-amount'),
                    textAlign: TextAlign.center,
                    style: _amountStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.fines,
    required this.amount,
  });

  final List<Violation> fines;
  final int amount;

  void _backToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: mobileContentWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).vertical -
                    56,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: aicaTone(context, const Color(0xFFE5F6EB)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 58,
                        color: aicaTone(context, const Color(0xFF188653)),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      context.l10n.paymentSuccessful,
                      textAlign: TextAlign.center,
                      style: _flowTitleStyle(context),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.yourDemoReceiptIsReady,
                      textAlign: TextAlign.center,
                      style: _flowBodyStyle(context),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      riel(amount),
                      key: const Key('success-payment-amount'),
                      textAlign: TextAlign.center,
                      style: _amountStyle(context),
                    ),
                    const Spacer(),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => openPage(
                          context,
                          DemoReceiptScreen(fines: fines, amount: amount),
                        ),
                        child: Text(context.l10n.viewDemoReceipt),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _backToHome(context),
                      child: Text(context.l10n.backToHome),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DemoReceiptScreen extends StatelessWidget {
  const DemoReceiptScreen({
    super.key,
    required this.fines,
    required this.amount,
  });

  final List<Violation> fines;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final references = fines.map((fine) => fine.reference).join(', ');
    final date = fines.isEmpty ? '—' : fines.first.date;
    return DetailPage(
      title: context.l10n.demoReceiptTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: aicaTone(context, const Color(0xFFFFF4D9)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.science_outlined,
                  size: 20,
                  color: aicaTone(context, const Color(0xFF9D6B00)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.prototypeNotOfficialReceipt,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: aicaTone(context, const Color(0xFF9D6B00)),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPanel(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 40,
                  color: aicaBlue(context),
                ),
                const SizedBox(height: 12),
                Text(riel(amount), style: _amountStyle(context)),
                const SizedBox(height: 18),
                const Divider(height: 1),
                InfoRow(context.l10n.violationReference, references),
                const Divider(height: 1),
                InfoRow(context.l10n.date, date),
                const Divider(height: 1),
                InfoRow(
                  context.l10n.paymentMethod,
                  context.l10n.demoSimulationPaymentMethod,
                ),
                const Divider(height: 1),
                InfoRow(context.l10n.status, context.l10n.demoPaid),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _flowTitleStyle(BuildContext context) => TextStyle(
  fontFamily: aicaFontFamily,
  fontFamilyFallback: khmerFontFallback,
  color: aicaInk(context),
  fontSize: 26,
  fontWeight: FontWeight.w800,
  height: 1.2,
);

TextStyle _flowBodyStyle(BuildContext context) => TextStyle(
  fontFamily: aicaFontFamily,
  fontFamilyFallback: khmerFontFallback,
  color: aicaMuted(context),
  fontSize: 15,
  height: 1.5,
);

TextStyle _amountStyle(BuildContext context) => TextStyle(
  fontFamily: aicaFontFamily,
  fontFamilyFallback: khmerFontFallback,
  color: aicaInk(context),
  fontSize: 30,
  fontWeight: FontWeight.w800,
  height: 1.15,
);
