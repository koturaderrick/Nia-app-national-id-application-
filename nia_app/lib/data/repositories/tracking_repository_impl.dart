import '../../domain/entities/tracking_status.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/remote/tracking_remote_datasource.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  const TrackingRepositoryImpl(this.remoteDataSource);

  @override
  Future<TrackingStatus> trackApplication(String trackingNumber) {
    return remoteDataSource.trackApplication(trackingNumber);
  }
}
