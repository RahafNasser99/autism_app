// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/task_models/task.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'internal_task_state.dart';

class InternalTaskCubit extends Cubit<InternalTaskState> {
  InternalTaskCubit() : super(InternalTaskInitial([])) {
    scrollController.addListener(() async {
      await getMoreInternalTasks(place, status)
          .then((_) => isLoadingMore = false);
    });
  }

  Repositories repositories = Repositories();

  int page = 0;
  int pageCount = 0;
  String place = '';
  String status = 'false';
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  Future<void> getFirstPage(String place, String status) async {
    try {
      page = 0;
      this.status = status;
      this.place = place;
      emit(InternalTaskLoading([]));

      Response response = await repositories.getData(
          '/task-management/$place/internal-$place-log/${ChildAccount().accountId}?page=$page&limit=10&status=$status',
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

        if (extractedData.isNotEmpty) {
          final List<Task> extractedTasks = [];

          for (var internalTask in extractedData) {
            int exerciseId = (place == 'center-task')
                ? internalTask['centerTask']['task']['internalCenterTask']
                    ['exerciseId']
                : internalTask['homeTask']['task']['internalHomeTask']
                    ['exerciseId'];

            Response exerciseResponse = await repositories.getData(
                '/task-management/exercise/$exerciseId', null);

            if (exerciseResponse.statusCode! >= 200 &&
                exerciseResponse.statusCode! < 400) {
              String exerciseType =
                  exerciseResponse.data['data']['exerciseType'];

              if (place == 'home-task') {
                extractedTasks.add(Task.fromJson(
                    internalTask, exerciseId, exerciseType, 'homeTask'));
              } else {
                extractedTasks.add(Task.fromJson(
                    internalTask, exerciseId, exerciseType, 'centerTask'));
              }
            }
          }

          emit(InternalTaskDone(internalTasks: extractedTasks));
        } else {
          emit(InternalTaskEmpty(internalTasks: []));
        }
      } else {
        emit(InternalTaskFailed([], failedMessage: message));
      }
    } catch (error) {
      emit(InternalTaskError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreInternalTasks(String place, String status) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response = await repositories.getData(
            '/task-management/$place/internal-$place-log/${ChildAccount().accountId}?page=$page&limit=10&status=$status',
            null);

        String message = response.data['message'] != null
            ? response.data['message'].toString()
            : response.data['messages']
                .toString()
                .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          var body = response.data;

          var extractedData = body['data']['data'] as List;

          if (extractedData.isNotEmpty) {
            final List<Task> extractedTasks = [];

            for (var internalTask in extractedData) {
              int exerciseId = (place == 'center-task')
                  ? internalTask['centerTask']['task']['internalCenterTask']
                      ['exerciseId']
                  : internalTask['homeTask']['task']['internalHomeTask']
                      ['exerciseId'];

              Response exerciseResponse = await repositories.getData(
                  '/task-management/exercise/$exerciseId', null);

              if (exerciseResponse.statusCode! >= 200 &&
                  exerciseResponse.statusCode! < 400) {
                String exerciseType =
                    exerciseResponse.data['data']['exerciseType'];

                if (place == 'home-task') {
                  extractedTasks.add(Task.fromJson(
                      internalTask, exerciseId, exerciseType, 'homeTask'));
                } else {
                  extractedTasks.add(Task.fromJson(
                      internalTask, exerciseId, exerciseType, 'centerTask'));
                }
              }
            }

            for (var internalTask in extractedTasks) {
              print(internalTask.toString());
            }

            emit(InternalTaskDone(
                internalTasks: [...state.internalTasks, ...extractedTasks]));
          }
        } else {
          emit(InternalTaskFailed([], failedMessage: message));
        }
      } catch (error) {
        emit(InternalTaskError([],
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<InternalTaskState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
