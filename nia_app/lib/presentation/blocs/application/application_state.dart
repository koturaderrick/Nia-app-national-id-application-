import 'package:equatable/equatable.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();
  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial();
}

class ApplicationLoading extends ApplicationState {
  const ApplicationLoading();
}

class ApplicationSubmitSuccess extends ApplicationState {
  final String trackingNumber;
  const ApplicationSubmitSuccess(this.trackingNumber);

  @override
  List<Object?> get props => [trackingNumber];
}

class ApplicationError extends ApplicationState {
  final String message;
  const ApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}
