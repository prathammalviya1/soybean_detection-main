import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';

enum StatusType { healthy, disease, warning, info }

class StatusBadge extends StatelessWidget {
  final StatusType type;
  final String text;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.type,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor().withAlpha(
          30,
        ), // Using withAlpha instead of withOpacity
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Keep this as min
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: _getBadgeColor()),
            const SizedBox(width: 4),
          ],
          // Add Flexible to handle text overflow
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getBadgeColor(),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Add overflow handling
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor() {
    switch (type) {
      case StatusType.healthy:
        return AppColors.success;
      case StatusType.disease:
        return AppColors.error;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.info:
        return AppColors.info;
    }
  }
}
