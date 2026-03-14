/// Hero Section — Animated gradient background with title, CTAs, trust badges
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, w > 600 ? 140 : 120, 24, 80),
      decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
      child: Column(
        crossAxisAlignment: w > 800 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.green400, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppTheme.green400.withValues(alpha: 0.3), blurRadius: 6)],
                ),
              ),
              const SizedBox(width: 8),
              Text('AI-Powered Stroke Screening',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9)),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // Title
          Text('Detect Stroke Early.',
            style: GoogleFonts.outfit(fontSize: w > 600 ? 48 : 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.08, letterSpacing: -1.5),
            textAlign: w > 800 ? TextAlign.left : TextAlign.center,
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF7DD3FC), Color(0xFF2DD4BF)]).createShader(bounds),
            child: Text('Save Lives.',
              style: GoogleFonts.outfit(fontSize: w > 600 ? 48 : 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.08, letterSpacing: -1.5),
              textAlign: w > 800 ? TextAlign.left : TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              'Stroke Mitra uses your device\'s camera, microphone, and motion sensors to screen for early stroke symptoms — in under 60 seconds.',
              style: GoogleFonts.inter(fontSize: 17, color: Colors.white.withValues(alpha: 0.78), height: 1.7),
              textAlign: w > 800 ? TextAlign.left : TextAlign.center,
            ),
          ),
          const SizedBox(height: 36),

          // CTAs
          Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: [
            _HeroBtn(label: 'Check Symptoms', icon: Icons.check_circle_outline,
              gradient: AppTheme.primaryGradient, textColor: Colors.white,
              onTap: () => context.go('/app')),
            _GhostBtn(label: 'Learn How It Works', icon: Icons.info_outline),
          ]),
          const SizedBox(height: 40),

          // Trust badges
          Wrap(spacing: 16, runSpacing: 8, alignment: WrapAlignment.center, children: [
            _TrustBadge(icon: Icons.shield_outlined, text: '100% Private'),
            _TrustDivider(),
            _TrustBadge(icon: Icons.access_time, text: 'Under 60 Seconds'),
            _TrustDivider(),
            _TrustBadge(icon: Icons.phone_outlined, text: 'No Data Stored'),
          ]),
        ],
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  final String label; final IconData icon; final Gradient gradient;
  final Color textColor; final VoidCallback onTap;
  const _HeroBtn({required this.label, required this.icon, required this.gradient, required this.textColor, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.blue500.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 4))]),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: textColor, size: 20), const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
      ]),
    ));
  }
}

class _GhostBtn extends StatelessWidget {
  final String label; final IconData icon;
  const _GhostBtn({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ]),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon; final String text;
  const _TrustBadge({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.7)),
      const SizedBox(width: 6),
      Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7))),
    ]);
  }
}

class _TrustDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 16, color: Colors.white.withValues(alpha: 0.2));
  }
}
