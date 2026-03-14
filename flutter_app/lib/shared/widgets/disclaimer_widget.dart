/// Stroke Mitra - Disclaimer Widget
///
/// Warning banner shown on the dashboard, matching the
/// original React `Disclaimer` component exactly.

import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spaceXL),
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.statusWarning.withValues(alpha: 0.1),
        border: Border.all(
          color: AppTheme.statusWarning.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.statusWarning,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.disclaimerTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.disclaimerBody,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.slate500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
