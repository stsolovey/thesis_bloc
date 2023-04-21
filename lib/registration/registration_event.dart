// registration_event.dart
part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class Register extends RegistrationEvent {
  final String username;
  final String password;
  final String email;

  const Register({
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [username, password, email];
}

class RegistrationAuthenticated extends RegistrationEvent {
  final String token;

  const RegistrationAuthenticated({required this.token});

  @override
  List<Object> get props => [token];
}
