import '../../models/tracking_model.dart';
import '../../../core/errors/failures.dart';
import 'mock_api_service.dart';

class TrackingRemoteDataSource {
  final MockApiService apiService;
  const TrackingRemoteDataSource(this.apiService);

  Future<TrackingModel> trackApplication(String trackingNumber) async {
    try {
      final data = await apiService.trackApplication(trackingNumber);
      return TrackingModel.fromJson(data);
    } on NotFoundFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}