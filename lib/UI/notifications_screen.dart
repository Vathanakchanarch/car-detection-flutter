import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: demoStore,
    builder: (context, _) => DetailPage(
      title: 'Notifications',
      actions: [
        TextButton(
          onPressed: demoStore.markAllRead,
          child: const Text(
            'Mark all read',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 4),
      ],
      child: Column(
        children: [
          for (var i = 0; i < demoNotifications.length; i++) ...[
            InkWell(
              onTap: () {
                demoStore.markRead(i);
                final id = demoNotifications[i].violationId;
                if (id != null) {
                  final violation = demoViolations
                      .where((v) => v.id == id)
                      .first;
                  openPage(
                    context,
                    ViolationDetailScreen(violation: violation),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: demoStore.readNotificationIds.contains(i)
                      ? Colors.white
                      : const Color(0xFFEAF1FF),
                  border: Border.all(
                    color: demoStore.readNotificationIds.contains(i)
                        ? const Color(0xFFC9D5E2)
                        : blue.withValues(alpha: .3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _notificationColor(i).withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _notificationIcon(i),
                        color: _notificationColor(i),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  demoNotifications[i].title,
                                  style: const TextStyle(
                                    color: ink,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (!demoStore.readNotificationIds.contains(i))
                                const CircleAvatar(
                                  radius: 5,
                                  backgroundColor: blue,
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            demoNotifications[i].message,
                            style: const TextStyle(color: muted, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            demoNotifications[i].when,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    ),
  );

  static IconData _notificationIcon(int index) => switch (index) {
    0 => Icons.videocam,
    1 => Icons.gavel,
    2 => Icons.schedule,
    3 => Icons.forum,
    4 => Icons.check_circle,
    _ => Icons.badge,
  };

  static Color _notificationColor(int index) => switch (index) {
    0 || 2 => const Color(0xFF9D6B00),
    1 => const Color(0xFFC32632),
    3 => const Color(0xFF7542B5),
    4 => const Color(0xFF188653),
    _ => blue,
  };
}
