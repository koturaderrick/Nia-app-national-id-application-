import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_application_usecase.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final SubmitApplicationUseCase submitUseCase;

  ApplicationBloc({required this.submitUseCase})
      : super(const ApplicationInitial()) {
    on<ApplicationSubmitRequested>(_onSubmitRequested);
    on<ApplicationReset>(_onReset);
  }

  Future<void> _onSubmitRequested(
    ApplicationSubmitRequested event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    try {
      final trackingNumber = await submitUseCase(event.application);
      emit(ApplicationSubmitSuccess(trackingNumber));
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  void _onReset(ApplicationReset event, Emitter<ApplicationState> emit) {
    emit(const ApplicationInitial());
  }
}
