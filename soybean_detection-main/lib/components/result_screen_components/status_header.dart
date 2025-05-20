import 'package:flutter/material.dart';
import 'package:soybean_detection/design_system/app_theme.dart';
import 'package:soybean_detection/components/status_badge.dart';

class StatusHeader extends StatelessWidget {
  final bool isHealthy;
  final bool isValid;

  const StatusHeader({
    super.key,
    required this.isHealthy,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'status_badge',
          child: Material(
            color: Colors.transparent,
            child: StatusBadge(
              type: _getStatusType(),
              text: _getStatusText(),
              icon: _getStatusIcon(),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Analyzed: ${DateTime.now().toString().substring(0, 16)}',
          style: TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
      ],
    );
  }

  StatusType _getStatusType() {
    if (!isValid) return StatusType.warning;
    if (isHealthy) return StatusType.healthy;
    return StatusType.disease;
  }

  String _getStatusText() {
    if (!isValid) return 'Low Confidence';
    if (isHealthy) return 'Healthy Plant';
    return 'Disease Detected';
  }

  IconData _getStatusIcon() {
    if (!isValid) return Icons.help_outline;
    if (isHealthy) return Icons.check_circle_outline;
    return Icons.warning_amber_rounded;
  }
}
