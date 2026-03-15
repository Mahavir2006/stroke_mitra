import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tap_test_service.dart';

class TapTestState {
  final bool isRunning;
  final int elapsedSeconds;
  final int hitCount;
  final double buttonX;
  final double buttonY;
  final bool lastHitFlash;
  final TapResult? result;

  const TapTestState({
    this.isRunning = false,
    this.elapsedSeconds = 0,
    this.hitCount = 0,
    this.buttonX = 0,
    this.buttonY = 0,
    this.lastHitFlash = false,
    this.result,
  });

  TapTestState copyWith({
    bool? isRunning,
    int? elapsedSeconds,
    int? hitCount,
    double? buttonX,
    double? buttonY,
    bool? lastHitFlash,
    TapResult? result,
    bool clearResult = false,
  }) {
    return TapTestState(
      isRunning: isRunning ?? this.isRunning,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      hitCount: hitCount ?? this.hitCount,
      buttonX: buttonX ?? this.buttonX,
      buttonY: buttonY ?? this.buttonY,
      lastHitFlash: lastHitFlash ?? this.lastHitFlash,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

class TapTestNotifier extends StateNotifier<TapTestState> {
  final TapTestService _service = TapTestService();
  Timer? _moveTimer;
  Timer? _clockTimer;
  Timer? _flashTimer;

  static const double _buttonRadius = 36.0;
  static const double _buttonDiameter = 72.0;

  double _dx = 1.4;
  double _dy = 1.0;
  double _screenWidth = 0;
  double _screenHeight = 0;

  TapTestNotifier() : super(const TapTestState());

  void startTest(double screenWidth, double screenHeight) {
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    _dx = 1.4;
    _dy = 1.0;

    final startX = screenWidth / 2 - _buttonRadius;
    final startY = screenHeight / 2 - _buttonRadius;

    state = TapTestState(
      isRunning: true,
      buttonX: startX,
      buttonY: startY,
    );

    // 60fps movement timer
    _moveTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      double nx = state.buttonX + _dx;
      double ny = state.buttonY + _dy;

      // Bounce off walls
      if (nx <= 0 || nx >= _screenWidth - _buttonDiameter) {
        _dx = -_dx;
        nx = nx.clamp(0, _screenWidth - _buttonDiameter);
      }
      if (ny <= 0 || ny >= _screenHeight - _buttonDiameter) {
        _dy = -_dy;
        ny = ny.clamp(0, _screenHeight - _buttonDiameter);
      }

      state = state.copyWith(buttonX: nx, buttonY: ny);
    });

    // 1-second elapsed counter
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      final elapsed = state.elapsedSeconds + 1;
      if (elapsed >= TapTestService.testDurationSeconds) {
        _finishTest();
      } else {
        state = state.copyWith(elapsedSeconds: elapsed);
      }
    });
  }

  void registerTap(Offset tapPosition) {
    if (!state.isRunning) return;

    final buttonCenterX = state.buttonX + _buttonRadius;
    final buttonCenterY = state.buttonY + _buttonRadius;
    final dx = tapPosition.dx - buttonCenterX;
    final dy = tapPosition.dy - buttonCenterY;
    final distance = (dx * dx + dy * dy);

    if (distance <= _buttonRadius * _buttonRadius) {
      _flashTimer?.cancel();
      state = state.copyWith(
        hitCount: state.hitCount + 1,
        lastHitFlash: true,
      );
      _flashTimer = Timer(const Duration(milliseconds: 150), () {
        state = state.copyWith(lastHitFlash: false);
      });
    }
  }

  void stopTest() {
    _finishTest();
  }

  void reset() {
    _cancelTimers();
    state = const TapTestState();
  }

  void _finishTest() {
    _cancelTimers();
    final result = _service.evaluateResult(state.hitCount);
    state = state.copyWith(
      isRunning: false,
      elapsedSeconds: TapTestService.testDurationSeconds,
      result: result,
    );
  }

  void _cancelTimers() {
    _moveTimer?.cancel();
    _clockTimer?.cancel();
    _flashTimer?.cancel();
    _moveTimer = null;
    _clockTimer = null;
    _flashTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}

final tapTestProvider =
    StateNotifierProvider.autoDispose<TapTestNotifier, TapTestState>(
  (ref) {
    final notifier = TapTestNotifier();
    ref.onDispose(notifier._cancelTimers);
    return notifier;
  },
);
