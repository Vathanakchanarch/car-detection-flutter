import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import 'licence_screen.dart';
import 'notifications_screen.dart';
import 'vehicles_screen.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: demoStore,
    builder: (context, _) => ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: ink,
              child: Text(
                'SV',
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.goodMorning,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: aicaMuted(context),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    demoStore.name,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: aicaInk(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: aicaSurface(context),
                border: Border.all(color: aicaBorder(context)),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: context.l10n.notifications,
                onPressed: () => openPage(context, NotificationsScreen()),
                icon: Badge(
                  backgroundColor: aicaTone(context, Color(0xFFC32632)),
                  label: Text('3'),
                  child: Icon(Icons.notifications),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF102A43), Color(0xFF173A70)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.youHaveFinesToPay,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 5),
              Text(
                riel(demoStore.payable.fold(0, (sum, v) => sum + v.amount)),
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                context.l10n.label2ConfirmedPayBy31Oct2026,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.lock_outline, size: 18),
                style: FilledButton.styleFrom(
                  backgroundColor: aicaSurface(context),
                  foregroundColor: aicaInk(context),
                ),
                onPressed: () => onSelectTab(2),
                label: Text(context.l10n.payNow),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            _Shortcut(
              Icons.payments_outlined,
              context.l10n.payFines,
              () => onSelectTab(2),
            ),
            _Shortcut(Icons.gavel, context.l10n.appeal, () => onSelectTab(1)),
            _Shortcut(
              Icons.directions_car_outlined,
              context.l10n.vehicles,
              () => openPage(context, VehiclesScreen()),
            ),
            _Shortcut(
              Icons.badge_outlined,
              context.l10n.licence,
              () => openPage(context, LicenceScreen()),
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: SectionTitle(context.l10n.recentAlerts)),
            TextButton(
              onPressed: () => onSelectTab(1),
              child: Text(context.l10n.seeAll),
            ),
          ],
        ),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < 3; i++) ...[
                ViolationTile(
                  violation: demoViolations[i],
                  onTap: () => openPage(
                    context,
                    ViolationDetailScreen(violation: demoViolations[i]),
                  ),
                ),
                if (i < 2) Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _Shortcut extends StatelessWidget {
  const _Shortcut(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: aicaSurface(context),
              border: Border.all(color: aicaBorder(context)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: aicaBlue(context)),
          ),
          SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
