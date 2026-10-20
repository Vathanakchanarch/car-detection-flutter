import 'package:flutter/material.dart';

import '../data/demo_store.dart';
import 'widgets/app_components.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final _name = TextEditingController(text: demoStore.name);
  late final _email = TextEditingController(text: demoStore.email);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Personal information',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Full name',
          style: TextStyle(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _name,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        const Text(
          'Phone',
          style: TextStyle(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFC9D5E2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text(
                '+855',
                style: TextStyle(
                  color: ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 1, height: 24, color: const Color(0xFFC9D5E2)),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  demoStore.phone,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Email (optional)',
          style: TextStyle(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'name@example.com',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) {
              showDemoMessage(context, 'Please enter your name.');
              return;
            }
            demoStore.setProfile(_name.text.trim(), _email.text.trim());
            showDemoMessage(context, 'Demo profile saved locally.');
          },
          child: const Text('Save changes'),
        ),
      ],
    ),
  );
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selected = 'English';
  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Language',
    child: AppPanel(
      child: Column(
        children: [
          for (final language in ['English', 'ខ្មែរ'])
            ListTile(
              title: Text(language),
              trailing: Icon(
                selected == language
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: blue,
              ),
              onTap: () {
                setState(() => selected = language);
                if (selected != 'English') {
                  showDemoMessage(
                    context,
                    'Khmer translation is not included in this demo yet.',
                  );
                }
              },
            ),
        ],
      ),
    ),
  );
}

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});
  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Notification preferences',
    child: AppPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, key)
              in demoStore.notificationPreferences.keys.indexed) ...[
            if (index > 0) const Divider(height: 1),
            AppMenuRow(
              icon: Icons.notifications_none,
              label: key,
              trailing: Switch(
                value: demoStore.notificationPreferences[key]!,
                onChanged: (value) =>
                    setState(() => demoStore.setPreference(key, value)),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _biometricPreview = true;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Privacy & security',
    child: Column(
      children: [
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppMenuRow(
                icon: Icons.fingerprint,
                label: 'Biometric unlock',
                trailing: Switch(
                  value: _biometricPreview,
                  onChanged: (value) {
                    setState(() => _biometricPreview = value);
                    showDemoMessage(
                      context,
                      'Biometric unlock is a visual demo only.',
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              AppMenuRow(
                icon: Icons.password,
                label: 'Change app PIN',
                onTap: () => showDemoMessage(
                  context,
                  'App PIN is not configured in this demo.',
                ),
              ),
              const Divider(height: 1),
              AppMenuRow(
                icon: Icons.download,
                label: 'Download my data',
                onTap: () =>
                    showDemoMessage(context, 'Data export needs a backend.'),
              ),
              const Divider(height: 1),
              AppMenuRow(
                icon: Icons.delete_outline,
                label: 'Delete account',
                danger: true,
                onTap: () => showDemoMessage(
                  context,
                  'Account deletion needs a backend.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock, color: blue, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your data is used only to show your own records.',
                  style: TextStyle(color: blue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Help & support',
    child: AppPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppMenuRow(
            icon: Icons.quiz_outlined,
            label: 'FAQs',
            onTap: () => showDemoMessage(
              context,
              'FAQs are not connected in this demo.',
            ),
          ),
          const Divider(height: 1),
          AppMenuRow(
            icon: Icons.call_outlined,
            label: 'Call support',
            subtitle: 'Demo number',
            onTap: () => showDemoMessage(
              context,
              'Support number is a demo placeholder.',
            ),
          ),
          const Divider(height: 1),
          AppMenuRow(
            icon: Icons.chat_outlined,
            label: 'Chat with us',
            onTap: () =>
                showDemoMessage(context, 'Chat support needs a backend.'),
          ),
        ],
      ),
    ),
  );
}
