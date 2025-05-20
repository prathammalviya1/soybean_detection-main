import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';

class ImageSection extends StatelessWidget {
  final File imageFile;

  const ImageSection({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'selected_image',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover,
          gaplessPlayback: true, // Add this for smoother transitions
        );
      },
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(
              imageFile,
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
          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withAlpha(204),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
