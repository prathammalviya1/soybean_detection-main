import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_card.dart';
import 'package:soybean_detection/models/prediction_model.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

class TreatmentCard extends StatelessWidget {
  final PredictionResult predictionResult;
  final bool isHealthy;
  final bool isValid;

  const TreatmentCard({
    super.key,
    required this.predictionResult,
    required this.isHealthy,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    Color color;

    if (!isValid) {
      icon = Icons.info_outline;
      title = 'Message';
      color = AppColors.warning;
    } else if (isHealthy) {
      icon = Icons.check_circle_outline;
      title = 'Healthy Plant';
      color = AppColors.success;
    } else {
      icon = Icons.medical_information_outlined;
      title = 'Treatment Recommendations';
      color = AppColors.primary;
    }

    return AppCard(
      elevation: 0,
      boxShadow: AppShadows.sm,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      backgroundColor: color.withOpacitySafe(0.06),
      border: Border.all(color: color.withOpacitySafe(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            predictionResult.precautions ?? '',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
