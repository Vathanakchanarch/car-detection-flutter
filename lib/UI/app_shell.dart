import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';

import '../data/demo_store.dart';
import 'home_screen.dart';
import 'payments_screen.dart';
import 'profile_screen.dart';
import 'violations_screen.dart';
import 'widgets/app_components.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onSelectTab: (index) => setState(() => _tab = index)),
      ViolationsScreen(),
      PaymentsScreen(),
      ProfileScreen(),
    ];
    final icons = [
      Icons.home_rounded,
      Icons.shield_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.person_outline,
    ];
    final labels = [
      context.l10n.home,
      context.l10n.violations,
      context.l10n.payments,
      context.l10n.profile,
    ];
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 390),
              child: IndexedStack(index: _tab, children: pages),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 390),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 6, 16, 16),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: aicaSurface(context),
                  border: Border.all(color: aicaBorder(context)),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    final selected = _tab == index;
                    return Expanded(
                      flex: selected ? 17 : 10,
                      child: InkWell(
                        onTap: () => setState(() => _tab = index),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: selected ? ink : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 23,
                                    color: selected
                                        ? Colors.white
                                        : aicaMuted(context),
                                  ),
                                  if (index == 1 &&
                                      !selected &&
                                      demoStore.payable.isNotEmpty)
                                    Positioned(
                                      top: -1,
                                      right: -6,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: aicaTone(
                                            context,
                                            Color(0xFFC32632),
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: aicaSurface(context),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (selected) ...[
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    labels[index],
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: aicaFontFamily,
                                      fontFamilyFallback: khmerFontFallback,
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
