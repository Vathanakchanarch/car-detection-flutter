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
    showDemoMessage(context, 'Demo appeal saved locally.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Appeal / Dispute',
    bottom: FilledButton.icon(
      onPressed: _submit,
      icon: const Icon(Icons.send_outlined),
      label: const Text('Submit appeal'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.violation.title,
                style: const TextStyle(color: ink, fontWeight: FontWeight.w700),
              ),
              Text(
                '${widget.violation.plate} · ${widget.violation.date}',
                style: const TextStyle(color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Reason (optional)',
          style: TextStyle(color: ink, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 2,
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
        const SizedBox(height: 24),
        const Text(
          'Your explanation',
          style: TextStyle(color: ink, fontWeight: FontWeight.w700),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Supporting evidence',
          style: TextStyle(color: ink, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () =>
              showDemoMessage(context, 'Evidence upload needs a backend.'),
          icon: const Icon(Icons.attach_file),
          label: const Text('Attach photo or document'),
        ),
      ],
    ),
  );
}
