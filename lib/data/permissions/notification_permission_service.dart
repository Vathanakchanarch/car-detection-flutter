import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

enum NotificationPermissionState { granted, denied, permanentlyDenied }

abstract class NotificationPermissionGateway {
  Future<PermissionStatus> getStatus();

  Future<PermissionStatus> request();

  Future<bool> openSettings();
}

class PermissionHandlerNotificationGateway
    implements NotificationPermissionGateway {
  const PermissionHandlerNotificationGateway();

  @override
  Future<PermissionStatus> getStatus() => Permission.notification.status;

  @override
  Future<PermissionStatus> request() => Permission.notification.request();

  @override
  Future<bool> openSettings() => openAppSettings();
}

class NotificationPermissionService {
  const NotificationPermissionService()
    : _gateway = const PermissionHandlerNotificationGateway();

  const NotificationPermissionService.withGateway(this._gateway);

  final NotificationPermissionGateway _gateway;

  // This feature requests Android permission only; Linux has no plugin for it.
  bool get isSupported =>
      _gateway is! PermissionHandlerNotificationGateway ||
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);

  Future<NotificationPermissionState> getStatus() async {
    return _toAppState(await _gateway.getStatus());
  }

  Future<NotificationPermissionState> requestPermission() async {
    final currentStatus = await _gateway.getStatus();
    if (currentStatus.isGranted || currentStatus.isPermanentlyDenied) {
      return _toAppState(currentStatus);
    }
    return _toAppState(await _gateway.request());
  }

  Future<bool> openSettings() => _gateway.openSettings();

  NotificationPermissionState _toAppState(PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return NotificationPermissionState.granted;
    }
    if (status.isPermanentlyDenied) {
      return NotificationPermissionState.permanentlyDenied;
    }
    return NotificationPermissionState.denied;
  }
}
