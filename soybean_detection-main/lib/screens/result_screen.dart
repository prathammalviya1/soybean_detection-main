import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/models/prediction_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

// Import the components
import 'package:soybean_detection/components/result_screen_components/index.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult predictionResult;
  final File imageFile;

  const ResultScreen({
    super.key,
    required this.predictionResult,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthy =
        predictionResult.predictedClass.toLowerCase() == 'healthy';
    final isValid = predictionResult.isValidPrediction;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detection Results'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _shareResults(context),
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Results',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Using modular components
            ImageSection(imageFile: imageFile),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusHeader(isHealthy: isHealthy, isValid: isValid),
                  const SizedBox(height: AppSpacing.md),
                  DetectionCard(
                    predictionResult: predictionResult,
                    isHealthy: isHealthy,
                    isValid: isValid,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (predictionResult.precautions != null)
                    TreatmentCard(
                      predictionResult: predictionResult,
                      isHealthy: isHealthy,
                      isValid: isValid,
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  ActionButtons(
                    predictionResult: predictionResult,
                    imageFile: imageFile,
                    onAnalyzeAnother: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fix Share deprecation and BuildContext across async gap
  void _shareResults(BuildContext context) async {
    final contextRef = context;

    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/soybean_analysis.jpg';
      await imageFile.copy(tempPath);

      final xFile = XFile(tempPath);
      final confidence = (predictionResult.confidence * 100).toStringAsFixed(1);
      final text =
          'Soybean Disease Detection Results:\n'
          '- Condition: ${predictionResult.predictedClass}\n'
          '- Confidence: $confidence%\n\n'
          'Recommendations: ${predictionResult.precautions ?? 'None provided'}';

      // Get render box for position (required for iPad)
      if (!contextRef.mounted) return;
      final box = contextRef.findRenderObject() as RenderBox?;

      // Use SharePlus instead of Share
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          files: [xFile],
          subject: 'Soybean Disease Detection Results',
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );
    } catch (e) {
      // Simple fallback
      try {
        final confidence = (predictionResult.confidence * 100).toStringAsFixed(
          1,
        );
        final text =
            'Soybean Disease Detection Results:\n'
            '- Condition: ${predictionResult.predictedClass}\n'
            '- Confidence: $confidence%\n\n'
            'Recommendations: ${predictionResult.precautions ?? 'None provided'}';

        if (!context.mounted) return;
        // Use SharePlus instead of Share
        await SharePlus.instance.share(
          ShareParams(text: text, subject: 'Soybean Disease Detection Results'),
        );
      } catch (fallbackError) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sharing results'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
