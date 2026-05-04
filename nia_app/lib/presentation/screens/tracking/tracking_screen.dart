import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/tracking_status.dart';
import '../../blocs/tracking/tracking_bloc.dart';
import '../../blocs/tracking/tracking_event.dart';
import '../../blocs/tracking/tracking_state.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_stepper.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trackingController = TextEditingController();
  bool _didInit = false; 

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final prefilled =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (prefilled != null) {
        _trackingController.text = prefilled;
        
        WidgetsBinding.instance.addPostFrameCallback((_) => _track());
      }
    }
  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  void _track() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TrackingBloc>().add(
            TrackingRequested(_trackingController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Tracking Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Format: NID-YYYY-XXXXX',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: _trackingController,
                        label: 'Tracking Number',
                        hint: 'e.g., NID-2025-12345',
                        prefixIcon: Icons.confirmation_number_outlined,
                        validator: Validators.validateTrackingNumber,
                        onChanged: (_) {
                          if (context.read<TrackingBloc>().state
                              is! TrackingInitial) {
                            context
                                .read<TrackingBloc>()
                                .add(const TrackingReset());
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Check Status',
                        onPressed: _track,
                        icon: Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<TrackingBloc, TrackingState>(
              builder: (context, state) {
                if (state is TrackingLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }
                if (state is TrackingError) {
                  return _buildErrorCard(state.message);
                }
                if (state is TrackingLoaded) {
                  return _buildResultCard(state.status);
                }
                return _buildEmptyState();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(TrackingStatus status) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.applicantName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            status.trackingNumber,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(status.stage),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _buildInfoTile(
                      Icons.calendar_today_outlined,
                      'Submitted',
                      status.submittedDate,
                    ),
                    if (status.lastUpdated != null) ...[
                      const SizedBox(width: 16),
                      _buildInfoTile(
                        Icons.update,
                        'Last Updated',
                        status.lastUpdated!,
                      ),
                    ],
                  ],
                ),
                if (status.message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppTheme.primaryColor, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            status.message,
                            style: const TextStyle(
                                color: AppTheme.textPrimary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Progress',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                StatusStepper(currentStage: status.stage),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Back to Home',
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          isOutlined: true,
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatusChip(ApplicationStage stage) {
    Color color;
    switch (stage) {
      case ApplicationStage.rejected:
        color = AppTheme.errorColor;
        break;
      case ApplicationStage.finalApproval:
        color = AppTheme.successColor;
        break;
      default:
        color = AppTheme.primaryColor;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        stage.label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.search_off, color: AppTheme.errorColor, size: 48),
            const SizedBox(height: 12),
            const Text('Not Found',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            Text(message,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.track_changes_outlined,
                size: 64, color: AppTheme.primaryColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'Enter your tracking number above to check the status of your application.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}