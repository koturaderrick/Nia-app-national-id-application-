import 'package:equatable/equatable.dart';
import '../../../domain/entities/application.dart';

abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();
  @override
  List<Object?> get props => [];
}

class ApplicationSubmitRequested extends ApplicationEvent {
  final Application application;
  const ApplicationSubmitRequested(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationReset extends ApplicationEvent {
  const ApplicationReset();
}
