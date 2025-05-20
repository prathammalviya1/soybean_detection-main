import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';

class ConfidenceMeter extends StatelessWidget {
  final double confidence;
  final bool showPercentage;
  final bool showLabel;

  const ConfidenceMeter({
    super.key,
    required this.confidence,
    this.showPercentage = true,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              'Confidence Level',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xs),
                child: LinearProgressIndicator(
                  value: confidence,
                  backgroundColor: Colors.grey.shade200,
                  minHeight: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(),
                  ),
                ),
              ),
            ),
            if (showPercentage) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${(confidence * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getConfidenceColor(),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _getConfidenceColor() {
    if (confidence >= 0.7) {
      return AppColors.success;
    } else if (confidence >= 0.5) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}
