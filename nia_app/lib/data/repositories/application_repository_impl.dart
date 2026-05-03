import '../../domain/entities/application.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/remote/application_remote_datasource.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;
  const ApplicationRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> submitApplication(Application application) {
    final model = ApplicationModel.fromEntity(application);
    return remoteDataSource.submitApplication(model);
  }
}
