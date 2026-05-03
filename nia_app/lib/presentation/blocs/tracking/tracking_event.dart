import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();
  @override
  List<Object?> get props => [];
}

class TrackingRequested extends TrackingEvent {
  final String trackingNumber;
  const TrackingRequested(this.trackingNumber);

  @override
  List<Object?> get props => [trackingNumber];
}

class TrackingReset extends TrackingEvent {
  const TrackingReset();
}
