import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

typedef SourceCallback = void Function();

class ImageSourceOption {
  final IconData icon;
  final String label;
  final SourceCallback onSelect;

  ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onSelect,
  });
}

class ImageSourceModal extends StatelessWidget {
  final List<ImageSourceOption> options;

  const ImageSourceModal({super.key, required this.options});

  static void show(BuildContext context, List<ImageSourceOption> options) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageSourceModal(options: options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacitySafe(0.3),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          Text(
            'Select Image Source',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                options
                    .map(
                      (option) => _buildSourceOption(
                        context,
                        option.icon,
                        option.label,
                        option.onSelect,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
