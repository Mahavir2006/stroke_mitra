/// Features Section — 6 feature cards with tags and hover effects
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final features = [
      _Feat(Icons.camera_alt_outlined, 'Camera-Based Facial Analysis', 'Real-time AI detection of facial asymmetry using your front camera. No special hardware needed.', 'Computer Vision'),
      _Feat(Icons.mic_none_outlined, 'Voice Recording & Speech Detection', 'Advanced NLP models analyze your speech for slurring, word-finding difficulty, and incoherence.', 'NLP + Audio AI'),
      _Feat(Icons.show_chart, 'Motion & Coordination Sensing', 'Gyroscope and accelerometer data assess arm drift and coordination — key neurological indicators.', 'Sensor Fusion'),
      _Feat(Icons.access_time, 'Results in Under 60 Seconds', 'The entire screening process takes less than a minute, giving you fast answers when every second counts.', 'Real-Time'),
      _Feat(Icons.lock_outline, 'Fully Private & Secure', 'All processing happens on your device. No video, audio, or personal data is ever uploaded or stored.', 'On-Device AI'),
      _Feat(Icons.shield_outlined, 'Clinically Guided Framework', 'Based on the medically validated FAST protocol, trusted by emergency responders globally.', 'Evidence-Based'),
    ];

    return Container(
      color: AppTheme.slate50,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.blue50, border: Border.all(color: AppTheme.blue100), borderRadius: BorderRadius.circular(100)),
            child: Text('FEATURES', style: AppTheme.labelTag),
          ),
          const SizedBox(height: 16),
          Text('Built for Speed. Designed for Trust.', style: AppTheme.headingLG, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text('Every feature is purpose-built to deliver accurate, fast, and private stroke screening.',
              style: AppTheme.bodyLG, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
            children: features.map((f) => SizedBox(
              width: w > 900 ? (w - 48 - 40) / 3 : w > 600 ? (w - 48 - 20) / 2 : w - 48,
              child: _FeatureCard(feat: f),
            )).toList(),
          ),
        ]),
      )),
    );
  }
}

class _Feat {
  final IconData icon; final String title, desc, tag;
  const _Feat(this.icon, this.title, this.desc, this.tag);
}

class _FeatureCard extends StatefulWidget {
  final _Feat feat;
  const _FeatureCard({required this.feat});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..translate(0.0, _hovered ? -5.0 : 0.0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _hovered ? AppTheme.blue100 : AppTheme.slate200),
          boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: _hovered ? 0.1 : 0.04),
            blurRadius: _hovered ? 40 : 16, offset: Offset(0, _hovered ? 12 : 2),
          )],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppTheme.blue50, borderRadius: BorderRadius.circular(12)),
            child: Icon(widget.feat.icon, color: AppTheme.blue600, size: 26),
          ),
          const SizedBox(height: 12),
          Text(widget.feat.tag, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppTheme.blue500)),
          const SizedBox(height: 8),
          Text(widget.feat.title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.slate900)),
          const SizedBox(height: 8),
          Text(widget.feat.desc, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate500, height: 1.65)),
          const SizedBox(height: 12),
          // Hover line
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 3, width: _hovered ? double.infinity : 0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.blue400, AppTheme.teal400]),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ]),
      ),
    );
  }
}
