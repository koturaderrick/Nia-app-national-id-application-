import '../entities/tracking_status.dart';
import '../repositories/tracking_repository.dart';

class TrackApplicationUseCase {
  final TrackingRepository repository;
  const TrackApplicationUseCase(this.repository);

  Future<TrackingStatus> call(String trackingNumber) {
    return repository.trackApplication(trackingNumber);
  }
}
