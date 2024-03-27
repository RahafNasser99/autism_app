// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Repositories repositories = Repositories();

  Future<void> editProfile(String? phoneNumber, String? profilePicturePath,
      String? profilePictureName, bool editImage) async {
    try {
      print(editImage);

      emit(EditProfileLoading());

      MultipartFile? multipartFile = (profilePicturePath != null)
          ? await MultipartFile.fromFile(profilePicturePath,
              filename: profilePictureName)
          : null;

      FormData formData = editImage
          ? FormData.fromMap(
              {'phoneNumber': phoneNumber, 'image': multipartFile})
          : FormData.fromMap({'phoneNumber': phoneNumber});

      Response response = await repositories.putData(
          '/profile/${ChildAccount().accountId}', formData);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(EditProfileDone());
      } else {
        emit(EditProfileFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(EditProfileError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  @override
  void onChange(Change<EditProfileState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
