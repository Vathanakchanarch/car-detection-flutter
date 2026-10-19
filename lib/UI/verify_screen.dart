import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/demo_store.dart';
import 'app_shell.dart';
import 'widgets/app_components.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.phone});
  final String phone;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _verify() {
    if (_code.text != '123456') {
      showDemoMessage(context, 'Use the demo code 123456.');
      return;
    }
    demoStore.setPhone(widget.phone);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Colors.transparent),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Verify your number',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the 6-digit code sent to +855 ${widget.phone}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _code,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    letterSpacing: 20,
                    color: ink,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _verify(),
                  decoration: InputDecoration(
                    hintText: '• • • • • •',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Resend code in 0:30',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 16),
                const AppPanel(
                  child: Text(
                    'ℹ  Demo prototype: use code 123456.',
                    style: TextStyle(color: blue, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _code.text.length == 6 ? _verify : null,
                  child: const Text('Verify & continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
