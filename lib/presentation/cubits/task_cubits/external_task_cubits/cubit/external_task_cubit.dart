// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/models/task_models/task.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'external_task_state.dart';

class ExternalTaskCubit extends Cubit<ExternalTaskState> {
  ExternalTaskCubit() : super(ExternalTaskInitial());

  Repositories repositories = Repositories();

  Future<void> getTasks(String place, DateTime date) async {
    try {
      String stringDate =
          date.toString().substring(0, date.toString().indexOf(' '));
      emit(ExternalTaskLoading());

      print(
          '/task-management/$place/external-$place-log/${ChildAccount().accountId}?date=$stringDate');
      Response response = await repositories.getData(
          '/task-management/$place/external-$place-log/${ChildAccount().accountId}?date=$stringDate',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var extractedData = response.data['data'] as List;

        if (extractedData.isNotEmpty) {
          List<Task> extractedTasks = [];
          for (var task in extractedData) {
            if (place == 'home-task') {
              extractedTasks.add(Task.fromJson(task, 0, '', 'homeTask'));
            } else {
              extractedTasks.add(Task.fromJson(task, 0, '', 'centerTask'));
            }
          }

          emit(ExternalTaskDone(extractedTasks));
        } else {
          emit(ExternalTaskEmpty());
        }
      } else {
        emit(ExternalTaskFailed(failedMessage: message));
      }
    } catch (error) {
      emit(ExternalTaskError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> addNoteAndPerformance(
      int homeTaskId, String note, String performance) async {
    try {
      Response response = await repositories.postDataWithToken(
          '/task-management/home-task/external-home-task-log', {
        'homeTaskId': homeTaskId,
        'childPerformance': performance,
        'note': note.isNotEmpty ? note : null,
      });

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(ExternalTaskEvaluationDone());
      } else {
        emit(ExternalTaskEvaluationFailed(failedMessage: message));
      }
    } catch (error) {
      emit(ExternalTaskEvaluationError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  @override
  void onChange(Change<ExternalTaskState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
