import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/app_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soybean_detection/models/prediction_model.dart';
import 'package:path_provider/path_provider.dart';

class ActionButtons extends StatelessWidget {
  final PredictionResult predictionResult;
  final File imageFile;
  final VoidCallback onAnalyzeAnother;

  const ActionButtons({
    super.key,
    required this.predictionResult,
    required this.imageFile,
    required this.onAnalyzeAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: 'Analyze Another Image',
          icon: Icons.camera_alt_outlined,
          fullWidth: true,
          onTap: onAnalyzeAnother,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Share Results',
          icon: Icons.share_outlined,
          fullWidth: true,
          onTap: () {
            // Add a visual feedback before calling _shareResults
            ScaffoldMessenger.of(context).clearSnackBars();
            _showFeedback(context, 'Preparing to share...');
            Future.delayed(const Duration(milliseconds: 200), () {
              if (context.mounted) {
                _shareResults(context);
              }
            });
          },
        ),
      ],
    );
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // Fix BuildContext across async gap
  void _shareResults(BuildContext context) async {
    final contextRef = context;

    try {
      final confidence = (predictionResult.confidence * 100).toStringAsFixed(1);
      final text =
          'Soybean Disease Detection Results:\n'
          '- Condition: ${predictionResult.predictedClass}\n'
          '- Confidence: $confidence%\n\n'
          'Recommendations: ${predictionResult.precautions ?? 'None provided'}';

      // Get render box for position (required for iPad)
      final box = context.findRenderObject() as RenderBox?;

      // Create a temporary file to share
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/soybean_analysis.jpg';
      await imageFile.copy(tempPath);

      // Create XFile
      final xFile = XFile(tempPath);

      // Share using the latest API
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          files: [xFile],
          subject: 'Soybean Disease Detection Results',
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );

      if (!contextRef.mounted) return;
      // Continue with the sharing logic
    } catch (e) {
      // First try simple text sharing as fallback
      try {
        final confidence = (predictionResult.confidence * 100).toStringAsFixed(
          1,
        );
        final text =
            'Soybean Disease Detection Results:\n'
            '- Condition: ${predictionResult.predictedClass}\n'
            '- Confidence: $confidence%\n\n'
            'Recommendations: ${predictionResult.precautions ?? 'None provided'}';

        await SharePlus.instance.share(
          ShareParams(text: text, subject: 'Soybean Disease Detection Results'),
        );

        if (!contextRef.mounted) return;
        // Continue with the UI update
      } catch (fallbackError) {
        // Show error message with both attempts' errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $e\nFallback error: $fallbackError'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
