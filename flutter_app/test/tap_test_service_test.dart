import 'package:flutter_test/flutter_test.dart';
import 'package:stroke_mitra/features/tap_test/tap_test_service.dart';

void main() {
  final service = TapTestService();

  test('hitCount = 7 maps to Normal', () {
    final result = service.evaluateResult(7);
    expect(result.riskLevel, 'Normal');
  });

  test('hitCount = 4 maps to Borderline', () {
    final result = service.evaluateResult(4);
    expect(result.riskLevel, 'Borderline');
  });

  test('hitCount = 1 maps to Abnormal', () {
    final result = service.evaluateResult(1);
    expect(result.riskLevel, 'Abnormal');
  });
}
