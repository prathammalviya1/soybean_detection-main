import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';

class Credits extends StatelessWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco_outlined, size: 14, color: AppColors.textLight),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Powered by TensorFlow Lite',
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
