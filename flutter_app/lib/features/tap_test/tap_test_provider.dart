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

  static const double _buttonSize = 72.0;
  static const double _buttonRadius = 36.0;

  // Bouncing ball velocity
  double _dx = 2.5;
  double _dy = 1.8;
  double _arenaWidth = 300;
  double _arenaHeight = 340;

  TapTestNotifier() : super(const TapTestState());

  void startTest(double arenaWidth, double arenaHeight) {
    _arenaWidth = arenaWidth;
    _arenaHeight = arenaHeight;
    _dx = 2.5;
    _dy = 1.8;

    // Start in the centre
    final startX = (arenaWidth / 2) - _buttonRadius;
    final startY = (arenaHeight / 2) - _buttonRadius;

    state = TapTestState(
      isRunning: true,
      buttonX: startX,
      buttonY: startY,
    );

    // ~60fps movement — pure bouncing ball, no sensors needed
    _moveTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      double nx = state.buttonX + _dx;
      double ny = state.buttonY + _dy;

      final maxX = _arenaWidth - _buttonSize;
      final maxY = _arenaHeight - _buttonSize;

      if (nx <= 0) {
        nx = 0;
        _dx = _dx.abs();
      } else if (nx >= maxX) {
        nx = maxX;
        _dx = -_dx.abs();
      }

      if (ny <= 0) {
        ny = 0;
        _dy = _dy.abs();
      } else if (ny >= maxY) {
        ny = maxY;
        _dy = -_dy.abs();
      }

      state = state.copyWith(buttonX: nx, buttonY: ny);
    });

    // 1-second elapsed counter
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
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

    final centerX = state.buttonX + _buttonRadius;
    final centerY = state.buttonY + _buttonRadius;
    final dx = tapPosition.dx - centerX;
    final dy = tapPosition.dy - centerY;
    final distSq = dx * dx + dy * dy;

    if (distSq <= _buttonRadius * _buttonRadius) {
      _flashTimer?.cancel();
      state = state.copyWith(
        hitCount: state.hitCount + 1,
        lastHitFlash: true,
      );
      _flashTimer = Timer(const Duration(milliseconds: 150), () {
        if (mounted) state = state.copyWith(lastHitFlash: false);
      });
    }
  }

  void stopTest() => _finishTest();

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
