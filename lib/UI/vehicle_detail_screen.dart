import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';
import '../l10n/demo_labels.dart';

import '../data/demo_data.dart';
import '../model/vehicle.dart';
import '../model/violation.dart';
import 'violation_detail_screen.dart';
import 'widgets/app_components.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key, required this.vehicle});
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: context.l10n.vehicleDetails,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ink,
            border: Border.all(color: aicaBorder(context)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                vehicle.type == 'Car'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: Colors.white,
                size: 44,
              ),
              SizedBox(height: 10),
              Text(
                vehicle.name,
                style: TextStyle(
                  fontFamily: aicaFontFamily,
                  fontFamilyFallback: khmerFontFallback,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: aicaSurface(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'CAMBODIA · ព្រះរាជាណាចក្រកម្ពុជា',
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaBlue(context),
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      vehicle.plate,
                      style: TextStyle(
                        fontFamily: aicaFontFamily,
                        fontFamilyFallback: khmerFontFallback,
                        color: aicaInk(context),
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 26),
        SectionTitle(context.l10n.details),
        AppPanel(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              InfoRow(context.l10n.type, vehicle.type),
              Divider(height: 1),
              InfoRow(context.l10n.colour, vehicle.colour),
              Divider(height: 1),
              InfoRow(context.l10n.year, '${vehicle.year}'),
              Divider(height: 1),
              InfoRow(context.l10n.registrationExpires, vehicle.expiry),
            ],
          ),
        ),
        SizedBox(height: 26),
        SectionTitle(context.l10n.verification),
        AppPanel(
          child: Column(
            children: [
              _VerificationStep(context.l10n.submitted),
              _VerificationStep(context.l10n.matchedToRegistry),
              _VerificationStep(context.l10n.verified, last: true),
            ],
          ),
        ),
        SizedBox(height: 26),
        SectionTitle(context.l10n.linkedViolations),
        AppPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (index, violation)
                  in demoViolations
                      .where((v) => v.plate == vehicle.plate)
                      .indexed) ...[
                if (index > 0) Divider(height: 1),
                _LinkedViolationRow(violation: violation),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _LinkedViolationRow extends StatelessWidget {
  const _LinkedViolationRow({required this.violation});
  final Violation violation;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => openPage(context, ViolationDetailScreen(violation: violation)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: aicaTone(context, Color(0xFFEAF1FF)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              switch (violation.id) {
                'red-light' => Icons.traffic,
                'speeding' => Icons.speed,
                'parking' => Icons.local_parking,
                _ => Icons.traffic,
              },
              color: aicaBlue(context),
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  violationTitle(context, violation),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaInk(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  violation.date,
                  style: TextStyle(
                    fontFamily: aicaFontFamily,
                    fontFamilyFallback: khmerFontFallback,
                    color: aicaMuted(context),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6),
          StatusBadge(violation.status),
        ],
      ),
    ),
  );
}

class _VerificationStep extends StatelessWidget {
  const _VerificationStep(this.label, {this.last = false});

  final String label;
  final bool last;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: aicaTone(context, Color(0xFF188653)),
            child: Icon(Icons.check, color: aicaSurface(context), size: 16),
          ),
          if (!last)
            Container(
              width: 2,
              height: 24,
              color: aicaTone(context, Color(0xFF188653)),
            ),
        ],
      ),
      SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}
