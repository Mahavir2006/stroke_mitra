/// Landing Nav — Fixed navbar with scroll-aware background
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class LandingNav extends StatelessWidget {
  const LandingNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(Icons.show_chart, color: AppTheme.blue700, size: 20),
            const SizedBox(width: 8),
            Text(
              'Stroke Mitra',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.blue700,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            _NavButton(
              label: 'Check Symptoms',
              onTap: () => context.go('/app'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppTheme.blue500.withValues(alpha: 0.3),
              blurRadius: 12, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(label,
          style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          ),
        ),
      ),
    );
  }
}
