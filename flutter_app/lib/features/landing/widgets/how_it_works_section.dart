/// How It Works Section — 4 step cards with icons
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final steps = [
      _Step('01', 'Face Detection', 'Your camera analyzes facial symmetry in real-time, checking for drooping or asymmetry — a key stroke indicator.', 'AI scans 68 facial landmarks', Icons.camera_alt_outlined, AppTheme.blue600, AppTheme.blue50),
      _Step('02', 'Voice Analysis', 'Speak a simple phrase. Our model detects slurring, hesitation, and speech irregularities associated with stroke.', 'NLP + audio pattern analysis', Icons.mic_none_outlined, AppTheme.teal600, AppTheme.teal400.withValues(alpha: 0.1)),
      _Step('03', 'Motion & Coordination', 'Using your device\'s gyroscope and accelerometer, we assess arm stability and coordination.', 'Gyroscope + accelerometer data', Icons.show_chart, AppTheme.orange600, AppTheme.orange400.withValues(alpha: 0.1)),
      _Step('04', 'Instant Results', 'Receive a risk assessment in seconds with clear guidance on next steps — including when to call emergency services.', 'Results in under 60 seconds', Icons.description_outlined, AppTheme.green600, AppTheme.green400.withValues(alpha: 0.1)),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          _Tag('Process'),
          const SizedBox(height: 16),
          Text('How Stroke Mitra Works', style: AppTheme.headingLG, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text('Four simple steps. No medical expertise required. Guided by AI every step of the way.',
              style: AppTheme.bodyLG, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          Wrap(spacing: 16, runSpacing: 32, alignment: WrapAlignment.center,
            children: steps.map((s) => SizedBox(
              width: w > 900 ? (w - 48 - 48) / 4 : w > 600 ? (w - 48 - 16) / 2 : w - 48,
              child: _StepCard(step: s),
            )).toList(),
          ),
        ]),
      )),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.blue50, border: Border.all(color: AppTheme.blue100), borderRadius: BorderRadius.circular(100)),
      child: Text(text.toUpperCase(), style: AppTheme.labelTag),
    );
  }
}

class _Step {
  final String num, title, desc, detail;
  final IconData icon;
  final Color color, bg;
  const _Step(this.num, this.title, this.desc, this.detail, this.icon, this.color, this.bg);
}

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard({required this.step});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(shape: BoxShape.circle, color: step.bg,
            boxShadow: [BoxShadow(color: step.color.withValues(alpha: 0.08), blurRadius: 16, spreadRadius: 8)]),
          child: Icon(step.icon, size: 32, color: step.color),
        ),
        Positioned(top: -4, right: -4, child: Container(
          width: 22, height: 22,
          decoration: BoxDecoration(color: AppTheme.slate900, shape: BoxShape.circle),
          child: Center(child: Text(step.num, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
        )),
      ]),
      const SizedBox(height: 20),
      Text(step.title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.slate900), textAlign: TextAlign.center),
      const SizedBox(height: 10),
      Text(step.desc, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate500, height: 1.65), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: step.bg, borderRadius: BorderRadius.circular(100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.chevron_right, size: 12, color: step.color),
          const SizedBox(width: 4),
          Text(step.detail, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: step.color)),
        ]),
      ),
    ]);
  }
}
