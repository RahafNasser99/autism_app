// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordLoading());

  Repositories repositories = Repositories();

  Future<void> updatePassword(
      String oldPassword, String newPassword, bool childPassword) async {
    try {
      Response response;
      if (childPassword) {
        response = await repositories
            .putData('/account/update-password/${ChildAccount().accountId}', {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        });
      } else {
        response = await repositories.putData(
            '/account/child/family-password/${ChildAccount().accountId}', {
          'oldFamilyPassword': oldPassword,
          'newFamilyPassword': newPassword,
        });
      }
      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        print(body);

        emit(UpdatePasswordDone(doneMessage: message));
      } else {
        emit(UpdatePasswordFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(UpdatePasswordError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  @override
  void onChange(Change<UpdatePasswordState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
