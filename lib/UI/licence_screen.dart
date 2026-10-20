import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';

import '../data/demo_store.dart';
import 'widgets/app_components.dart';

class LicenceScreen extends StatefulWidget {
  const LicenceScreen({super.key});
  @override
  State<LicenceScreen> createState() => _LicenceScreenState();
}

class _LicenceScreenState extends State<LicenceScreen> {
  bool _previewPoints = false;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: context.l10n.drivingLicence,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF20507F), Color(0xFF10253C)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.drivingLicenceLabel,
                    style: TextStyle(
                      fontFamily: aicaFontFamily,
                      fontFamilyFallback: khmerFontFallback,
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                    ),
                  ),
                  Icon(Icons.contactless, color: Colors.white70),
                ],
              ),
              Text(
                context.l10n.demoCardNotAnOfficialDocument,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Color(0xFFB8C9D9),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person, color: Colors.white70, size: 44),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demoStore.name,
                          style: TextStyle(
                            fontFamily: aicaFontFamily,
                            fontFamilyFallback: khmerFontFallback,
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '0412 ···· 7731',
                          style: TextStyle(
                            fontFamily: aicaFontFamily,
                            fontFamilyFallback: khmerFontFallback,
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          context.l10n.dob19,
                          style: TextStyle(
                            fontFamily: aicaFontFamily,
                            fontFamilyFallback: khmerFontFallback,
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _LicenceField(context.l10n.category, 'A1 · B'),
                  ),
                  Expanded(
                    child: _LicenceField(context.l10n.issued, '12 Mar 2024'),
                  ),
                  Expanded(
                    child: _LicenceField(context.l10n.expires, '12 Mar 2029'),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        SectionTitle(context.l10n.officialPoints),
        AppPanel(
          child: _previewPoints
              ? Column(
                  children: [
                    Icon(Icons.donut_large, color: aicaBlue(context), size: 66),
                    Text(
                      '9 / 12',
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaInk(context),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      context.l10n.demoDataSampleBalanceForDesignPreview,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaMuted(context),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _previewPoints = false),
                      child: Text(context.l10n.backToUnavailableState),
                    ),
                  ],
                )
              : Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: aicaTone(context, Color(0xFFFFF4D9)),
                      child: Icon(
                        Icons.link_off,
                        color: aicaTone(context, Color(0xFF9D6B00)),
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      context.l10n.pointsUnavailable,
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaInk(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      context.l10n.yourLicenceIsNotConnectedToAn,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaMuted(context),
                        fontSize: 13.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => showDemoMessage(
                          context,
                          context.l10n.officialPointsServiceIsNotConnected,
                        ),
                        icon: Icon(Icons.refresh),
                        label: Text(context.l10n.checkConnection),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _previewPoints = true),
                      child: Text(context.l10n.previewVerifiedStateDemoData),
                    ),
                  ],
                ),
        ),
        if (_previewPoints) ...[
          SizedBox(height: 24),
          SectionTitle(context.l10n.pointDeductionHistory),
          AppPanel(
            child: Column(
              children: [
                InfoRow(context.l10n.redLightViolation09Sep2026, '−2'),
                Divider(height: 1),
                InfoRow(context.l10n.speeding11Jan2026, '−1'),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

class _LicenceField extends StatelessWidget {
  const _LicenceField(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: aicaFontFamily,
          fontFamilyFallback: khmerFontFallback,
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
      SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontFamily: aicaFontFamily,
          fontFamilyFallback: khmerFontFallback,
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
