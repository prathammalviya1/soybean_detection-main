import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/status_badge.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

class ImagePreview extends StatelessWidget {
  final File imageFile;
  final VoidCallback onClose;

  const ImagePreview({
    super.key,
    required this.imageFile,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            Hero(
              tag: 'selected_image',
              child: Image.file(
                imageFile,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame != null ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacitySafe(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacitySafe(0.7),
                    ],
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Hero(
                tag: 'status_badge',
                child: Material(
                  color: Colors.transparent,
                  child: StatusBadge(
                    type: StatusType.info,
                    text: 'Ready for Analysis',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
