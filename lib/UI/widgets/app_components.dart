import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../../model/violation.dart';

const ink = Color(0xFF102A43);
const blue = Color(0xFF2563EB);
const muted = Color(0xFF526579);

void openPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFC9D5E2)),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A102A43),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: Color(0x2E102A43),
          blurRadius: 24,
          offset: Offset(0, 8),
          spreadRadius: -14,
        ),
      ],
    ),
    child: Material(type: MaterialType.transparency, child: child),
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.actions,
  });
  final String title;
  final Widget child;
  final Widget? bottom;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 60,
      leadingWidth: 56,
      titleSpacing: 8,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: ink),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: child,
              ),
            ),
            if (bottom != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFC9D5E2))),
                ),
                child: bottom!,
              ),
          ],
        ),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        color: ink,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class AppMenuRow extends StatelessWidget {
  const AppMenuRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.subtitle,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: danger ? const Color(0xFFFDEBEC) : const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: danger ? const Color(0xFFC32632) : blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(color: muted, fontSize: 12.5),
                  ),
              ],
            ),
          ),
          trailing ??
              (onTap == null
                  ? const SizedBox.shrink()
                  : const Icon(Icons.chevron_right, color: muted)),
        ],
      ),
    ),
  );
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: muted, fontSize: 14),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final ViolationStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color, bg) = switch (status) {
      ViolationStatus.suspected => (
        'AI suspected',
        Icons.auto_awesome,
        blue,
        const Color(0xFFEAF1FF),
      ),
      ViolationStatus.confirmed => (
        'Confirmed fine',
        Icons.verified,
        const Color(0xFFC32632),
        const Color(0xFFFDEBEC),
      ),
      ViolationStatus.underReview => (
        'Under review',
        Icons.hourglass_top,
        const Color(0xFF9D6B00),
        const Color(0xFFFFF4D9),
      ),
      ViolationStatus.disputed => (
        'Disputed',
        Icons.forum,
        const Color(0xFF7542B5),
        const Color(0xFFF2EAFE),
      ),
      ViolationStatus.resolved => (
        'Resolved',
        Icons.check_circle,
        const Color(0xFF188653),
        const Color(0xFFE5F6EB),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ViolationTile extends StatelessWidget {
  const ViolationTile({
    super.key,
    required this.violation,
    required this.onTap,
  });
  final Violation violation;
  final VoidCallback onTap;

  (IconData, Color, Color) get _visual => switch (violation.id) {
    'red-light' => (Icons.traffic, blue, const Color(0xFFEAF1FF)),
    'speeding' => (
      Icons.speed,
      const Color(0xFFC32632),
      const Color(0xFFFDEBEC),
    ),
    'helmet' => (
      Icons.sports_motorsports,
      const Color(0xFFC32632),
      const Color(0xFFFDEBEC),
    ),
    'parking' => (
      Icons.local_parking,
      const Color(0xFF9D6B00),
      const Color(0xFFFFF4D9),
    ),
    'wrong-way' => (
      Icons.u_turn_left,
      const Color(0xFF7542B5),
      const Color(0xFFF2EAFE),
    ),
    _ => (Icons.remove_road, const Color(0xFF188653), const Color(0xFFE5F6EB)),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, iconBackground) = _visual;
    return LayoutBuilder(
      builder: (context, constraints) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 350 ? 12 : 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      violation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${violation.date} · ${violation.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    violation.amount > 0 ? riel(violation.amount) : 'No fine',
                    style: TextStyle(
                      color: violation.amount > 0 ? ink : muted,
                      fontSize: violation.amount > 0 ? 14 : 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(violation.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showDemoMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
