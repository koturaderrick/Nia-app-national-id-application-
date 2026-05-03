import 'package:equatable/equatable.dart';

enum ApplicationStage {
  pending,
  verified,
  seniorApproval,
  finalApproval,
  rejected,
}

extension ApplicationStageExtension on ApplicationStage {
  String get label {
    switch (this) {
      case ApplicationStage.pending:
        return 'Pending';
      case ApplicationStage.verified:
        return 'Verified';
      case ApplicationStage.seniorApproval:
        return 'Senior Approval';
      case ApplicationStage.finalApproval:
        return 'Final Approval';
      case ApplicationStage.rejected:
        return 'Rejected';
    }
  }

  int get stepIndex {
    switch (this) {
      case ApplicationStage.pending:
        return 0;
      case ApplicationStage.verified:
        return 1;
      case ApplicationStage.seniorApproval:
        return 2;
      case ApplicationStage.finalApproval:
        return 3;
      case ApplicationStage.rejected:
        return -1;
    }
  }

  static ApplicationStage fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return ApplicationStage.pending;
      case 'verified':
        return ApplicationStage.verified;
      case 'senior approval':
        return ApplicationStage.seniorApproval;
      case 'final approval':
        return ApplicationStage.finalApproval;
      case 'rejected':
        return ApplicationStage.rejected;
      default:
        return ApplicationStage.pending;
    }
  }
}

class TrackingStatus extends Equatable {
  final String trackingNumber;
  final ApplicationStage stage;
  final String message;
  final String applicantName;
  final String submittedDate;
  final String? lastUpdated;

  const TrackingStatus({
    required this.trackingNumber,
    required this.stage,
    required this.message,
    required this.applicantName,
    required this.submittedDate,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [trackingNumber, stage];
}
