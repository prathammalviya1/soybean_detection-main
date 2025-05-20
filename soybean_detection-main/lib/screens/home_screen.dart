import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/providers/detection_provider.dart';
import 'package:soybean_detection/screens/result_screen.dart';
import 'package:soybean_detection/utils/page_transitions.dart';

// Import the component modules
import 'package:soybean_detection/components/home_screen_components/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DetectionProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildImageSection(context, provider),
                    const SizedBox(height: AppSpacing.lg),
                    const InstructionCard(),
                    const SizedBox(height: AppSpacing.md),
                    ActionButtons(
                      hasImage: provider.hasImage,
                      isLoading: provider.isLoading,
                      onPickImage:
                          (source) => provider.pickImage(source, context),
                      onAnalyze:
                          () => _analyzeDiseaseAndNavigate(context, provider),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const FeaturesGrid(),
                    const SizedBox(height: AppSpacing.lg),
                    const Credits(),
                    const SizedBox(height: AppSpacing.md),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, DetectionProvider provider) {
    if (provider.isLoading) {
      return const LoadingStateCard();
    }

    if (provider.selectedImage != null) {
      return ImagePreview(
        imageFile: provider.selectedImage!,
        onClose: provider.resetState,
      );
    }

    return EnhancedImagePlaceholder(
      onSelectImageTap: () => _showImageSourceOptions(context),
    );
  }

  void _showImageSourceOptions(BuildContext context) {
    final provider = Provider.of<DetectionProvider>(context, listen: false);

    ImageSourceModal.show(context, [
      ImageSourceOption(
        icon: Icons.camera_alt_outlined,
        label: 'Camera',
        onSelect: () => provider.pickImage(ImageSource.camera, context),
      ),
      ImageSourceOption(
        icon: Icons.photo_outlined,
        label: 'Gallery',
        onSelect: () => provider.pickImage(ImageSource.gallery, context),
      ),
    ]);
  }

  // Optimized implementation kept from original
  Future<void> _analyzeDiseaseAndNavigate(
    BuildContext context,
    DetectionProvider provider,
  ) async {
    final loadingOverlay = _showLoadingOverlay(context);

    try {
      // Fix: Change from detectDisease to analyzeDisease
      await provider.analyzeDisease();
      loadingOverlay.remove();

      if (provider.state == DetectionState.success &&
          context.mounted &&
          provider.predictionResult != null) {
        Navigator.push(
          context,
          SmoothPageRoute(
            page: ResultScreen(
              predictionResult: provider.predictionResult!,
              imageFile: provider.selectedImage!,
            ),
          ),
        );
      } else if (provider.state == DetectionState.error && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Analysis failed'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      loadingOverlay.remove();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Keep this method the same as it's more of a utility function
  OverlayEntry _showLoadingOverlay(BuildContext context) {
    // Original implementation kept intact
    final overlayState = Overlay.of(context);

    final entry = OverlayEntry(
      builder:
          (context) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Container(
                  color: Colors.black.withAlpha(80),
                  alignment: Alignment.center,
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Analyzing',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );

    overlayState.insert(entry);
    return entry;
  }
}
