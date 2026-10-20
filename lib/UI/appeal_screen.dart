import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../l10n/l10n_context.dart';
import '../l10n/demo_labels.dart';

import '../data/demo_store.dart';
import '../model/violation.dart';
import 'widgets/app_components.dart';

class AppealScreen extends StatefulWidget {
  const AppealScreen({super.key, required this.violation});
  final Violation violation;
  @override
  State<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends State<AppealScreen> {
  final _explanation = TextEditingController();
  String? _reason;
  bool _submitted = false;
  static const reasons = [
    'Not my vehicle',
    'Signal was green',
    'Emergency',
    'Wrong location',
  ];

  @override
  void dispose() {
    _explanation.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reason == null && _explanation.text.trim().isEmpty) {
      showDemoMessage(
        context,
        context.l10n.chooseAReasonOrDescribeWhatHappened,
      );
      return;
    }
    demoStore.submitAppeal(
      widget.violation.id,
      '${_reason ?? ''} ${_explanation.text.trim()}'.trim(),
    );
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: _submitted
        ? context.l10n.appealSubmitted
        : context.l10n.appealDispute,
    bottom: _submitted
        ? FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.done),
          )
        : FilledButton.icon(
            onPressed: _submit,
            icon: Icon(Icons.send_outlined),
            label: Text(context.l10n.submitAppeal),
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_submitted) ...[
          SizedBox(height: 36),
          Icon(
            Icons.check_circle,
            color: aicaTone(context, Color(0xFF188653)),
            size: 76,
          ),
          SizedBox(height: 18),
          Text(
            context.l10n.yourDemoAppealWasSavedLocally,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            context.l10n.noOfficialSubmissionWasMade,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaMuted(context),
            ),
          ),
        ] else ...[
          AppPanel(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: aicaTone(context, Color(0xFFFDEBEC)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.traffic,
                    color: aicaTone(context, Color(0xFFC32632)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        violationTitle(context, widget.violation),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: aicaFontFamily,
                          fontFamilyFallback: khmerFontFallback,
                          color: aicaInk(context),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${widget.violation.plate} · ${widget.violation.date}',
                        style: TextStyle(
                          fontFamily: aicaFontFamily,
                          fontFamilyFallback: khmerFontFallback,
                          color: aicaMuted(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            context.l10n.reasonOptional,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: reasons
                .map(
                  (reason) => ChoiceChip(
                    label: Text(appealReasonLabel(context, reason)),
                    selected: _reason == reason,
                    onSelected: (_) => setState(
                      () => _reason = _reason == reason ? null : reason,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20),
          Text(
            context.l10n.yourExplanation,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _explanation,
            maxLength: 500,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: context.l10n.describeWhatHappened,
              filled: true,
              fillColor: aicaSurface(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: aicaBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: aicaBorder(context)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            context.l10n.supportingEvidence,
            style: TextStyle(
              fontFamily: aicaFontFamily,
              fontFamilyFallback: khmerFontFallback,
              color: aicaInk(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => showDemoMessage(
                context,
                context.l10n.evidenceUploadNeedsABackend,
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: aicaBorder(context), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(Icons.attach_file),
              label: Text(context.l10n.attachPhotoOrDocument),
            ),
          ),
        ],
      ],
    ),
  );
}
