import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await remoteDataSource.login(email, password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<User> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = await remoteDataSource.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() => localDataSource.clearSession();

  @override
  Future<bool> isLoggedIn() => localDataSource.isLoggedIn();

  @override
  Future<User?> getCachedUser() => localDataSource.getCachedUser();
}
