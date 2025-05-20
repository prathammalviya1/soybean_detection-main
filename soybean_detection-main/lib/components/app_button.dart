import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

enum ButtonStyle { primary, secondary, text, success, error, warning }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final ButtonStyle style;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.style = ButtonStyle.primary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _getBackgroundColor();
    final Color foregroundColor = _getForegroundColor();

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withOpacitySafe(0.6),
          disabledForegroundColor: foregroundColor.withOpacitySafe(0.6),
          elevation: style == ButtonStyle.text ? 0 : null,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape:
              style == ButtonStyle.text
                  ? null
                  : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
          side:
              style == ButtonStyle.secondary
                  ? BorderSide(color: AppColors.primary, width: 1.5)
                  : null,
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor()),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      );
    }

    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  Color _getBackgroundColor() {
    switch (style) {
      case ButtonStyle.primary:
        return AppColors.primary;
      case ButtonStyle.secondary:
        return Colors.transparent;
      case ButtonStyle.text:
        return Colors.transparent;
      case ButtonStyle.success:
        return AppColors.success;
      case ButtonStyle.error:
        return AppColors.error;
      case ButtonStyle.warning:
        return AppColors.warning;
    }
  }

  Color _getForegroundColor() {
    switch (style) {
      case ButtonStyle.primary:
        return Colors.white;
      case ButtonStyle.secondary:
        return AppColors.primary;
      case ButtonStyle.text:
        return AppColors.primary;
      case ButtonStyle.success:
      case ButtonStyle.error:
      case ButtonStyle.warning:
        return Colors.white;
    }
  }
}
