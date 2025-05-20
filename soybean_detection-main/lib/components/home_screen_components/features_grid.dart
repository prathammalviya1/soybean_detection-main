import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/home_screen_components/feature_card.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            'Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        // Use LayoutBuilder for responsive design
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - AppSpacing.md) / 2;
            final cardHeight =
                cardWidth * 0.85; // Adjusted height-to-width ratio

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const FeatureCard(
                    icon: Icons.access_time,
                    title: 'Fast Detection',
                    description: 'Quick analysis of soybean leaf diseases',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const FeatureCard(
                    icon: Icons.tips_and_updates,
                    title: 'Treatment Tips',
                    description:
                        'Get advice on how to treat identified diseases',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const FeatureCard(
                    icon: Icons.phonelink_off,
                    title: 'Works Offline',
                    description: 'No internet connection required',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const FeatureCard(
                    icon: Icons.analytics_outlined,
                    title: 'Accurate Results',
                    description: 'Powered by advanced ML technology',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
