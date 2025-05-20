import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double elevation;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.elevation = 0,
    this.borderRadius,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBoxShadow =
        boxShadow ?? (elevation > 0 ? AppShadows.md : null);

    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.lg);

    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveBoxShadow,
        border: border,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
