// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/profile_models/child_profile.dart';

part 'get_child_profile_state.dart';

class GetChildProfileCubit extends Cubit<GetChildProfileState> {
  GetChildProfileCubit() : super(GetChildProfileLoading());

  Repositories repositories = Repositories();
  ChildAccount childAccount = ChildAccount();
  late ChildProfile childProfile;

  Future<ChildProfile> getProfileInformation() async {
    try {
      emit(GetChildProfileLoading());

      Response response = await repositories.getData('/account/me', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        childAccount.setAccountData(body['data']);
        childProfile = ChildProfile.fromJson(body['data']);
        childAccount.setChildProfile(childProfile);

        emit(GetChildProfileDone());
      } else {
        emit(GetChildProfileFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(GetChildProfileError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
    return childProfile;
  }
}
