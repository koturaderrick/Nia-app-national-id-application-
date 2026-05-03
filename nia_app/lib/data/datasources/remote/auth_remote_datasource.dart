import '../../models/user_model.dart';
import 'mock_api_service.dart';

class AuthRemoteDataSource {
  final MockApiService apiService;
  const AuthRemoteDataSource(this.apiService);

  Future<UserModel> login(String email, String password) async {
    final data = await apiService.login(email, password);
    return UserModel.fromJson(data);
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final data = await apiService.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    return UserModel.fromJson(data);
  }
}