import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'tap_test_provider.dart';
import 'tap_test_service.dart';

class TapTestScreen extends ConsumerWidget {
  const TapTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tapTestProvider);
    final notifier = ref.read(tapTestProvider.notifier);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header ───
          Row(children: [
            const Icon(Icons.touch_app_rounded, color: AppTheme.primary, size: 24),
            const SizedBox(width: 8),
            Text('Tap Test', style: AppTheme.headingMD),
          ]),
          const SizedBox(height: AppTheme.spaceSM),

          // ─── Instruction Card ───
          if (!state.isRunning && state.result == null) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: AppTheme.blue50,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.blue100),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.info_outline, color: AppTheme.blue600, size: 20),
                const SizedBox(width: AppTheme.spaceSM),
                Expanded(
                  child: Text(
                    'Tap the moving circle as many times as you can. Keep tapping for ${TapTestService.testDurationSeconds} seconds.',
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.blue700, height: 1.5),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: AppTheme.spaceLG),
          ],

          // ─── Test Arena ───
          _TapArena(
            state: state,
            arenaHeight: size.height * 0.5,
            onTapDown: (details) => notifier.registerTap(details.localPosition),
            onStart: () => notifier.startTest(size.width, size.height * 0.5),
            onStop: notifier.stopTest,
          ),

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Results Card ───
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: AppTheme.spaceMD),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await SessionService.submitData(
                        'temp-session',
                        AppConstants.dataTypeTap,
                        state.result!.toJson(),
                      );
                      notifier.reset();
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save & Continue'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spaceSM),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: notifier.reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

// ─── Tap Arena ────────────────────────────────────────────────────────────────
class _TapArena extends StatelessWidget {
  final TapTestState state;
  final double arenaHeight;
  final void Function(TapDownDetails) onTapDown;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const _TapArena({
    required this.state,
    required this.arenaHeight,
    required this.onTapDown,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: state.isRunning ? onTapDown : null,
          child: Container(
            width: double.infinity,
            height: arenaHeight,
            decoration: BoxDecoration(
              color: state.isRunning
                  ? AppTheme.slate900.withValues(alpha: 0.92)
                  : AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(
                color: state.isRunning ? AppTheme.primary : AppTheme.slate200,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // ─── Idle placeholder ───
                if (!state.isRunning && state.result == null)
                  const Center(
                    child: Icon(Icons.touch_app_rounded,
                        size: 64, color: AppTheme.slate300),
                  ),

                // ─── Hit counter ───
                if (state.isRunning)
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Taps: ${state.hitCount}',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // ─── Countdown ───
                if (state.isRunning)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Text(
                      '${TapTestService.testDurationSeconds - state.elapsedSeconds}s',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate300,
                      ),
                    ),
                  ),

                // ─── Moving button ───
                if (state.isRunning)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 16),
                    curve: Curves.linear,
                    left: state.buttonX,
                    top: state.buttonY,
                    child: _TapButton(flash: state.lastHitFlash),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spaceMD),

        // ─── Start / Stop button ───
        if (state.result == null)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: state.isRunning
                ? OutlinedButton.icon(
                    onPressed: onStop,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Stop Early'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.statusError,
                      side: const BorderSide(color: AppTheme.statusError, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Test'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

// ─── Tap Button ───────────────────────────────────────────────────────────────
class _TapButton extends StatelessWidget {
  final bool flash;
  const _TapButton({required this.flash});

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.touch_app_rounded, color: Colors.white, size: 32),
    );

    if (flash) {
      return button
          .animate()
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.25, 1.25),
            duration: 150.ms,
          )
          .then()
          .scale(
            begin: const Offset(1.25, 1.25),
            end: const Offset(1.0, 1.0),
            duration: 150.ms,
          );
    }
    return button;
  }
}

// ─── Result Card ──────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final TapResult result;
  const _ResultCard({required this.result});

  Color get _riskColor {
    switch (result.riskLevel) {
      case 'Abnormal': return AppTheme.statusError;
      case 'Borderline': return AppTheme.statusWarning;
      default: return AppTheme.statusSuccess;
    }
  }

  IconData get _riskIcon {
    switch (result.riskLevel) {
      case 'Abnormal': return Icons.warning_rounded;
      case 'Borderline': return Icons.info_rounded;
      default: return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: _riskColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(_riskIcon, color: _riskColor, size: 24),
          const SizedBox(width: 8),
          Text(
            result.riskLevel,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _riskColor,
            ),
          ),
        ]),
        const SizedBox(height: AppTheme.spaceMD),
        Divider(color: AppTheme.slate200),
        const SizedBox(height: AppTheme.spaceSM),
        _Row(
          label: 'Successful Taps',
          value: '${result.hitCount} / ${TapTestService.successThreshold} required',
        ),
        const SizedBox(height: AppTheme.spaceMD),
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceSM),
          decoration: BoxDecoration(
            color: _riskColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            result.interpretation,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: _riskColor,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate500)),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.slate800,
          ),
        ),
      ],
    );
  }
}
