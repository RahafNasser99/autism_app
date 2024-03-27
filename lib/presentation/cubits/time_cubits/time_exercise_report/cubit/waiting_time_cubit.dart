// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/waiting_time.dart';

part 'waiting_time_state.dart';

class WaitingTimeCubit extends Cubit<WaitingTimeState> {
  WaitingTimeCubit() : super(WaitingTimeInitial());

  Repositories repositories = Repositories();

  Future<void> getChildWaitingTime() async {
    try {
      emit(WaitingTimeLoading());

      Response response = await repositories.getData(
          '/time-management/time-learning/get-waiting-time-for-child/${ChildAccount().accountId}',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        if (body['data'] != null) {
          WaitingTime.waitingTime = body['data']['time'];
        }

        emit(WaitingTimeDone());
      } else {
        emit(WaitingTimeFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(const WaitingTimeError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
