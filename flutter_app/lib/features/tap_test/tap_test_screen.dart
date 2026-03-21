import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'tap_scoring.dart';
import 'tap_test_provider.dart';
import 'tap_test_service.dart';

const double _kArenaHeight = 340.0;
const double _kButtonSize = 72.0;

// ─── Root Screen ──────────────────────────────────────────────────────────────
class TapTestScreen extends ConsumerWidget {
  const TapTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tapTestProvider);
    final notifier = ref.read(tapTestProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(children: [
            const Icon(Icons.touch_app_rounded, color: AppTheme.primary, size: 24),
            const SizedBox(width: 8),
            Text('Tap Test', style: AppTheme.headingMD),
          ]),
          const SizedBox(height: AppTheme.spaceMD),

          // Phase router
          _buildPhase(context, state, notifier),

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }

  Widget _buildPhase(
      BuildContext context, TapTestState state, TapTestNotifier notifier) {
    switch (state.phase) {
      case TestPhase.instructionRight:
        return _InstructionCard(
          hand: ActiveHand.right,
          onStart: (w, h) => notifier.startTest(w, h),
        );
      case TestPhase.testingRight:
      case TestPhase.testingLeft:
        return _ArenaSection(state: state, notifier: notifier);
      case TestPhase.rest:
        return _RestScreen(secondsLeft: state.restSecondsLeft);
      case TestPhase.instructionLeft:
        return _InstructionCard(
          hand: ActiveHand.left,
          onStart: (w, h) => notifier.startTest(w, h),
        );
      case TestPhase.result:
        return _CombinedResultCard(
          result: state.dualResult!,
          onSave: () async {
            await SessionService.submitData(
              'temp-session',
              AppConstants.dataTypeTap,
              state.dualResult!.toJson(),
            );
            notifier.reset();
          },
          onRetry: notifier.reset,
        );
    }
  }
}

// ─── Instruction Card ─────────────────────────────────────────────────────────
class _InstructionCard extends StatelessWidget {
  final ActiveHand hand;
  final void Function(double w, double h) onStart;

  const _InstructionCard({required this.hand, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final isRight = hand == ActiveHand.right;
    final label = isRight ? 'Right Hand' : 'Left Hand';
    final instruction = isRight
        ? 'Use your RIGHT hand to tap the moving button as many times as you can in 20 seconds.'
        : 'Use your LEFT hand to tap the moving button as many times as you can in 20 seconds.';

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Step indicator
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _StepDot(active: isRight, label: '1'),
        Container(width: 32, height: 2, color: AppTheme.slate200),
        _StepDot(active: !isRight, label: '2'),
      ]),
      const SizedBox(height: AppTheme.spaceLG),

      // Hand illustration
      Center(
        child: _HandIllustration(hand: hand),
      ),
      const SizedBox(height: AppTheme.spaceMD),

      // Title
      Center(
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
      ),
      const SizedBox(height: AppTheme.spaceMD),

      // Instruction box
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
              instruction,
              style: GoogleFonts.inter(
                  fontSize: 15, color: AppTheme.blue700, height: 1.6),
            ),
          ),
        ]),
      ),
      const SizedBox(height: AppTheme.spaceLG),

      // Arena placeholder + start button
      LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Column(children: [
          Container(
            width: w,
            height: _kArenaHeight,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(color: AppTheme.slate200, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.touch_app_rounded,
                  size: 64, color: AppTheme.slate300),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => onStart(w, _kArenaHeight),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('Start $label Test'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
              ),
            ),
          ),
        ]);
      }),
    ]);
  }
}

// ─── Hand Illustration ────────────────────────────────────────────────────────
class _HandIllustration extends StatelessWidget {
  final ActiveHand hand;
  const _HandIllustration({required this.hand});

  @override
  Widget build(BuildContext context) {
    final isRight = hand == ActiveHand.right;
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(isRight ? 1.0 : -1.0, 1.0),
        child: const Icon(Icons.back_hand_rounded,
            size: 52, color: AppTheme.primary),
      ),
    );
  }
}

// ─── Step Dot ─────────────────────────────────────────────────────────────────
class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  const _StepDot({required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: active ? AppTheme.primary : AppTheme.slate200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppTheme.slate500,
          ),
        ),
      ),
    );
  }
}

