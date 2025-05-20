import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_card.dart';
import 'package:soybean_detection/components/confidence_meter.dart';
import 'package:soybean_detection/models/prediction_model.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

class DetectionCard extends StatelessWidget {
  final PredictionResult predictionResult;
  final bool isHealthy;
  final bool isValid;

  const DetectionCard({
    super.key,
    required this.predictionResult,
    required this.isHealthy,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: 0,
      backgroundColor: AppColors.cardBackground,
      boxShadow: AppShadows.sm,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacitySafe(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Detection Result',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Disease name
          Text(
            'Detected Condition',
            style: TextStyle(fontSize: 14, color: AppColors.textMedium),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            predictionResult.predictedClass,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _getStatusColor(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Only show confidence meter if it's a valid soybean leaf detection
          if (isValid)
            ConfidenceMeter(
              confidence: predictionResult.confidence,
              showPercentage: true,
              showLabel: true,
            ),

          // When not a valid soybean leaf, show an alternative message
          if (!isValid)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'Please upload a clear image of a soybean leaf for accurate analysis.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!isValid) return AppColors.warning;
    if (isHealthy) return AppColors.success;
    return AppColors.error;
  }

  IconData _getStatusIcon() {
    if (!isValid) return Icons.help_outline;
    if (isHealthy) return Icons.check_circle_outline;
    return Icons.warning_amber_rounded;
  }
}
