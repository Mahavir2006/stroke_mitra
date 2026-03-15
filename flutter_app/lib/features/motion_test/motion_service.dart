import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class MotionResult {
  final double varianceScore;
  final double driftMagnitude;
  final String riskLevel;
  final int sampleCount;

  const MotionResult({
    required this.varianceScore,
    required this.driftMagnitude,
    required this.riskLevel,
    required this.sampleCount,
  });

  Map<String, dynamic> toJson() => {
    'variance_score': double.parse(varianceScore.toStringAsFixed(4)),
    'drift_magnitude': double.parse(driftMagnitude.toStringAsFixed(4)),
    'risk_level': riskLevel,
    'sample_count': sampleCount,
  };
}

class MotionService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  Timer? _timer;
  final List<AccelerometerEvent> _events = [];

  static const int recordingSeconds = 15;

  /// Starts a 15-second accelerometer recording window.
  /// [onEvent] fires on every sample with the latest event.
  /// [onTick] fires every second with elapsed seconds.
  /// [onComplete] fires when the 15s window ends with the result.
  void startRecording({
    required void Function(AccelerometerEvent) onEvent,
    required void Function(int elapsed) onTick,
    required void Function(MotionResult) onComplete,
  }) {
    _events.clear();
    int elapsed = 0;

    _subscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 50),
    ).listen((event) {
      _events.add(event);
      onEvent(event);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      elapsed++;
      onTick(elapsed);
      if (elapsed >= recordingSeconds) {
        stopRecording();
        onComplete(analyzeResults(_events));
      }
    });
  }

  /// Stops recording early and returns the result.
  MotionResult? stopRecording() {
    _subscription?.cancel();
    _subscription = null;
    _timer?.cancel();
    _timer = null;
    if (_events.isEmpty) return null;
    return analyzeResults(_events);
  }

  /// Computes drift magnitude and tilt variance from raw events.
  MotionResult analyzeResults(List<AccelerometerEvent> events) {
    if (events.isEmpty) {
      return const MotionResult(
        varianceScore: 0,
        driftMagnitude: 0,
        riskLevel: 'Normal',
        sampleCount: 0,
      );
    }

    final n = events.length;
    final meanX = events.map((e) => e.x).reduce((a, b) => a + b) / n;
    final meanY = events.map((e) => e.y).reduce((a, b) => a + b) / n;

    final varX = events.map((e) => pow(e.x - meanX, 2)).reduce((a, b) => a + b) / n;
    final varY = events.map((e) => pow(e.y - meanY, 2)).reduce((a, b) => a + b) / n;

    final combinedVariance = (varX + varY) / 2;
    final driftMagnitude = sqrt(meanX * meanX + meanY * meanY);

    String riskLevel;
    if (combinedVariance < 0.08 && driftMagnitude < 0.3) {
      riskLevel = 'Normal';
    } else if (combinedVariance < 0.5 && driftMagnitude < 0.7) {
      riskLevel = 'Borderline';
    } else {
      riskLevel = 'Abnormal';
    }

    return MotionResult(
      varianceScore: combinedVariance.toDouble(),
      driftMagnitude: driftMagnitude,
      riskLevel: riskLevel,
      sampleCount: n,
    );
  }

  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
  }
}
