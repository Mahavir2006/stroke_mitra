import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'motion_service.dart';

class MotionState {
  final bool isRecording;
  final int elapsedSeconds;
  final double liveX;
  final double liveY;
  final double ballOffsetX;
  final double ballOffsetY;
  final MotionResult? result;

  const MotionState({
    this.isRecording = false,
    this.elapsedSeconds = 0,
    this.liveX = 0,
    this.liveY = 0,
    this.ballOffsetX = 0,
    this.ballOffsetY = 0,
    this.result,
  });

  MotionState copyWith({
    bool? isRecording,
    int? elapsedSeconds,
    double? liveX,
    double? liveY,
    double? ballOffsetX,
    double? ballOffsetY,
    MotionResult? result,
    bool clearResult = false,
  }) {
    return MotionState(
      isRecording: isRecording ?? this.isRecording,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      liveX: liveX ?? this.liveX,
      liveY: liveY ?? this.liveY,
      ballOffsetX: ballOffsetX ?? this.ballOffsetX,
      ballOffsetY: ballOffsetY ?? this.ballOffsetY,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

class MotionNotifier extends StateNotifier<MotionState> {
  final MotionService _service = MotionService();

  MotionNotifier() : super(const MotionState());

  static const double _scale = 60.0;
  static const double _clamp = 110.0;

  void startTest() {
    state = const MotionState(isRecording: true);

    _service.startRecording(
      onEvent: (AccelerometerEvent event) {
        state = state.copyWith(
          liveX: double.parse(event.x.toStringAsFixed(2)),
          liveY: double.parse(event.y.toStringAsFixed(2)),
          ballOffsetX: (event.x * _scale).clamp(-_clamp, _clamp),
          ballOffsetY: (-event.y * _scale).clamp(-_clamp, _clamp),
        );
      },
      onTick: (int elapsed) {
        state = state.copyWith(elapsedSeconds: elapsed);
      },
      onComplete: (MotionResult result) {
        state = state.copyWith(isRecording: false, result: result);
      },
    );
  }

  void stopTest() {
    final result = _service.stopRecording();
    state = state.copyWith(
      isRecording: false,
      result: result,
    );
  }

  void reset() {
    _service.dispose();
    state = const MotionState();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

final motionProvider =
    StateNotifierProvider.autoDispose<MotionNotifier, MotionState>(
  (ref) => MotionNotifier(),
);
