import '../entities/application.dart';

abstract class ApplicationRepository {
  Future<String> submitApplication(Application application);
}
