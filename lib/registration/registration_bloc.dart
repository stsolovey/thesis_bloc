// registration_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/auth_api_service.dart';
import '../authentication/authentication_bloc.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthApiService authApiService;
  final AuthenticationBloc authenticationBloc;
  late StreamSubscription<AuthenticationState> _authenticationSubscription;

  RegistrationBloc({
    required this.authApiService,
    required this.authenticationBloc,
  }) : super(RegistrationInitial()) {
    on<Register>((event, emit) async {
      emit(RegistrationLoading());

      try {
        final user = await authApiService.register(
          event.username,
          event.password,
          event.email,
        );
        authenticationBloc.add(LoggedIn(token: user.token!));
      } catch (error) {
        emit(RegistrationFailure(error: error.toString()));
      }
    });

    on<RegistrationAuthenticated>((event, emit) {
      emit(RegistrationSuccess(token: event.token));
    });

    _authenticationSubscription = authenticationBloc.stream.listen((state) {
      if (state is Authenticated) {
        add(RegistrationAuthenticated(token: state.token));
      }
    });
  }

  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    return super.close();
  }
}
