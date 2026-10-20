import 'package:flutter/material.dart';

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
      const ViolationsScreen(),
      const PaymentsScreen(),
      const ProfileScreen(),
    ];
    const icons = [
      Icons.home_rounded,
      Icons.shield_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.person_outline,
    ];
    const labels = ['Home', 'Violations', 'Payments', 'Profile'];
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: IndexedStack(index: _tab, children: pages),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFC9D5E2)),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    final selected = _tab == index;
                    return Expanded(
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
                              Icon(
                                icons[index],
                                size: 21,
                                color: selected ? Colors.white : muted,
                              ),
                              if (selected) ...[
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    labels[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
