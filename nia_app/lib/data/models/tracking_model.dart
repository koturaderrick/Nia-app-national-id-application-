import '../../domain/entities/tracking_status.dart';

class TrackingModel extends TrackingStatus {
  const TrackingModel({
    required super.trackingNumber,
    required super.stage,
    required super.message,
    required super.applicantName,
    required super.submittedDate,
    super.lastUpdated,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) => TrackingModel(
        trackingNumber: json['tracking_number'] as String,
        stage: ApplicationStageExtension.fromString(json['stage'] as String),
        message: json['message'] as String,
        applicantName: json['applicant_name'] as String,
        submittedDate: json['submitted_date'] as String,
        lastUpdated: json['last_updated'] as String?,
      );
}
