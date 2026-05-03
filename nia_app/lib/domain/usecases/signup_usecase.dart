import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupParams {
  final String name;
  final String email;
  final String phone;
  final String password;
  const SignupParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class SignupUseCase {
  final AuthRepository repository;
  const SignupUseCase(this.repository);

  Future<User> call(SignupParams params) {
    return repository.signup(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}
