part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String token;

  const Authenticated({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthenticationUnauthenticated extends AuthenticationState {}
