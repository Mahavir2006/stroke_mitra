/// CTA Section — Call to action with emergency button
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme.dart';

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.ctaGradient),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(children: [
          // Phone icon
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.phone, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text.rich(TextSpan(children: [
            TextSpan(text: "Don't Wait. ", style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5)),
            TextSpan(text: 'Act Now.', style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFFFDE68A), letterSpacing: -1.5)),
          ]), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'If you or someone near you shows stroke symptoms, every second matters. Start the Stroke Mitra check right now — it could save a life.',
            style: GoogleFonts.inter(fontSize: 17, color: Colors.white.withValues(alpha: 0.75), height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          // CTA buttons
          Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: [
            GestureDetector(
              onTap: () => context.go('/app'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 4))],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_outline, color: AppTheme.blue700, size: 20),
                  const SizedBox(width: 8),
                  Text('Start Stroke Check Now', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.blue700)),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('tel:112')),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.red500.withValues(alpha: 0.15),
                  border: Border.all(color: AppTheme.red500.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.phone, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Call 112 Emergency', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Text('Free to use · No registration · Works on any modern smartphone',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
        ]),
      )),
    );
  }
}
