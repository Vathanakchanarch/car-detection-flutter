import 'package:flutter/material.dart';

import '../data/demo_store.dart';
import 'licence_screen.dart';
import 'settings_screen.dart';
import 'sign_in_screen.dart';
import 'vehicles_screen.dart';
import 'widgets/app_components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageSheet(BuildContext context) {
    String selected = 'English';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9D5E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose language',
                style: TextStyle(
                  color: ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              for (final (code, language) in [
                ('EN', 'English'),
                ('ខ្ម', 'ខ្មែរ'),
              ]) ...[
                InkWell(
                  onTap: () {
                    setSheetState(() => selected = language);
                    if (language != 'English') {
                      showDemoMessage(
                        context,
                        'Khmer translation is not included in this demo yet.',
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected == language
                          ? const Color(0xFFEAF1FF)
                          : Colors.white,
                      border: Border.all(
                        color: selected == language
                            ? blue
                            : const Color(0xFFC9D5E2),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            language,
                            style: const TextStyle(
                              color: ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (selected == language)
                          const Icon(Icons.check_circle, color: blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demoStore.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '+855 ${demoStore.phone}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                () => _showLanguageSheet(context),
                subtitle: 'English',
              ),
              const Divider(height: 1),
              AppMenuRow(
                icon: Icons.dark_mode_outlined,
                label: 'Dark mode',
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
  Widget build(BuildContext context) =>
      AppMenuRow(icon: icon, label: label, subtitle: subtitle, onTap: onTap);
}
