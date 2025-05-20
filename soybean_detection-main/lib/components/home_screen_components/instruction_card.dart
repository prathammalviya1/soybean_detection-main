import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_card.dart';

class InstructionCard extends StatelessWidget {
  const InstructionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.primary.withAlpha(20),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a clear photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Ensure good lighting and that the leaf is clearly visible',
                  style: TextStyle(color: AppColors.textMedium, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
