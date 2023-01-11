import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:login/data/storage/secure_storage.dart';
import 'package:login/domain/services/auth_services.dart';
import 'package:login/ui/screens/login/login_page.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<OnLoginEvent>(_onLogin);
    on<OnCheckingLoginEvent>(_onCheckingLogin);
    on<OnLogOutEvent>(_onLogOut);
  }

  Future<void> _onLogin(
    OnLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print("_onLogin");
      emit(LoadingAuthentication());
      print("auth_bloc loadingAuthentication");
      print(event.user_id);
      print(event.user_pw);

      final data = await authServices.login(event.user_id, event.user_pw);
      print('_onLogin data.resp');
      print(data.resp);
      await Future.delayed(const Duration(milliseconds: 350));

      if (data.resp) {
        await secureStorage.deleteSecureStorage();

        await secureStorage.persistenToken(data.token!);

        emit(SuccessAuthentication());
      } else {
        print('_onLogin FailureAuthentication');
        print(data.resp);
        // emit(FailureAuthentication(data.message));
        emit(FailureAuthentication());
      }
    } catch (e) {
      // emit(FailureAuthentication(e.toString()));
      emit(FailureAuthentication());
    }
  }

  Future<void> _onCheckingLogin(
    OnCheckingLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print("_onCheckingLogin");
      await Future.delayed(const Duration(milliseconds: 850));

      if (await secureStorage.readToken() != null) {
        final data = await authServices.renewLogin();

        if (data.resp) {
          // await secureStorage.persistenToken(data.token!);

          emit(SuccessAuthentication());
        } else {
          await secureStorage.deleteSecureStorage();
          emit(LogOut());
        }
      } else {
        await secureStorage.deleteSecureStorage();
        emit(LogOut());
      }
    } catch (e) {
      await secureStorage.deleteSecureStorage();
      emit(LogOut());
    }
  }

  Future<void> _onLogOut(
    OnLogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    print("_onLogOut");
    await secureStorage.deleteSecureStorage();
    emit(LogOut());
  }
}
