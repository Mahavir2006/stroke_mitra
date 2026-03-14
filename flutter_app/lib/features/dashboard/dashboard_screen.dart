/// Stroke Mitra - Dashboard Screen
///
/// Mirrors the React `AppHome` component. Displays a hero banner
/// and three action cards linking to Face, Voice, and Motion tests.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../shared/widgets/disclaimer_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppTheme.spaceMD),
          // ─── Hero Banner ───
          Center(
            child: Column(
              children: [
                Text(
                  'Early Detection Saves Lives',
                  style: AppTheme.headingMD.copyWith(color: AppTheme.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  'Perform a quick self-check if you suspect symptoms.',
                  style: AppTheme.bodyMD,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceXL),

          // ─── Action Cards ───
          _ActionCard(
            icon: Icons.camera_alt_rounded,
            title: 'Face Analysis',
            subtitle: 'Check for facial drooping',
            onTap: () => context.go('/face'),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          _ActionCard(
            icon: Icons.mic_rounded,
            title: 'Speech Check',
            subtitle: 'Analyze speech clarity',
            onTap: () => context.go('/voice'),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          _ActionCard(
            icon: Icons.show_chart_rounded,
            title: 'Motion Test',
            subtitle: 'Assess arm stability',
            onTap: () => context.go('/motion'),
          ),

          // ─── Disclaimer ───
          const DisclaimerWidget(),
          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

/// Individual action card — matches the React .action-card component
class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 0.0 : 0.0),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(
            color: _isPressed
                ? AppTheme.primaryLight
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: _isPressed ? 15 : 6,
              offset: Offset(0, _isPressed ? 8 : 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.bgApp,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 28,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMD),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.slate800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.slate500,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: _isPressed ? AppTheme.primary : AppTheme.slate400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
