import 'package:flutter/foundation.dart';

import '../model/violation.dart';
import 'demo_data.dart';

class DemoStore extends ChangeNotifier {
  String phone = '12 345 678';
  String name = 'Sophea Vann';
  String email = '';
  bool darkMode = false;
  final Set<String> selectedFineIds = {'speeding', 'helmet'};
  final Set<String> paidFineIds = {};
  final Set<int> readNotificationIds = {3, 4, 5};
  final Map<String, String> appeals = {};
  final Map<String, bool> notificationPreferences = {
    'New potential violations': true,
    'Official fine confirmed': true,
    'Payment reminders': true,
    'Tips & news': false,
  };

  List<Violation> get payable => demoViolations
      .where(
        (v) =>
            v.status == ViolationStatus.confirmed &&
            !paidFineIds.contains(v.id),
      )
      .toList();
  int get selectedTotal => payable
      .where((v) => selectedFineIds.contains(v.id))
      .fold(0, (sum, v) => sum + v.amount);

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
    notifyListeners();
  }

  void toggleFine(String id) {
    selectedFineIds.contains(id)
        ? selectedFineIds.remove(id)
        : selectedFineIds.add(id);
    notifyListeners();
  }

  void clearFines() {
    selectedFineIds.clear();
    notifyListeners();
  }

  void payFines(Iterable<String> ids) {
    paidFineIds.addAll(ids);
    selectedFineIds.removeAll(ids.toSet());
    notifyListeners();
  }

  void submitAppeal(String id, String explanation) {
    appeals[id] = explanation;
    notifyListeners();
  }

  void markRead(int id) {
    readNotificationIds.add(id);
    notifyListeners();
  }

  void markAllRead() {
    readNotificationIds.addAll(
      List.generate(demoNotifications.length, (index) => index),
    );
    notifyListeners();
  }

  void setPreference(String key, bool value) {
    notificationPreferences[key] = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void reset() {
    phone = '12 345 678';
    name = 'Sophea Vann';
    email = '';
    darkMode = false;
    selectedFineIds
      ..clear()
      ..addAll({'speeding', 'helmet'});
    paidFineIds.clear();
    readNotificationIds
      ..clear()
      ..addAll({3, 4, 5});
    appeals.clear();
    notificationPreferences
      ..clear()
      ..addAll({
        'New potential violations': true,
        'Official fine confirmed': true,
        'Payment reminders': true,
        'Tips & news': false,
      });
    notifyListeners();
  }
}

final demoStore = DemoStore();
