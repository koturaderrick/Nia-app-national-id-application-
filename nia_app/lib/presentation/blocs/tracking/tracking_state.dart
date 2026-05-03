import 'package:equatable/equatable.dart';
import '../../../domain/entities/tracking_status.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();
  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingLoaded extends TrackingState {
  final TrackingStatus status;
  const TrackingLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

class TrackingError extends TrackingState {
  final String message;
  const TrackingError(this.message);

  @override
  List<Object?> get props => [message];
}
