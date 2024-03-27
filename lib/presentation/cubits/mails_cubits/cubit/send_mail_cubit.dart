// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';

part 'send_mail_state.dart';

class SendMailCubit extends Cubit<SendMailState> {
  SendMailCubit() : super(SendMailInitial());

  Repositories repositories = Repositories();

  Future<void> sendMail(int receiverId, String subject, String content) async {
    try {
      emit(SendMailLoading());

      Response response = await repositories.postDataWithToken(
          '/communication-management/communication/message/$receiverId',
          {'subject': subject, 'content': content});

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(SendMailDone());
      } else {
        emit(SendMailFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(SendMailError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
