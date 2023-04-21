// registration/registration_state.dart
part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String token;

  const RegistrationSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

class RegistrationFailure extends RegistrationState {
  final String error;

  const RegistrationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
