import 'package:car_detection/UI/settings_screen.dart';
import 'package:car_detection/data/permissions/notification_permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

class FakeNotificationPermissionGateway
    implements NotificationPermissionGateway {
  FakeNotificationPermissionGateway({
    required this.status,
    this.requestResult = PermissionStatus.denied,
    this.settingsResult = true,
  });

  PermissionStatus status;
  PermissionStatus requestResult;
  bool settingsResult;
  int requestCount = 0;
  int settingsCount = 0;

  @override
  Future<PermissionStatus> getStatus() async => status;

  @override
  Future<PermissionStatus> request() async {
    requestCount++;
    status = requestResult;
    return requestResult;
  }

  @override
  Future<bool> openSettings() async {
    settingsCount++;
    return settingsResult;
  }
}

void main() {
  test('reports granted permission', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.granted,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    expect(await service.getStatus(), NotificationPermissionState.granted);
  });

  test('reports denied permission', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.denied,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    expect(await service.getStatus(), NotificationPermissionState.denied);
  });

  test('reports permanently denied permission', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.permanentlyDenied,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    expect(
      await service.getStatus(),
      NotificationPermissionState.permanentlyDenied,
    );
  });

  test('does not request permission when it is already granted', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.granted,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    final result = await service.requestPermission();

    expect(result, NotificationPermissionState.granted);
    expect(gateway.requestCount, 0);
  });

  test('requests denied permission and returns the Android result', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.denied,
      requestResult: PermissionStatus.granted,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    final result = await service.requestPermission();

    expect(result, NotificationPermissionState.granted);
    expect(gateway.requestCount, 1);
  });

  test('does not repeat a permanently denied request', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.permanentlyDenied,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    final result = await service.requestPermission();

    expect(result, NotificationPermissionState.permanentlyDenied);
    expect(gateway.requestCount, 0);
  });

  test('opens app settings through the permission gateway', () async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.permanentlyDenied,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    expect(await service.openSettings(), isTrue);
    expect(gateway.settingsCount, 1);
  });

  testWidgets('notification settings requests permission only after a tap', (
    tester,
  ) async {
    final gateway = FakeNotificationPermissionGateway(
      status: PermissionStatus.denied,
      requestResult: PermissionStatus.granted,
    );
    final service = NotificationPermissionService.withGateway(gateway);

    await tester.pumpWidget(
      MaterialApp(
        home: NotificationPreferencesScreen(permissionService: service),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Not allowed'), findsOneWidget);
    expect(find.text('Enable'), findsOneWidget);
    expect(gateway.requestCount, 0);

    await tester.tap(find.text('Enable'));
    await tester.pumpAndSettle();

    expect(gateway.requestCount, 1);
    expect(find.text('Allowed'), findsOneWidget);
  });
}
