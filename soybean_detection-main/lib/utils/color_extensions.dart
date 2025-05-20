import 'package:flutter/material.dart';

/// Extension to help migrate from withOpacity to withAlpha
extension ColorExtension on Color {
  /// Safely converts opacity to alpha and creates a new color
  /// This avoids the deprecated withOpacity method
  Color withOpacitySafe(double opacity) {
    // Ensure opacity is in valid range
    opacity = opacity.clamp(0.0, 1.0);

    // Convert from 0.0-1.0 range to 0-255
    final alpha = (opacity * 255).round();

    // Use withAlpha instead of withOpacity
    return withAlpha(alpha);
  }
}
