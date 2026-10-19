class AppNotification {
  const AppNotification({
    required this.title,
    required this.message,
    required this.when,
    this.violationId,
  });

  final String title;
  final String message;
  final String when;
  final String? violationId;
}
