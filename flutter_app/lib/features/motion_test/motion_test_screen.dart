import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../shared/utils/session_service.dart';
import 'motion_provider.dart';
import 'motion_service.dart';

class MotionTestScreen extends ConsumerWidget {
  const MotionTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(motionProvider);
    final notifier = ref.read(motionProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header ───
          Row(children: [
            const Icon(Icons.accessibility_new_rounded, color: AppTheme.primary, size: 24),
            const SizedBox(width: 8),
            Text('Arms Test', style: AppTheme.headingMD),
          ]),
          const SizedBox(height: AppTheme.spaceSM),

          // ─── Instruction Card ───
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
                  'Hold your phone flat with both arms extended. Keep it as steady as possible for ${MotionService.recordingSeconds} seconds.',
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.blue700, height: 1.5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Ball Visualiser ───
          Center(
            child: _BallVisualiser(
              offsetX: state.ballOffsetX,
              offsetY: state.ballOffsetY,
              riskLevel: state.result?.riskLevel,
              isRecording: state.isRecording,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Live Axis Readout ───
          if (state.isRecording)
            Row(children: [
              _MetricBox(label: 'X Tilt', value: state.liveX.toStringAsFixed(2)),
              const SizedBox(width: AppTheme.spaceSM),
              _MetricBox(label: 'Y Tilt', value: state.liveY.toStringAsFixed(2)),
              const SizedBox(width: AppTheme.spaceSM),
              _MetricBox(
                label: 'Time Left',
                value: '${MotionService.recordingSeconds - state.elapsedSeconds}s',
              ),
            ]),

          // ─── Progress Bar ───
          if (state.isRecording) ...[
            const SizedBox(height: AppTheme.spaceMD),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.elapsedSeconds / MotionService.recordingSeconds,
                minHeight: 8,
                backgroundColor: AppTheme.slate200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${MotionService.recordingSeconds - state.elapsedSeconds} seconds remaining',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.slate500),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: AppTheme.spaceLG),

          // ─── Start / Stop Button ───
          if (state.result == null)
            SizedBox(
              height: 52,
              child: state.isRecording
                  ? OutlinedButton.icon(
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
                    )
                  : ElevatedButton.icon(
                      onPressed: notifier.startTest,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start Test'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                        ),
                      ),
                    ),
            ),

          // ─── Results Card ───
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: AppTheme.spaceMD),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await SessionService.submitData(
                    'temp-session',
                    AppConstants.dataTypeMotion,
                    state.result!.toJson(),
                  );
                  notifier.reset();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Test Again'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

// ─── Ball Visualiser Widget ───────────────────────────────────────────────────
class _BallVisualiser extends StatelessWidget {
  final double offsetX;
  final double offsetY;
  final String? riskLevel;
  final bool isRecording;

  const _BallVisualiser({
    required this.offsetX,
    required this.offsetY,
    required this.riskLevel,
    required this.isRecording,
  });

  Color get _ballColor {
    if (!isRecording && riskLevel == null) return AppTheme.slate300;
    switch (riskLevel) {
      case 'Abnormal': return AppTheme.statusError;
      case 'Borderline': return AppTheme.statusWarning;
      case 'Normal': return AppTheme.statusSuccess;
      default: return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    const boxSize = 280.0;
    const ballSize = 40.0;
    const center = boxSize / 2 - ballSize / 2;

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.slate200, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center crosshair
          Center(
            child: Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: AppTheme.slate300,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Animated ball
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
            left: (center + offsetX).clamp(0, boxSize - ballSize),
            top: (center + offsetY).clamp(0, boxSize - ballSize),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: ballSize,
              height: ballSize,
              decoration: BoxDecoration(
                color: _ballColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _ballColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Result Card Widget ───────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final MotionResult result;
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

  String get _interpretation {
    switch (result.riskLevel) {
      case 'Abnormal':
        return 'Significant arm drift detected. Seek medical attention immediately.';
      case 'Borderline':
        return 'Some instability detected. Retest recommended.';
      default:
        return 'Arm stability is within normal range.';
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
        // Risk badge
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

        // Metrics
        _MetricRow(label: 'Tilt Variance', value: result.varianceScore.toStringAsFixed(2)),
        const SizedBox(height: AppTheme.spaceSM),
        _MetricRow(label: 'Drift Score', value: result.driftMagnitude.toStringAsFixed(2)),
        const SizedBox(height: AppTheme.spaceSM),
        _MetricRow(label: 'Samples', value: result.sampleCount.toString()),
        const SizedBox(height: AppTheme.spaceMD),

        // Interpretation
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceSM),
          decoration: BoxDecoration(
            color: _riskColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Text(
            _interpretation,
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

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetricRow({required this.label, required this.value});

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

// ─── Metric Box (live readout during recording) ───────────────────────────────
class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  const _MetricBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.slate200),
        ),
        child: Column(children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.slate500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
              fontFeatures: const [],
            ),
          ),
        ]),
      ),
    );
  }
}
