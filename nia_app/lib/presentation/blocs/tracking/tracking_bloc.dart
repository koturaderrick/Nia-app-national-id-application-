import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/track_application_usecase.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackApplicationUseCase trackUseCase;

  TrackingBloc({required this.trackUseCase}) : super(const TrackingInitial()) {
    on<TrackingRequested>(_onTrackingRequested);
    on<TrackingReset>(_onReset);
  }

  Future<void> _onTrackingRequested(
    TrackingRequested event,
    Emitter<TrackingState> emit,
  ) async {
    emit(const TrackingLoading());
    try {
      final status = await trackUseCase(event.trackingNumber.trim().toUpperCase());
      emit(TrackingLoaded(status));
    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }

  void _onReset(TrackingReset event, Emitter<TrackingState> emit) {
    emit(const TrackingInitial());
  }
}
