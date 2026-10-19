import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'verify_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  bool _consented = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendCode() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (!_consented || digits.length < 8 || digits.length > 9) {
      final message = !_consented
          ? 'Please agree to the terms before continuing.'
          : 'Enter a valid Cambodian phone number.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => VerifyScreen(phone: digits)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF17324A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.traffic_rounded,
                              color: Color(0xFF61A0FF),
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'Welcome back',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sign in or create an account with your phone number. We will send a one-time code.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Phone number',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263D52),
                          ),
                        ),
                        const SizedBox(height: 7),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 16, right: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇰🇭 +855'),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 25,
                                    child: VerticalDivider(width: 1),
                                  ),
                                ],
                              ),
                            ),
                            hintText: '12 345 678',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E7EF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E7EF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Example: 12 345 678',
                          style: TextStyle(
                            color: Color(0xFF748296),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _consented,
                              onChanged: (value) =>
                                  setState(() => _consented = value ?? false),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'I agree to the Terms and the Privacy Notice. My phone number and vehicle data are used only to show my own records.',
                                  style: TextStyle(
                                    color: Color(0xFF667789),
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: _sendCode,
                          icon: const Icon(Icons.sms_outlined),
                          label: const Text('Send code'),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Demo prototype. No SMS will be sent. Not an official government app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF748296),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
