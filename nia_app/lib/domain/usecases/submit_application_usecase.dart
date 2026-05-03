import '../entities/application.dart';
import '../repositories/application_repository.dart';

class SubmitApplicationUseCase {
  final ApplicationRepository repository;
  const SubmitApplicationUseCase(this.repository);

  Future<String> call(Application application) {
    return repository.submitApplication(application);
  }
}
