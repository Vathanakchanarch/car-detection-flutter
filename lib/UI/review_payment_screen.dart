import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../data/demo_store.dart';
import '../model/violation.dart';
import 'widgets/app_components.dart';

class ReviewPaymentScreen extends StatefulWidget {
  const ReviewPaymentScreen({super.key, required this.fines});
  final List<Violation> fines;
  @override
  State<ReviewPaymentScreen> createState() => _ReviewPaymentScreenState();
}

class _ReviewPaymentScreenState extends State<ReviewPaymentScreen> {
  bool _demoSelected = false;

  int get total => widget.fines.fold(0, (sum, fine) => sum + fine.amount);

  Future<void> _confirm() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm demo payment'),
        content: Text(
          'Mark ${widget.fines.length} fine(s) worth ${riel(total)} as paid in this local prototype? No money will be transferred.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm demo'),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    demoStore.payFines(widget.fines.map((fine) => fine.id));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DetailPage(
          title: 'Demo payment complete',
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF188653),
                size: 80,
              ),
              const SizedBox(height: 18),
              Text(
                '${riel(total)} marked paid',
                style: const TextStyle(
                  color: ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This is a local simulation. No official payment was made.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Review & pay',
    bottom: FilledButton.icon(
      onPressed: _demoSelected ? _confirm : null,
      icon: const Icon(Icons.lock_outline),
      label: Text('Pay ${riel(total)}'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4D9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.science, color: Color(0xFF9D6B00), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Payments are not connected to an authorised government service yet. This screen simulates the flow.',
                  style: TextStyle(color: Color(0xFF9D6B00), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Fines'),
        AppPanel(
          child: Column(
            children: [
              for (final fine in widget.fines)
                InfoRow(fine.title, riel(fine.amount)),
              const Divider(height: 1),
              InfoRow('Total', riel(total)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Payment method'),
        const Opacity(
          opacity: .55,
          child: _PaymentOption(
            icon: Icons.account_balance,
            title: 'Bank app',
            subtitle: 'Not connected yet',
            selected: true,
          ),
        ),
        const SizedBox(height: 8),
        const Opacity(
          opacity: .55,
          child: _PaymentOption(
            icon: Icons.phone_android,
            title: 'Mobile wallet',
            subtitle: 'Not connected yet',
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _demoSelected = true),
          borderRadius: BorderRadius.circular(16),
          child: _PaymentOption(
            icon: Icons.science_outlined,
            title: 'Demo simulation',
            subtitle: 'Prototype only',
            selected: _demoSelected,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '🔒 We never ask for or store card details in this app.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFFEAF1FF) : Colors.white,
      border: Border.all(
        color: selected ? blue : const Color(0xFFC9D5E2),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ink),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ink,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: selected ? blue : const Color(0xFFC9D5E2),
        ),
      ],
    ),
  );
}
