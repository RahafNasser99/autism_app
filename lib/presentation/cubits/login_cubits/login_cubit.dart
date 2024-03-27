// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Repositories repositories = Repositories();
  ChildAccount childAccount = ChildAccount();

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoading());

      Response response = await repositories.postDataWithoutToken(
          '/account/login', {'email': email.trim(), 'password': password});

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        
        childAccount.setIsAChild(true);
        childAccount.setAccessToken(body['data']['accessToken']);
        childAccount.setChildId(body['data']['account']['id']);
        childAccount.setAccountData(body['data']['account']);

        emit(LoginDone());

        await storeAuthToken();
      } else {
        emit(LoginFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(LoginError(errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> switchAccount(String password) async {
    try {
      emit(LoginLoading());

      Response response = await repositories.postDataWithToken(
          '/profile/switch-account', {'familyPassword': password});

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        childAccount.setIsAChild(false);

        emit(LoginDone());
      } else {
        emit(LoginFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(LoginError(errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> storeAuthToken() async {
    print('storeAuthToken');
    final storage = FlutterSecureStorage();
    await storage.write(key: 'authToken', value: childAccount.accessToken);
    await storage.write(
        key: 'childId', value: childAccount.accountId.toString());
  }

  @override
  void onChange(Change<LoginState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
