class TapResult {
  final int hitCount;
  final String riskLevel;
  final String interpretation;

  const TapResult({
    required this.hitCount,
    required this.riskLevel,
    required this.interpretation,
  });

  Map<String, dynamic> toJson() => {
    'hit_count': hitCount,
    'risk_level': riskLevel,
    'interpretation': interpretation,
    'test_duration': TapTestService.testDurationSeconds,
  };
}

class TapTestService {
  static const int testDurationSeconds = 20;
  static const int successThreshold = 6;

  TapResult evaluateResult(int hitCount) {
    if (hitCount >= successThreshold) {
      return TapResult(
        hitCount: hitCount,
        riskLevel: 'Normal',
        interpretation: 'Finger coordination is within normal range.',
      );
    } else if (hitCount >= 3) {
      return TapResult(
        hitCount: hitCount,
        riskLevel: 'Borderline',
        interpretation: 'Reduced tapping accuracy detected. Retest recommended.',
      );
    } else {
      return TapResult(
        hitCount: hitCount,
        riskLevel: 'Abnormal',
        interpretation: 'Significant motor difficulty detected. Seek medical attention immediately.',
      );
    }
  }
}
