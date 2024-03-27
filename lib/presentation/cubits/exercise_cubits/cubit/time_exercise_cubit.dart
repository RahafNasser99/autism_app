// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise.dart';

part 'time_exercise_state.dart';

class TimeExerciseCubit extends Cubit<TimeExerciseState> {
  TimeExerciseCubit() : super(TimeExerciseInitial([])) {
    scrollController.addListener(() async {
      await getMoreTimeExercise().whenComplete(() => isLoadingMore = false);
    });
  }

  ScrollController scrollController = ScrollController();
  Repositories repositories = Repositories();
  int page = 0;
  bool isLoadingMore = false;
  int pageCount = 0;

  Future<void> getFirstPage() async {
    try {
      page = 0;
      emit(TimeExerciseLoading([]));

      Response response = await repositories.getData(
          '/time-management/time-learning/child-time-exercises/${ChildAccount().accountId}?page=$page&limit=10',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        var extractedData = body['data']['data'] as List;
        pageCount = body['data']['pageCount'];

        if (extractedData.isNotEmpty) {
          List<TimeExercise> extractedExercise = [];

          for (var exercise in extractedData) {
            extractedExercise.add(TimeExercise.fromJson(exercise));
          }

          emit(TimeExerciseDone(exercises: extractedExercise));
        } else {
          emit(TimeExerciseEmpty([]));
        }
      } else {
        emit(TimeExerciseFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(TimeExerciseError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreTimeExercise() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;
      try {
        Response response = await repositories.getData(
            '/time-management/time-learning/child-time-exercises/${ChildAccount().accountId}?page=$page&limit=10',
            null);

        String message = response.data['message'] != null
            ? response.data['message'].toString()
            : response.data['messages']
                .toString()
                .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          var body = response.data;
          var extractedData = body['data']['data'] as List;

          List<TimeExercise> extractedExercise = [];

          for (var exercise in extractedData) {
            extractedExercise.add(TimeExercise.fromJson(exercise));
          }
          emit(TimeExerciseDone(
              exercises: [...state.exercises, ...extractedExercise]));
        } else {
          emit(TimeExerciseFailed([], failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(TimeExerciseError(state.exercises,
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<TimeExerciseState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
