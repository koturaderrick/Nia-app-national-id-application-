import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/tracking_status.dart';

class StatusStepper extends StatelessWidget {
  final ApplicationStage currentStage;

  const StatusStepper({super.key, required this.currentStage});

  static const _stages = [
    ApplicationStage.pending,
    ApplicationStage.verified,
    ApplicationStage.seniorApproval,
    ApplicationStage.finalApproval,
  ];

  @override
  Widget build(BuildContext context) {
    if (currentStage == ApplicationStage.rejected) {
      return _buildRejectedBanner();
    }

    final currentIndex = currentStage.stepIndex;

    return Column(
      children: List.generate(_stages.length, (index) {
        final stage = _stages[index];
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;
        final isPending = index > currentIndex;

        return _buildStep(
          stage: stage,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isPending: isPending,
          isLast: index == _stages.length - 1,
        );
      }),
    );
  }

  Widget _buildStep({
    required ApplicationStage stage,
    required bool isCompleted,
    required bool isCurrent,
    required bool isPending,
    required bool isLast,
  }) {
    Color circleColor;
    Color lineColor;
    Color textColor;

    if (isCompleted) {
      circleColor = AppTheme.successColor;
      lineColor = AppTheme.successColor;
      textColor = AppTheme.successColor;
    } else if (isCurrent) {
      circleColor = AppTheme.primaryColor;
      lineColor = AppTheme.dividerColor;
      textColor = AppTheme.primaryColor;
    } else {
      circleColor = AppTheme.dividerColor;
      lineColor = AppTheme.dividerColor;
      textColor = AppTheme.textSecondary;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor.withOpacity(isCurrent ? 0.15 : 1.0),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: circleColor, width: 2)
                      : null,
                ),
                child: Icon(
                  isCompleted ? Icons.check : (isCurrent ? Icons.timelapse : Icons.circle),
                  color: isCurrent ? circleColor : Colors.white,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: lineColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 24,
                top: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.label,
                    style: TextStyle(
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: textColor,
                      fontSize: 15,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Current Stage',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.errorColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Rejected',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.errorColor,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Please visit the nearest NID office for assistance.',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
