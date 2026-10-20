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
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: ink),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Verify your number',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to +855 ${widget.phone}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Stack(
                  children: [
                    Row(
                      children: List.generate(6, (index) {
                        final focused = _code.text.length == index;
                        final value = index < _code.text.length
                            ? _code.text[index]
                            : '';
                        return Expanded(
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: focused ? blue : const Color(0xFFC9D5E2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: ink,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Positioned.fill(
                      child: TextField(
                        controller: _code,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _verify(),
                        decoration: const InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: Colors.transparent),
                        cursorColor: Colors.transparent,
                        showCursor: false,
                        enableInteractiveSelection: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Resend code in 0:30',
                  style: TextStyle(color: muted, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: blue, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo prototype: use code 123456.',
                          style: TextStyle(
                            color: blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _code.text.length == 6 ? _verify : null,
                  style: FilledButton.styleFrom(
                    disabledBackgroundColor: blue.withValues(alpha: .45),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: .75,
                    ),
                  ),
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
