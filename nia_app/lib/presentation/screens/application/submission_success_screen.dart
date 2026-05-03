import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/custom_button.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  const SubmissionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tracking number passed from ApplicationFormScreen via Navigator arguments
    final trackingNumber =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'NID-UNKNOWN';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Success icon ──────────────────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppTheme.successColor,
                  size: 60,
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your National ID application has been received. Use your tracking number below to monitor progress.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // ── Tracking number card ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Tracking Number',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trackingNumber,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save this number to track your application',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Track now button ──────────────────────────────────────────
              CustomButton(
                text: 'Track My Application',
                icon: Icons.track_changes_outlined,
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/tracking',
                  arguments: trackingNumber,
                ),
              ),
              const SizedBox(height: 12),

              // ── Back to home ──────────────────────────────────────────────
              CustomButton(
                text: 'Back to Home',
                icon: Icons.home_outlined,
                isOutlined: true,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}