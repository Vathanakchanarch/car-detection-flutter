import 'package:flutter/material.dart';

import '../data/demo_store.dart';
import 'licence_screen.dart';
import 'settings_screen.dart';
import 'sign_in_screen.dart';
import 'vehicles_screen.dart';
import 'widgets/app_components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: demoStore,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            color: ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        AppPanel(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: ink,
                child: Text(
                  'SV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    demoStore.name,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '+855 ${demoStore.phone}',
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F6EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✓ Phone verified',
                      style: TextStyle(
                        color: Color(0xFF188653),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'MY ACCOUNT',
          style: TextStyle(
            color: muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MenuRow(
                Icons.person_outline,
                'Personal information',
                () => openPage(context, const PersonalInfoScreen()),
              ),
              const Divider(height: 1),
              _MenuRow(
                Icons.directions_car_outlined,
                'My vehicles',
                () => openPage(context, const VehiclesScreen()),
                subtitle: '2 registered',
              ),
              const Divider(height: 1),
              _MenuRow(
                Icons.badge_outlined,
                'Driving licence',
                () => openPage(context, const LicenceScreen()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'SETTINGS',
          style: TextStyle(
            color: muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MenuRow(
                Icons.translate,
                'Language',
                () => openPage(context, const LanguageScreen()),
                subtitle: 'English',
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.dark_mode_outlined, color: blue),
                ),
                title: const Text(
                  'Dark mode',
                  style: TextStyle(
                    color: ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (_) => showDemoMessage(
                    context,
                    'Dark mode is not part of this Flutter demo yet.',
                  ),
                ),
              ),
              const Divider(height: 1),
              _MenuRow(
                Icons.notifications_none,
                'Notification preferences',
                () => openPage(context, const NotificationPreferencesScreen()),
              ),
              const Divider(height: 1),
              _MenuRow(
                Icons.lock_outline,
                'Privacy & security',
                () => openPage(context, const PrivacyScreen()),
              ),
              const Divider(height: 1),
              _MenuRow(
                Icons.help_outline,
                'Help & support',
                () => openPage(context, const HelpScreen()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
            (_) => false,
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFDEBEC),
            foregroundColor: const Color(0xFFC32632),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Cambodia Smart Traffic · v1.0.0 (demo)',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.label, this.onTap, {this.subtitle});
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    leading: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: blue),
    ),
    title: Text(
      label,
      style: const TextStyle(
        color: ink,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: const Icon(Icons.chevron_right, color: muted),
    onTap: onTap,
  );
}