// ─── Arena Section (active test) ─────────────────────────────────────────────
class _ArenaSection extends StatelessWidget {
  final TapTestState state;
  final TapTestNotifier notifier;
  const _ArenaSection({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isRight = state.activeHand == ActiveHand.right;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Hand label banner
      Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spaceSM, horizontal: AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
            child: const Icon(Icons.back_hand_rounded,
                size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            isRight ? 'RIGHT HAND' : 'LEFT HAND',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ]),
      ),
      const SizedBox(height: AppTheme.spaceMD),

      // Arena
      LayoutBuilder(builder: (context, constraints) {
        return Column(children: [
          GestureDetector(
            onTapDown: (d) => notifier.registerTap(d.localPosition),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              child: Container(
                width: constraints.maxWidth,
                height: _kArenaHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: _RunningArena(state: state),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: notifier.stopTest,
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Stop Early'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.statusError,
                side: const BorderSide(color: AppTheme.statusError, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
              ),
            ),
          ),
        ]);
      }),
    ]);
  }
}

// ─── Running Arena ────────────────────────────────────────────────────────────
class _RunningArena extends StatelessWidget {
  final TapTestState state;
  const _RunningArena({required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _kArenaHeight,
      child: Stack(
        children: [
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
          Positioned(
            top: 16,
            right: 16,
            child: Text(
              '${TapTestService.testDurationSeconds - state.elapsedSeconds}s',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.slate400,
              ),
            ),
          ),
          Positioned(
            left: state.buttonX,
            top: state.buttonY,
            width: _kButtonSize,
            height: _kButtonSize,
            child: _TapButton(flash: state.lastHitFlash),
          ),
        ],
      ),
    );
  }
}

// ─── Tap Button ───────────────────────────────────────────────────────────────
class _TapButton extends StatelessWidget {
  final bool flash;
  const _TapButton({required this.flash});

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: _kButtonSize,
      height: _kButtonSize,
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.8),
            blurRadius: 24,
            spreadRadius: 6,
          ),
        ],
      ),
      child: const Icon(Icons.touch_app_rounded, color: Colors.white, size: 34),
    );

    if (flash) {
      return button
          .animate()
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.3, 1.3),
            duration: 150.ms,
          )
          .then()
          .scale(
            begin: const Offset(1.3, 1.3),
            end: const Offset(1.0, 1.0),
            duration: 150.ms,
          );
    }
    return button;
  }
}

