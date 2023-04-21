//authentication_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/auth_api_service.dart';
import '../storage.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final StorageService storageService;

  AuthenticationBloc({
    required this.storageService,
    required AuthApiService authApiService,
  }) : super(AuthenticationInitial()) {
    on<AppStarted>((event, emit) async {
      final String? token = await StorageService.getToken();
      if (token != null) {
        emit(Authenticated(token: token));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await StorageService.saveToken(event.token);
      emit(Authenticated(token: event.token));
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await StorageService.deleteToken();
      emit(AuthenticationUnauthenticated());
    });
  }
}
