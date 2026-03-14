/// What Is Section — 3 info cards + disclaimer banner
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class WhatIsSection extends StatelessWidget {
  const WhatIsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cards = [
      _CardData('Clinically Informed', 'Built on the FAST (Face, Arms, Speech, Time) framework used by medical professionals worldwide.', Icons.shield_outlined, AppTheme.blue600, AppTheme.blue50),
      _CardData('Device-Native AI', 'Runs entirely on your device. No cloud uploads, no data retention. Your health data stays yours.', Icons.desktop_mac_outlined, AppTheme.teal600, AppTheme.teal400.withValues(alpha: 0.1)),
      _CardData('For Everyone', 'Designed for patients, caregivers, and healthcare workers. No medical training required.', Icons.people_outline, AppTheme.orange600, AppTheme.orange400.withValues(alpha: 0.1)),
    ];

    return Container(
      color: AppTheme.slate50,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          _SectionTag('About'),
          const SizedBox(height: 16),
          Text('What is Stroke Mitra?', style: AppTheme.headingLG, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Stroke Mitra is an AI-powered screening tool that helps identify early warning signs of stroke using your smartphone\'s built-in sensors — no special equipment needed.',
              style: AppTheme.bodyLG, textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
            children: cards.map((c) => SizedBox(
              width: w > 900 ? (w - 48 - 48) / 3 : w > 600 ? (w - 48 - 24) / 2 : w - 48,
              child: _InfoCard(data: c),
            )).toList(),
          ),
          const SizedBox(height: 40),
          // Disclaimer banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.blue500.withValues(alpha: 0.06),
              border: Border.all(color: AppTheme.blue500.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline, color: AppTheme.blue700, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Medical Disclaimer: ', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.blue700, fontSize: 14)),
                TextSpan(text: 'Stroke Mitra is a screening aid, not a diagnostic tool. Always call emergency services (112) immediately if you suspect a stroke.',
                  style: GoogleFonts.inter(color: AppTheme.blue700, fontSize: 14, height: 1.6)),
              ]))),
            ]),
          ),
        ]),
      )),
    );
  }
}

class _SectionTag extends StatelessWidget {
  final String text;
  const _SectionTag(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.blue50, border: Border.all(color: AppTheme.blue100),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(text.toUpperCase(), style: AppTheme.labelTag),
    );
  }
}

class _CardData {
  final String title, desc;
  final IconData icon;
  final Color color, bgColor;
  const _CardData(this.title, this.desc, this.icon, this.color, this.bgColor);
}

class _InfoCard extends StatelessWidget {
  final _CardData data;
  const _InfoCard({required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.slate200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: data.bgColor, borderRadius: BorderRadius.circular(14)),
          child: Icon(data.icon, color: data.color, size: 28),
        ),
        const SizedBox(height: 20),
        Text(data.title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.slate900)),
        const SizedBox(height: 10),
        Text(data.desc, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate500, height: 1.65)),
      ]),
    );
  }
}
