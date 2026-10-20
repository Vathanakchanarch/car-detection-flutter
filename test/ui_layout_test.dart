import 'package:car_detection/UI/profile_screen.dart';
import 'package:car_detection/UI/review_payment_screen.dart';
import 'package:car_detection/UI/vehicles_screen.dart';
import 'package:car_detection/UI/verify_screen.dart';
import 'package:car_detection/UI/violation_detail_screen.dart';
import 'package:car_detection/data/demo_data.dart';
import 'package:car_detection/data/demo_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(demoStore.reset);

  for (final width in [320.0, 1280.0]) {
    testWidgets('all mobile sheets fit a $width pixel window', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 720));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final (screen, action) in <(Widget, String)>[
        (const ProfileScreen(), 'Language'),
        (const VehiclesScreen(), 'Add'),
        (
          ViolationDetailScreen(violation: demoViolations.first),
          'Explain this violation',
        ),
      ]) {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: screen)));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(action));
        await tester.tap(find.text(action));
        await tester.pumpAndSettle();
        final sheet = find.byType(BottomSheet);
        final surface = find
            .descendant(of: sheet, matching: find.byType(Material))
            .first;
        expect(tester.getSize(surface).width, lessThanOrEqualTo(390));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      }
    });
  }

  for (final width in [320.0, 1280.0]) {
    testWidgets('review pay button and dialog fit $width with bottom inset', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(padding: const EdgeInsets.only(bottom: 34)),
            child: child!,
          ),
          home: ReviewPaymentScreen(fines: [demoViolations[1]]),
        ),
      );
      final pay = find.widgetWithText(FilledButton, 'Pay 150,000 ៛');
      expect(tester.getRect(pay).bottom, lessThanOrEqualTo(566));
      expect(tester.getSize(pay).width, lessThanOrEqualTo(390));
      await tester.ensureVisible(find.text('Demo simulation'));
      await tester.tap(find.text('Demo simulation'));
      await tester.pump();
      await tester.tap(pay);
      await tester.pumpAndSettle();
      expect(find.text('Confirm payment'), findsOneWidget);
      expect(
        tester
            .getSize(
              find
                  .descendant(
                    of: find.byType(Dialog),
                    matching: find.byType(Material),
                  )
                  .first,
            )
            .width,
        lessThanOrEqualTo(358),
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(demoStore.paidFineIds, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('OTP remains scrollable with a short keyboard viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 360));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: VerifyScreen(phone: '12345678')),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Verify & continue'));
    expect(find.text('Verify & continue'), findsOneWidget);
  });
}
