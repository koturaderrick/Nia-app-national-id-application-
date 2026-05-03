import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<User> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}
