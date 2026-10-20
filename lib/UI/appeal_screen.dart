import 'package:flutter/material.dart';

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
      showDemoMessage(context, 'Choose a reason or describe what happened.');
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
    title: _submitted ? 'Appeal submitted' : 'Appeal / Dispute',
    bottom: _submitted
        ? FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          )
        : FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.send_outlined),
            label: const Text('Submit appeal'),
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_submitted) ...[
          const SizedBox(height: 36),
          const Icon(Icons.check_circle, color: Color(0xFF188653), size: 76),
          const SizedBox(height: 18),
          const Text(
            'Your demo appeal was saved locally.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No official submission was made.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted),
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
                    color: const Color(0xFFFDEBEC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.traffic, color: Color(0xFFC32632)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.violation.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${widget.violation.plate} · ${widget.violation.date}',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reason (optional)',
            style: TextStyle(
              color: ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: reasons
                .map(
                  (reason) => ChoiceChip(
                    label: Text(reason),
                    selected: _reason == reason,
                    onSelected: (_) => setState(
                      () => _reason = _reason == reason ? null : reason,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your explanation',
            style: TextStyle(
              color: ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _explanation,
            maxLength: 500,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe what happened...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Supporting evidence',
            style: TextStyle(
              color: ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () =>
                  showDemoMessage(context, 'Evidence upload needs a backend.'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC9D5E2), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach photo or document'),
            ),
          ),
        ],
      ],
    ),
  );
}
