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
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: demoStore.markAllRead,
              child: const Text('Mark all read'),
            ),
          ),
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
              child: AppPanel(
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!demoStore.readNotificationIds.contains(i))
                          const CircleAvatar(radius: 4, backgroundColor: blue),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      demoNotifications[i].message,
                      style: const TextStyle(color: muted),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      demoNotifications[i].when,
                      style: const TextStyle(color: muted, fontSize: 12),
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
}
