import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_button.dart' as app_btn;

class ActionButtons extends StatelessWidget {
  final bool hasImage;
  final bool isLoading;
  final Function(ImageSource) onPickImage;
  final VoidCallback onAnalyze;

  const ActionButtons({
    super.key,
    required this.hasImage,
    required this.isLoading,
    required this.onPickImage,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: app_btn.AppButton(
                label: 'Camera',
                icon: Icons.camera_alt_rounded,
                onTap: () => onPickImage(ImageSource.camera),
                style: app_btn.ButtonStyle.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: app_btn.AppButton(
                label: 'Gallery',
                icon: Icons.photo_library_rounded,
                onTap: () => onPickImage(ImageSource.gallery),
                style: app_btn.ButtonStyle.secondary,
              ),
            ),
          ],
        ),
        if (hasImage) ...[
          const SizedBox(height: AppSpacing.md),
          app_btn.AppButton(
            label: 'Analyze Disease',
            icon: Icons.search,
            fullWidth: true,
            isLoading: isLoading,
            onTap: onAnalyze,
          ),
        ],
      ],
    );
  }
}
