import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import 'licence_screen.dart';
import 'notifications_screen.dart';
import 'vehicles_screen.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: demoStore,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: ink,
              child: Text(
                'SV',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good morning',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  Text(
                    demoStore.name,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => openPage(context, const NotificationsScreen()),
              icon: const Badge(
                label: Text('3'),
                child: Icon(Icons.notifications_none_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF17324A), Color(0xFF18417E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'You have fines to pay',
                style: TextStyle(color: Color(0xFFB8C9D9)),
              ),
              const SizedBox(height: 5),
              Text(
                riel(demoStore.payable.fold(0, (sum, v) => sum + v.amount)),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                '2 confirmed · pay by 31 Oct 2026',
                style: TextStyle(color: Color(0xFFB8C9D9)),
              ),
              const SizedBox(height: 18),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ink,
                ),
                onPressed: () => onSelectTab(2),
                child: const Text('🔒  Pay now'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _Shortcut(
              Icons.payments_outlined,
              'Pay fines',
              () => onSelectTab(2),
            ),
            _Shortcut(Icons.gavel, 'Appeal', () => onSelectTab(1)),
            _Shortcut(
              Icons.directions_car_outlined,
              'Vehicles',
              () => openPage(context, const VehiclesScreen()),
            ),
            _Shortcut(
              Icons.badge_outlined,
              'Licence',
              () => openPage(context, const LicenceScreen()),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(child: SectionTitle('Recent alerts')),
            TextButton(
              onPressed: () => onSelectTab(1),
              child: const Text('See all'),
            ),
          ],
        ),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < 3; i++) ...[
                ViolationTile(
                  violation: demoViolations[i],
                  onTap: () => openPage(
                    context,
                    ViolationDetailScreen(violation: demoViolations[i]),
                  ),
                ),
                if (i < 2) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _Shortcut extends StatelessWidget {
  const _Shortcut(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8EF)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: blue),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(
              color: ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
