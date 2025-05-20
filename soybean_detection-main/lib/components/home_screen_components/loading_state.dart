import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_card.dart';

class LoadingStateCard extends StatelessWidget {
  const LoadingStateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      boxShadow: AppShadows.sm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Processing Image...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Please wait while we analyze your image',
            style: TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
