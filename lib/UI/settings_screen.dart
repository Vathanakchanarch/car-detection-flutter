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
          style: TextStyle(color: ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _name,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 18),
        const Text(
          'Phone',
          style: TextStyle(color: ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        InputDecorator(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          child: Text('+855 ${demoStore.phone}'),
        ),
        const SizedBox(height: 18),
        const Text(
          'Email (optional)',
          style: TextStyle(color: ink, fontWeight: FontWeight.w600),
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
        const SizedBox(height: 18),
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
          for (final key in demoStore.notificationPreferences.keys)
            SwitchListTile(
              secondary: const Icon(Icons.notifications_none, color: blue),
              title: Text(key),
              value: demoStore.notificationPreferences[key]!,
              onChanged: (value) =>
                  setState(() => demoStore.setPreference(key, value)),
            ),
        ],
      ),
    ),
  );
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Privacy & security',
    child: Column(
      children: [
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Biometric unlock'),
                secondary: const Icon(Icons.fingerprint, color: blue),
                value: false,
                onChanged: (_) => showDemoMessage(
                  context,
                  'Biometric unlock needs platform integration.',
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Change app PIN'),
                leading: const Icon(Icons.password, color: blue),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showDemoMessage(
                  context,
                  'App PIN is not configured in this demo.',
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Download my data'),
                leading: const Icon(Icons.download, color: blue),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    showDemoMessage(context, 'Data export needs a backend.'),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Delete account'),
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showDemoMessage(
                  context,
                  'Account deletion needs a backend.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const AppPanel(
          child: Text(
            '🔒 Your data is used only to show your own records.',
            style: TextStyle(color: blue),
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
          ListTile(
            title: const Text('FAQs'),
            leading: const Icon(Icons.help_outline, color: blue),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDemoMessage(
              context,
              'FAQs are not connected in this demo.',
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Call support'),
            subtitle: const Text('Demo number'),
            leading: const Icon(Icons.call_outlined, color: blue),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDemoMessage(
              context,
              'Support number is a demo placeholder.',
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Chat with us'),
            leading: const Icon(Icons.chat_outlined, color: blue),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                showDemoMessage(context, 'Chat support needs a backend.'),
          ),
        ],
      ),
    ),
  );
}
