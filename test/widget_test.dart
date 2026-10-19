import 'package:car_detection/main.dart';
import 'package:car_detection/UI/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding leads to phone sign in', (tester) async {
    await tester.pumpWidget(const SmartTrafficApp());
    expect(find.text('Smart traffic monitoring'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '12345678');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.tap(find.text('Verify & continue'));
    await tester.pumpAndSettle();
    expect(find.text('Sophea Vann'), findsWidgets);
    expect(find.text('Recent alerts'), findsOneWidget);
  });

  testWidgets('violations can be filtered to payable fines', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    await tester.tap(find.byIcon(Icons.shield_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Violations'), findsWidgets);

    await tester.tap(find.text('To pay 2'));
    await tester.pumpAndSettle();
    expect(find.text('Speeding (68 km/h in 50 zone)'), findsOneWidget);
    expect(find.text('Possible red-light violation'), findsNothing);
  });
}