// ─── Rest Screen ──────────────────────────────────────────────────────────────
class _RestScreen extends StatelessWidget {
  final int secondsLeft;
  const _RestScreen({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.slate200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.statusSuccess, size: 56),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'Right hand done!',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.slate800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Now switch to your LEFT hand.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.slate600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceXL),
          // Countdown circle
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTheme.blue50,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 3),
            ),
            child: Center(
              child: Text(
                '$secondsLeft',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'Starting left hand test in $secondsLeft second${secondsLeft == 1 ? '' : 's'}…',
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.slate500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Combined Result Card ─────────────────────────────────────────────────────
class _CombinedResultCard extends StatelessWidget {
  final DualTapResult result;
  final VoidCallback onSave;
  final VoidCallback onRetry;

  const _CombinedResultCard({
    required this.result,
    required this.onSave,
    required this.onRetry,
  });

  Color _riskColor(OverallRisk r) {
    switch (r) {
      case OverallRisk.abnormal:
        return AppTheme.statusError;
      case OverallRisk.borderline:
        return AppTheme.statusWarning;
      case OverallRisk.normal:
        return AppTheme.statusSuccess;
    }
  }

  Color _handRiskColor(HandRisk r) {
    switch (r) {
      case HandRisk.abnormal:
        return AppTheme.statusError;
      case HandRisk.borderline:
        return AppTheme.statusWarning;
      case HandRisk.normal:
        return AppTheme.statusSuccess;
    }
  }

  IconData _riskIcon(OverallRisk r) {
    switch (r) {
      case OverallRisk.abnormal:
        return Icons.warning_rounded;
      case OverallRisk.borderline:
        return Icons.info_rounded;
      case OverallRisk.normal:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final overallColor = _riskColor(result.overallRisk);
    final maxTaps = result.rightTaps > result.leftTaps
        ? result.rightTaps
        : result.leftTaps;
    final rightFill = maxTaps == 0 ? 0.0 : result.rightTaps / maxTaps;
    final leftFill = maxTaps == 0 ? 0.0 : result.leftTaps / maxTaps;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: overallColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── Overall badge ──
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          decoration: BoxDecoration(
            color: overallColor.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(_riskIcon(result.overallRisk), color: overallColor, size: 28),
              const SizedBox(width: 8),
              Text(
                TapScoring.overallRiskLabel(result.overallRisk),
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: overallColor,
                ),
              ),
            ]),
            if (result.lateralisedDeficit) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceSM, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.statusError.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Text(
                  'Lateralised Deficit Detected',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.statusError,
                  ),
                ),
              ),
            ],
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // ── Hand scores row ──
            Row(children: [
              Expanded(
                child: _HandScoreBox(
                  hand: ActiveHand.right,
                  taps: result.rightTaps,
                  risk: result.rightRisk,
                  color: _handRiskColor(result.rightRisk),
                ),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                child: _HandScoreBox(
                  hand: ActiveHand.left,
                  taps: result.leftTaps,
                  risk: result.leftRisk,
                  color: _handRiskColor(result.leftRisk),
                ),
              ),
            ]),

            const SizedBox(height: AppTheme.spaceLG),
            Divider(color: AppTheme.slate200),
            const SizedBox(height: AppTheme.spaceMD),

            // ── Asymmetry section ──
            Text(
              'Asymmetry Analysis',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.slate800,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Asymmetry Index',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.slate500)),
                Text(
                  '${result.asymmetryPercent.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.slate800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Assessment',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.slate500)),
                Text(
                  TapScoring.asymmetryLabelString(result.asymmetryLabel),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _riskColor(result.overallRisk),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceMD),

            // Asymmetry bar
            _AsymmetryBar(
                rightFill: rightFill,
                leftFill: leftFill,
                rightTaps: result.rightTaps,
                leftTaps: result.leftTaps),

            const SizedBox(height: AppTheme.spaceLG),
            Divider(color: AppTheme.slate200),
            const SizedBox(height: AppTheme.spaceMD),

            // ── Clinical interpretation ──
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              decoration: BoxDecoration(
                color: overallColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: Text(
                result.interpretation,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: overallColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceLG),

            // ── Action buttons ──
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onSave,
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
                    onPressed: onRetry,
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
          ]),
        ),
      ]),
    );
  }
}

// ─── Hand Score Box ───────────────────────────────────────────────────────────
class _HandScoreBox extends StatelessWidget {
  final ActiveHand hand;
  final int taps;
  final HandRisk risk;
  final Color color;

  const _HandScoreBox({
    required this.hand,
    required this.taps,
    required this.risk,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = hand == ActiveHand.right;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(isRight ? 1.0 : -1.0, 1.0),
          child: Icon(Icons.back_hand_rounded, size: 28, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          isRight ? 'Right Hand' : 'Left Hand',
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.slate600),
        ),
        const SizedBox(height: 4),
        Text(
          '$taps taps',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.slate800,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            TapScoring.handRiskLabel(risk),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Asymmetry Bar ────────────────────────────────────────────────────────────
class _AsymmetryBar extends StatelessWidget {
  final double rightFill;
  final double leftFill;
  final int rightTaps;
  final int leftTaps;

  const _AsymmetryBar({
    required this.rightFill,
    required this.leftFill,
    required this.rightTaps,
    required this.leftTaps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('R: $rightTaps',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary)),
          Text('L: $leftTaps',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondary)),
        ],
      ),
      const SizedBox(height: 6),
      LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Row(children: [
          // Right bar (left-aligned)
          Container(
            width: w / 2,
            height: 12,
            alignment: Alignment.centerRight,
            child: Container(
              width: (w / 2) * rightFill,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(6)),
              ),
            ),
          ),
          // Left bar (right-aligned)
          Container(
            width: w / 2,
            height: 12,
            alignment: Alignment.centerLeft,
            child: Container(
              width: (w / 2) * leftFill,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(6)),
              ),
            ),
          ),
        ]);
      }),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Right',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppTheme.slate400)),
          Text('Left',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppTheme.slate400)),
        ],
      ),
    ]);
  }
}
