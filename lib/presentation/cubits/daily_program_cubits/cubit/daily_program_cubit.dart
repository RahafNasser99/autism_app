// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/daily_program_models/daily_program.dart';

part 'daily_program_state.dart';

class DailyProgramCubit extends Cubit<DailyProgramState> {
  DailyProgramCubit() : super(DailyProgramInitial());

  Repositories repositories = Repositories();

  Future<DailyProgram?> getChildDailyProgram() async {
    DailyProgram? dailyProgram;
    try {
      emit(DailyProgramLoading());

      Response response = await repositories.getData(
          '/daily-program/child-program/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 &&
          response.statusCode! < 400 &&
          response.data['data'] != null) {
        var body = response.data;

        emit(DailyProgramDone(
            dailyProgram: DailyProgram.fromJson(body['data'])));
        dailyProgram =
            DailyProgramDone(dailyProgram: DailyProgram.fromJson(body['data']))
                .dailyProgram;
      } else {
        if (response.data['data'] == null) {
          emit(DailyProgramNotFound());
        } else {
          emit(DailyProgramFailed(failedMessage: message));
        }
      }
    } catch (error) {
      print(error.toString());
      emit(DailyProgramError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
    return dailyProgram;
  }
}
