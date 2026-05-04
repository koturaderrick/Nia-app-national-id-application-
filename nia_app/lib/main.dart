import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/application/application_form_screen.dart';
import 'presentation/screens/application/submission_success_screen.dart';
import 'presentation/screens/tracking/tracking_screen.dart';


import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/application/application_bloc.dart';
import 'presentation/blocs/tracking/tracking_bloc.dart';


import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'domain/usecases/submit_application_usecase.dart';
import 'domain/usecases/track_application_usecase.dart';


import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/application_repository_impl.dart';
import 'data/repositories/tracking_repository_impl.dart';


import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/application_remote_datasource.dart';
import 'data/datasources/remote/tracking_remote_datasource.dart';
import 'data/datasources/remote/mock_api_service.dart';

import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final localDataSource = AuthLocalDataSource(prefs);
  final mockApiService  = MockApiService(localDataSource);

  final authRemoteDataSource        = AuthRemoteDataSource(mockApiService);
  final applicationRemoteDataSource = ApplicationRemoteDataSource(mockApiService);
  final trackingRemoteDataSource    = TrackingRemoteDataSource(mockApiService);

  final authRepository        = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: localDataSource,
  );
  final applicationRepository = ApplicationRepositoryImpl(applicationRemoteDataSource);
  final trackingRepository    = TrackingRepositoryImpl(trackingRemoteDataSource);

  final loginUseCase             = LoginUseCase(authRepository);
  final signupUseCase            = SignupUseCase(authRepository);
  final submitApplicationUseCase = SubmitApplicationUseCase(applicationRepository);
  final trackApplicationUseCase  = TrackApplicationUseCase(trackingRepository);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
    authRepository: authRepository,
    submitApplicationUseCase: submitApplicationUseCase,
    trackApplicationUseCase: trackApplicationUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final AuthRepositoryImpl authRepository;
  final SubmitApplicationUseCase submitApplicationUseCase;
  final TrackApplicationUseCase trackApplicationUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.signupUseCase,
    required this.authRepository,
    required this.submitApplicationUseCase,
    required this.trackApplicationUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (_) => ApplicationBloc(submitUseCase: submitApplicationUseCase),
        ),
        BlocProvider(
          create: (_) => TrackingBloc(trackUseCase: trackApplicationUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        initialRoute: '/splash',
        routes: {
          '/splash':   (_) => const SplashScreen(),
          '/login':    (_) => const LoginScreen(),
          '/signup':   (_) => const SignupScreen(),
          '/home':     (_) => const HomeScreen(),
          '/apply':    (_) => const ApplicationFormScreen(),
          '/success':  (_) => const SubmissionSuccessScreen(), 
          '/tracking': (_) => const TrackingScreen(),          
        },
      ),
    );
  }
}