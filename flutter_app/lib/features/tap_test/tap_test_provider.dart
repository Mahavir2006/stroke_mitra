import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tap_test_service.dart';
import 'tap_scoring.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────
enum ActiveHand { right, left }

enum TestPhase {
  instructionRight,
  testingRight,
  rest,
  instructionLeft,
  testingLeft,
  result,
}

// ─── State ────────────────────────────────────────────────────────────────────
class TapTestState {
  final TestPhase phase;
  final ActiveHand activeHand;
  final bool isRunning;
  final int elapsedSeconds;
  final int hitCount;
  final double buttonX;
  final double buttonY;
  final bool lastHitFlash;
  final int rightHandTaps;
  final int leftHandTaps;
  final int restSecondsLeft;
  final DualTapResult? dualResult;

  const TapTestState({
    this.phase = TestPhase.instructionRight,
    this.activeHand = ActiveHand.right,
    this.isRunning = false,
    this.elapsedSeconds = 0,
    this.hitCount = 0,
    this.buttonX = 0,
    this.buttonY = 0,
    this.lastHitFlash = false,
    this.rightHandTaps = 0,
    this.leftHandTaps = 0,
    this.restSecondsLeft = 5,
    this.dualResult,
  });

  TapTestState copyWith({
    TestPhase? phase,
    ActiveHand? activeHand,
    bool? isRunning,
    int? elapsedSeconds,
    int? hitCount,
    double? buttonX,
    double? buttonY,
    bool? lastHitFlash,
    int? rightHandTaps,
    int? leftHandTaps,
    int? restSecondsLeft,
    DualTapResult? dualResult,
    bool clearResult = false,
  }) {
    return TapTestState(
      phase: phase ?? this.phase,
      activeHand: activeHand ?? this.activeHand,
      isRunning: isRunning ?? this.isRunning,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      hitCount: hitCount ?? this.hitCount,
      buttonX: buttonX ?? this.buttonX,
      buttonY: buttonY ?? this.buttonY,
      lastHitFlash: lastHitFlash ?? this.lastHitFlash,
      rightHandTaps: rightHandTaps ?? this.rightHandTaps,
      leftHandTaps: leftHandTaps ?? this.leftHandTaps,
      restSecondsLeft: restSecondsLeft ?? this.restSecondsLeft,
      dualResult: clearResult ? null : (dualResult ?? this.dualResult),
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class TapTestNotifier extends StateNotifier<TapTestState> {
  // ignore: unused_field
  final TapTestService _service = TapTestService();
  Timer? _moveTimer;
  Timer? _clockTimer;
  Timer? _flashTimer;
  Timer? _restTimer;

  static const double _buttonSize = 72.0;
  static const double _buttonRadius = 36.0;

  double _dx = 2.5;
  double _dy = 1.8;
  double _arenaWidth = 300;
  double _arenaHeight = 340;

  TapTestNotifier() : super(const TapTestState());

  // ─── Start a hand test ────────────────────────────────────────────────────
  void startTest(double arenaWidth, double arenaHeight) {
    _arenaWidth = arenaWidth;
    _arenaHeight = arenaHeight;
    _dx = 2.5;
    _dy = 1.8;

    final startX = (arenaWidth / 2) - _buttonRadius;
    final startY = (arenaHeight / 2) - _buttonRadius;

    final newPhase = state.activeHand == ActiveHand.right
        ? TestPhase.testingRight
        : TestPhase.testingLeft;

    state = state.copyWith(
      phase: newPhase,
      isRunning: true,
      elapsedSeconds: 0,
      hitCount: 0,
      buttonX: startX,
      buttonY: startY,
      lastHitFlash: false,
    );

    // ~60fps bouncing ball — UNCHANGED from original
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
        _finishCurrentHand();
      } else {
        state = state.copyWith(elapsedSeconds: elapsed);
      }
    });
  }

  // ─── Hit detection — UNCHANGED from original ──────────────────────────────
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

  void stopTest() => _finishCurrentHand();

  // ─── Finish whichever hand is active ──────────────────────────────────────
  void _finishCurrentHand() {
    _cancelMoveAndClock();
    final taps = state.hitCount;

    if (state.activeHand == ActiveHand.right) {
      state = state.copyWith(
        isRunning: false,
        rightHandTaps: taps,
        phase: TestPhase.rest,
        restSecondsLeft: 5,
      );
      _startRestCountdown();
    } else {
      // Left hand done — compute combined result
      final dual = DualTapResult.compute(state.rightHandTaps, taps);
      state = state.copyWith(
        isRunning: false,
        leftHandTaps: taps,
        phase: TestPhase.result,
        dualResult: dual,
      );
    }
  }

  // ─── Rest countdown (non-skippable) ───────────────────────────────────────
  void _startRestCountdown() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = state.restSecondsLeft - 1;
      if (left <= 0) {
        _restTimer?.cancel();
        _restTimer = null;
        state = state.copyWith(
          phase: TestPhase.instructionLeft,
          activeHand: ActiveHand.left,
          restSecondsLeft: 0,
        );
      } else {
        state = state.copyWith(restSecondsLeft: left);
      }
    });
  }

  // ─── Full reset ───────────────────────────────────────────────────────────
  void reset() {
    _cancelTimers();
    state = const TapTestState();
  }

  void _cancelMoveAndClock() {
    _moveTimer?.cancel();
    _clockTimer?.cancel();
    _moveTimer = null;
    _clockTimer = null;
  }

  void _cancelTimers() {
    _moveTimer?.cancel();
    _clockTimer?.cancel();
    _flashTimer?.cancel();
    _restTimer?.cancel();
    _moveTimer = null;
    _clockTimer = null;
    _flashTimer = null;
    _restTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final tapTestProvider =
    StateNotifierProvider.autoDispose<TapTestNotifier, TapTestState>(
  (ref) {
    final notifier = TapTestNotifier();
    ref.onDispose(notifier._cancelTimers);
    return notifier;
  },
);
