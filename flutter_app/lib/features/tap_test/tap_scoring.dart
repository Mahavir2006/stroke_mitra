/// Pure scoring logic for the dual-hand Tap Test.
/// No UI, no state — fully testable in isolation.

enum HandRisk { normal, borderline, abnormal }

enum AsymmetryLabel { symmetric, mildAsymmetry, significantAsymmetry }

enum OverallRisk { normal, borderline, abnormal }

class TapScoring {
  TapScoring._();

  static const int _successThreshold = 6;
  static const int _borderlineThreshold = 3;

  /// Score a single hand.
  static HandRisk scoreHand(int taps) {
    if (taps >= _successThreshold) return HandRisk.normal;
    if (taps >= _borderlineThreshold) return HandRisk.borderline;
    return HandRisk.abnormal;
  }

  /// Asymmetry percentage between two hands.
  static double asymmetryPercent(int right, int left) {
    final maxTaps = right > left ? right : left;
    if (maxTaps == 0) return 0.0;
    return ((right - left).abs() / maxTaps) * 100.0;
  }

  /// Label for asymmetry percentage.
  static AsymmetryLabel asymmetryLabel(double percent) {
    if (percent <= 15) return AsymmetryLabel.symmetric;
    if (percent <= 30) return AsymmetryLabel.mildAsymmetry;
    return AsymmetryLabel.significantAsymmetry;
  }

  /// Combined overall risk using 5-rule priority logic.
  /// Returns (overallRisk, lateralisedDeficit).
  static (OverallRisk, bool) overallRisk(
    HandRisk right,
    HandRisk left,
    AsymmetryLabel asymmetry,
  ) {
    // Rule 1 & 2 — Abnormal override / lateralised deficit
    final oneAbnormal =
        right == HandRisk.abnormal || left == HandRisk.abnormal;
    final lateralised = (right == HandRisk.normal && left == HandRisk.abnormal) ||
        (right == HandRisk.abnormal && left == HandRisk.normal);
    if (oneAbnormal) return (OverallRisk.abnormal, lateralised);

    // Rule 3 — Significant asymmetry override
    if (asymmetry == AsymmetryLabel.significantAsymmetry) {
      return (OverallRisk.abnormal, false);
    }

    // Rule 4 — Borderline
    if (right == HandRisk.borderline ||
        left == HandRisk.borderline ||
        asymmetry == AsymmetryLabel.mildAsymmetry) {
      return (OverallRisk.borderline, false);
    }

    // Rule 5 — Normal
    return (OverallRisk.normal, false);
  }

  /// Clinical interpretation string.
  static String interpretation(
      OverallRisk overall, AsymmetryLabel asymmetry, bool lateralised) {
    if (lateralised) {
      return 'A significant difference between your hands was detected. '
          'Please consult your healthcare provider as soon as possible.';
    }
    switch (overall) {
      case OverallRisk.abnormal:
        return 'Significant motor difficulty was detected in one or both hands. '
            'Please consult your healthcare provider as soon as possible.';
      case OverallRisk.borderline:
        return 'Some difference in hand performance was noted. '
            'This may be worth monitoring over time. Consider retesting.';
      case OverallRisk.normal:
        return 'Both hands responded well. '
            'No signs of significant motor impairment were detected during this session.';
    }
  }

  /// Human-readable label strings.
  static String handRiskLabel(HandRisk r) {
    switch (r) {
      case HandRisk.normal:
        return 'Normal';
      case HandRisk.borderline:
        return 'Borderline';
      case HandRisk.abnormal:
        return 'Abnormal';
    }
  }

  static String overallRiskLabel(OverallRisk r) {
    switch (r) {
      case OverallRisk.normal:
        return 'Normal';
      case OverallRisk.borderline:
        return 'Borderline';
      case OverallRisk.abnormal:
        return 'Abnormal';
    }
  }

  static String asymmetryLabelString(AsymmetryLabel a) {
    switch (a) {
      case AsymmetryLabel.symmetric:
        return 'Symmetric';
      case AsymmetryLabel.mildAsymmetry:
        return 'Mild Asymmetry';
      case AsymmetryLabel.significantAsymmetry:
        return 'Significant Asymmetry';
    }
  }
}

/// Combined result after both hands are tested.
class DualTapResult {
  final int rightTaps;
  final int leftTaps;
  final HandRisk rightRisk;
  final HandRisk leftRisk;
  final double asymmetryPercent;
  final AsymmetryLabel asymmetryLabel;
  final OverallRisk overallRisk;
  final bool lateralisedDeficit;
  final String interpretation;

  const DualTapResult({
    required this.rightTaps,
    required this.leftTaps,
    required this.rightRisk,
    required this.leftRisk,
    required this.asymmetryPercent,
    required this.asymmetryLabel,
    required this.overallRisk,
    required this.lateralisedDeficit,
    required this.interpretation,
  });

  factory DualTapResult.compute(int rightTaps, int leftTaps) {
    final rRisk = TapScoring.scoreHand(rightTaps);
    final lRisk = TapScoring.scoreHand(leftTaps);
    final asymPct = TapScoring.asymmetryPercent(rightTaps, leftTaps);
    final asymLabel = TapScoring.asymmetryLabel(asymPct);
    final (overall, lateralised) =
        TapScoring.overallRisk(rRisk, lRisk, asymLabel);
    final interp = TapScoring.interpretation(overall, asymLabel, lateralised);

    return DualTapResult(
      rightTaps: rightTaps,
      leftTaps: leftTaps,
      rightRisk: rRisk,
      leftRisk: lRisk,
      asymmetryPercent: asymPct,
      asymmetryLabel: asymLabel,
      overallRisk: overall,
      lateralisedDeficit: lateralised,
      interpretation: interp,
    );
  }

  Map<String, dynamic> toJson() => {
        'right_hand': {
          'tap_count': rightTaps,
          'risk_level': TapScoring.handRiskLabel(rightRisk).toLowerCase(),
        },
        'left_hand': {
          'tap_count': leftTaps,
          'risk_level': TapScoring.handRiskLabel(leftRisk).toLowerCase(),
        },
        'asymmetry_percent':
            double.parse(asymmetryPercent.toStringAsFixed(1)),
        'asymmetry_label': asymmetryLabel.name,
        'overall_risk': TapScoring.overallRiskLabel(overallRisk).toLowerCase(),
        'lateralised_deficit': lateralisedDeficit,
        'completed_at': DateTime.now().toIso8601String(),
      };
}
