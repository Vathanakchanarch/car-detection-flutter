import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';
import '../l10n/demo_labels.dart';

import '../data/demo_store.dart';
import '../data/onboarding_content.dart';
import 'sign_in_screen.dart';
import 'widgets/traffic_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  Future<void> _openSignIn() async {
    await demoStore.completeOnboarding();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => SignInScreen()));
  }

  void _next() {
    if (_index == onboardingPages.length - 1) {
      _openSignIn();
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 12, 0),
                child: SizedBox(
                  height: 44,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _openSignIn,
                      style: TextButton.styleFrom(
                        foregroundColor: aicaMuted(context),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        textStyle: TextStyle(
                          fontFamily: aicaFontFamily,
                          fontFamilyFallback: khmerFontFallback,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(context.l10n.skip),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) {
                    final page = onboardingPages[index];
                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TrafficIllustration(
                                artwork: page.artwork,
                                backgroundColor: page.backgroundColor,
                              ),
                              SizedBox(height: 16),
                              Text(
                                onboardingTitle(context, index),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              SizedBox(height: 12),
                              Text(
                                onboardingDescription(context, index),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingPages.length, (index) {
                  final selected = index == _index;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 220),
                    width: selected ? 32 : 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: selected ? aicaBlue(context) : aicaBorder(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 36),
                child: FilledButton.icon(
                  onPressed: _next,
                  icon: Icon(
                    _index == onboardingPages.length - 1
                        ? Icons.rocket_launch_outlined
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _index == onboardingPages.length - 1
                        ? context.l10n.getStarted
                        : context.l10n.next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
