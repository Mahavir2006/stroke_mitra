/// Stroke Mitra - Motion Test Screen
///
/// Mirrors the React `MotionModule` component.
/// Uses device accelerometer (sensors_plus) to track tilt,
/// displays a moving ball in a circular area, and shows
/// X/Y/Z axis readings in real-time.

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../app/theme.dart';

class MotionTestScreen extends StatefulWidget {
  const MotionTestScreen({super.key});

  @override
  State<MotionTestScreen> createState() => _MotionTestScreenState();
}

class _MotionTestScreenState extends State<MotionTestScreen> {
  bool _isTracking = false;
  double _x = 0, _y = 0, _z = 0;

  // Ball position (pixels)
  double _ballX = 0, _ballY = 0;

  StreamSubscription<AccelerometerEvent>? _subscription;

  void _startTracking() {
    setState(() => _isTracking = true);

    _subscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 50),
    ).listen((event) {
      if (!_isTracking) return;

      setState(() {
        _x = double.parse(event.x.toStringAsFixed(2));
        _y = double.parse(event.y.toStringAsFixed(2));
        _z = double.parse(event.z.toStringAsFixed(2));

        // Move ball — sensitivity factor of 10 (matches React)
        final moveX = event.x * 10;
        final moveY = event.y * 10;

        // Limit to ±80 pixels
        _ballX = moveX.clamp(-80.0, 80.0);
        _ballY = (-moveY).clamp(-80.0, 80.0); // Invert Y to match visual
      });
    });
  }

  void _stopTracking() {
    _subscription?.cancel();
    setState(() {
      _isTracking = false;
      _x = 0;
      _y = 0;
      _z = 0;
      _ballX = 0;
      _ballY = 0;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── Header ───
          Row(
            children: [
              Icon(Icons.show_chart_rounded,
                  color: AppTheme.primary, size: 24),
              const SizedBox(width: 8),
              Text('Motion Analysis', style: AppTheme.headingMD),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hold your device flat. Press start and gently tilt your device.',
              style: AppTheme.bodyMD,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Feedback Area — Tilt Ball ───
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bgCard,
              border: Border.all(color: Colors.grey.shade200, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center target dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                // Moving ball
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..translate(_ballX, _ballY),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Metrics Grid ───
          Row(
            children: [
              _MetricBox(label: 'X - Axis', value: _x.toString()),
              const SizedBox(width: AppTheme.spaceMD),
              _MetricBox(label: 'Y - Axis', value: _y.toString()),
              const SizedBox(width: AppTheme.spaceMD),
              _MetricBox(label: 'Z - Axis', value: _z.toString()),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),

          // ─── Start/Stop Button ───
          SizedBox(
            width: 300,
            child: !_isTracking
                ? ElevatedButton.icon(
                    onPressed: _startTracking,
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Start Test'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: _stopTracking,
                    icon: const Icon(Icons.stop_rounded, size: 20),
                    label: const Text('Stop'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.statusError,
                      side: const BorderSide(color: AppTheme.statusError),
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: AppTheme.spaceLG),
        ],
      ),
    );
  }
}

/// Individual metric display box — matches React .metric-box
class _MetricBox extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.slate500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
                color: AppTheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
