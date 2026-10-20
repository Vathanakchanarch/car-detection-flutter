import 'package:car_detection/UI/payment_flow_screens.dart';
import 'package:car_detection/UI/review_payment_screen.dart';
import 'package:car_detection/data/demo_data.dart';
import 'package:car_detection/data/demo_store.dart';
import 'package:car_detection/l10n/generated/app_localizations.dart';
import 'package:car_detection/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(demoStore.reset);

  Widget host(Widget home, {String language = 'en', bool dark = false}) =>
      MaterialApp(
        locale: Locale(language),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: home,
      );

  Future<void> openConfirmation(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Demo simulation'));
    await tester.tap(find.text('Demo simulation'));
    await tester.pump();
    await tester.tap(find.text('Pay 150,000 ៛'));
    await tester.pumpAndSettle();
  }

  testWidgets('payment confirmation appears and cancel closes it', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(ReviewPaymentScreen(fines: [demoViolations[1]])),
    );
    await openConfirmation(tester);

    expect(find.text('Confirm payment'), findsOneWidget);
    expect(
      find.text('This is a demo payment. No money will be transferred.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm payment'), findsNothing);
    expect(demoStore.paidFineIds, isEmpty);
  });

  testWidgets(
    'confirm processes dynamic amount then succeeds and pays locally',
    (tester) async {
      await tester.pumpWidget(
        host(ReviewPaymentScreen(fines: [demoViolations[1]])),
      );
      await openConfirmation(tester);
      await tester.tap(find.text('Confirm & pay'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Processing payment...'), findsOneWidget);
      final processingAmount = tester.widget<Text>(
        find.byKey(const Key('processing-payment-amount')),
      );
      expect(processingAmount.data, '150,000 ៛');
      expect(demoStore.paidFineIds, isEmpty);

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      expect(find.text('Payment successful'), findsOneWidget);
      expect(find.text('Your demo receipt is ready.'), findsOneWidget);
      expect(find.byKey(const Key('success-payment-amount')), findsOneWidget);
      expect(demoStore.paidFineIds, contains('speeding'));
    },
  );

  testWidgets('success opens a clearly labelled demo receipt', (tester) async {
    await tester.pumpWidget(
      host(
        PaymentSuccessScreen(
          fines: [demoViolations[1]],
          amount: demoViolations[1].amount,
        ),
      ),
    );

    await tester.tap(find.text('View demo receipt'));
    await tester.pumpAndSettle();

    expect(find.text('Demo receipt'), findsOneWidget);
    expect(find.text('DEMO-FN-20261009-232'), findsOneWidget);
    expect(find.text('Demo simulation'), findsOneWidget);
    expect(find.text('Demo paid'), findsOneWidget);
    expect(
      find.text('Prototype only — not an official government receipt.'),
      findsOneWidget,
    );
  });

  testWidgets('Back to Home leaves one AppShell route on its Home tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        PaymentSuccessScreen(
          fines: [demoViolations[1]],
          amount: demoViolations[1].amount,
        ),
      ),
    );

    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    expect(find.text('Recent alerts'), findsOneWidget);
    expect(find.text('Payment successful'), findsNothing);
  });

  for (final dark in [false, true]) {
    testWidgets('payment flow fits 320px in ${dark ? 'dark' : 'light'} mode', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        host(ReviewPaymentScreen(fines: [demoViolations[1]]), dark: dark),
      );
      await openConfirmation(tester);
      expect(tester.getSize(find.byType(Dialog)).width, lessThanOrEqualTo(320));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Confirm & pay'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();
      expect(find.text('Payment successful'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Khmer payment strings render through the complete flow', (
    tester,
  ) async {
    final km = await AppLocalizations.delegate.load(const Locale('km'));
    await tester.pumpWidget(
      host(ReviewPaymentScreen(fines: [demoViolations[1]]), language: 'km'),
    );
    await tester.ensureVisible(find.text(km.demoSimulation));
    await tester.tap(find.text(km.demoSimulation));
    await tester.pump();
    await tester.tap(find.text(km.payAmount('150,000 ៛')));
    await tester.pumpAndSettle();

    expect(find.text(km.confirmPayment), findsOneWidget);
    await tester.tap(find.text(km.confirmAndPay));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(km.processingPayment), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text(km.paymentSuccessful), findsOneWidget);
  });
}
