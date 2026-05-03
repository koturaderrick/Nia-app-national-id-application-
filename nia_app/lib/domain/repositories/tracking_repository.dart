import '../entities/tracking_status.dart';

abstract class TrackingRepository {
  Future<TrackingStatus> trackApplication(String trackingNumber);
}
