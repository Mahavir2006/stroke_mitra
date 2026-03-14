/// Landing Footer — Brand, screening links, emergency numbers, disclaimer
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: AppTheme.slate950,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(children: [
          // Top section
          w > 700
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _Brand()),
                const SizedBox(width: 48),
                Expanded(flex: 2, child: _Links(context)),
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Brand(),
                const SizedBox(height: 32),
                _Links(context),
              ]),
          const SizedBox(height: 48),
          Divider(color: Colors.white.withValues(alpha: 0.06)),
          const SizedBox(height: 24),
          // Bottom
          Text('© 2025 Stroke Mitra. Built with care for public health awareness.',
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.slate500), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'This tool is for screening purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment.',
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.slate600, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      )),
    );
  }
}

class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.show_chart, color: Colors.white, size: 24),
        const SizedBox(width: 8),
        Text('Stroke Mitra', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
      ]),
      const SizedBox(height: 12),
      Text('Early detection. Better outcomes. Every second counts.',
        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate400, height: 1.6)),
    ]);
  }
}

class _Links extends StatelessWidget {
  final BuildContext ctx;
  const _Links(this.ctx);
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 32, runSpacing: 24, children: [
      _Col('Screening', [
        _Link('Face Analysis', () => ctx.go('/face')),
        _Link('Speech Check', () => ctx.go('/voice')),
        _Link('Motion Test', () => ctx.go('/motion')),
      ]),
      _Col('Learn', [
        _Link('What is Stroke Mitra', null),
        _Link('How It Works', null),
        _Link('Why Early Detection', null),
      ]),
      _Col('Emergency', [
        _Link('🚨 Call 112', () => launchUrl(Uri.parse('tel:112')), isEmergency: true),
        _Link('🚑 Ambulance 108', () => launchUrl(Uri.parse('tel:108')), isEmergency: true),
      ]),
    ]);
  }
}

class _Col extends StatelessWidget {
  final String title; final List<Widget> children;
  const _Col(this.title, this.children);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppTheme.slate400)),
      const SizedBox(height: 16),
      ...children,
    ]);
  }
}

class _Link extends StatelessWidget {
  final String text; final VoidCallback? onTap; final bool isEmergency;
  const _Link(this.text, this.onTap, {this.isEmergency = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: GoogleFonts.inter(
          fontSize: 14,
          color: isEmergency ? AppTheme.orange400 : AppTheme.slate500,
          fontWeight: isEmergency ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}
