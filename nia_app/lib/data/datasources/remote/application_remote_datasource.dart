import '../../models/application_model.dart';
import '../../../core/errors/failures.dart';
import 'mock_api_service.dart';

class ApplicationRemoteDataSource {
  final MockApiService apiService;
  const ApplicationRemoteDataSource(this.apiService);

  Future<String> submitApplication(ApplicationModel application) async {
    try {
      final data = await apiService.submitApplication(application.toJson());
      return data['tracking_number'] as String;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}