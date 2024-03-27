// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise_log.dart';

part 'time_exercise_report_state.dart';

class TimeExerciseReportCubit extends Cubit<TimeExerciseReportState> {
  TimeExerciseReportCubit() : super(TimeExerciseReportInitial([])) {
    scrollController.addListener(() async {
      await getMoreTimeExerciseLog(status)
          .whenComplete(() => isLoadingMore = false);
    });
  }

  Repositories repositories = Repositories();
  ScrollController scrollController = ScrollController();
  int page = 0;
  int pageCount = 0;
  String status = 'true';
  bool isLoadingMore = false;

  Future<void> getFirstPage(String status) async {
    try {
      emit(TimeExerciseReportLoading([]));

      this.status = status;
      page = 0;

      Response response = await repositories.getData(
          '/time-management/time-learning/time-exercise-log/${ChildAccount().accountId}?page=$page&limit=10&status=$status',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        pageCount = body['data']['pageCount'];
        var extractedData = body['data']['data'] as List;
        List<TimeExerciseLog> extractedExercise = [];

        if (extractedData.isNotEmpty) {
          for (var exercise in extractedData) {
            extractedExercise.add(TimeExerciseLog.fromJson(exercise));
          }

          emit(TimeExerciseReportDone(timeExerciseLog: extractedExercise));
        } else {
          emit(TimeExerciseReportEmpty([]));
        }
      } else {
        emit(TimeExerciseReportFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(TimeExerciseReportError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreTimeExerciseLog(String status) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response = await repositories.getData(
            '/time-management/time-learning/time-exercise-log/${ChildAccount().accountId}?page=$page&limit=10&status=$status',
            null);

        String message = response.data['message'] != null
            ? response.data['message'].toString()
            : response.data['messages']
                .toString()
                .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          var body = response.data;
          var extractedData = body['data']['data'] as List;
          List<TimeExerciseLog> extractedExercise = [];

          if (extractedData.isNotEmpty) {
            for (var exercise in extractedData) {
              extractedExercise.add(TimeExerciseLog.fromJson(exercise));
            }

            emit(TimeExerciseReportDone(timeExerciseLog: [
              ...state.timeExerciseLog,
              ...extractedExercise
            ]));
          }
        } else {
          emit(TimeExerciseReportFailed(state.timeExerciseLog,
              failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(TimeExerciseReportError(state.timeExerciseLog,
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }
}
