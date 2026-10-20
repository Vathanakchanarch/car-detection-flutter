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
          constraints: const BoxConstraints(maxWidth: 390),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              32,
              24,
              MediaQuery.sizeOf(context).height < 700 ? 8 : 32,
            ),
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
                              color: const Color(0xFF102A43),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.traffic_rounded,
                              color: Color(0xFF60A5FA),
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome back',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in or create an account with your phone number. We will send a one-time code.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF102A43),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 16, right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '+855',
                                    style: TextStyle(
                                      color: Color(0xFF102A43),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 12),
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
                                color: Color(0xFFC9D5E2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFC9D5E2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Example: 12 345 678',
                          style: TextStyle(
                            color: Color(0xFF526579),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () => setState(() => _consented = !_consented),
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _consented
                                      ? const Color(0xFF2563EB)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: const Color(0xFF2563EB),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _consented
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms and the Privacy Notice. My phone number and vehicle data are used only to show my own records.',
                                  style: TextStyle(
                                    color: Color(0xFF526579),
                                    fontSize: 13,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Transform.translate(
                          offset: Offset(
                            0,
                            MediaQuery.sizeOf(context).height < 700 ? -32 : 0,
                          ),
                          child: FilledButton.icon(
                            onPressed: _sendCode,
                            icon: const Icon(Icons.sms_outlined),
                            label: const Text('Send code'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '🔒 Encrypted. Not an official government app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF526579),
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
