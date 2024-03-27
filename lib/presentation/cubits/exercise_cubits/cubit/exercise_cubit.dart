// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(ExerciseInitial());

  Repositories repositories = Repositories();

  Future<void> getExercise(String exerciseType, String place) async {
    try {
      emit(ExerciseLoading());

      String taskSource;

      if (place == 'center-task') {
        taskSource = 'internalCenterTask';
      } else {
        taskSource = 'internalHomeTask';
      }

      Response exerciseResponse = await repositories.getData(
          '/task-management/$place/for-child?exerciseType=$exerciseType', null);

      String message = exerciseResponse.data['messages'].toString().substring(
          1, exerciseResponse.data['messages'].toString().length - 1);

      if (exerciseResponse.statusCode! >= 200 &&
          exerciseResponse.statusCode! < 400) {
        if (exerciseResponse.data['data'] != null) {
          var exerciseBody = exerciseResponse.data['data'];
          int exerciseId = exerciseBody['task'][taskSource]['exerciseId'];
          int taskId = exerciseBody['id'];

          Response detailsResponse = await repositories.getData(
              '/task-management/exercise/$exerciseId', null);

          if (detailsResponse.statusCode! >= 200 &&
              detailsResponse.statusCode! < 400) {
            var detailsBody = detailsResponse.data['data'];
            emit(ExerciseDone(
                exercise: Exercise.fromJson(detailsBody), taskId: taskId));
          } else {
            emit(ExerciseEmpty());
          }
        } else {
          emit(ExerciseEmpty());
        }
      } else {
        emit(ExerciseFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(ExerciseError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMatchingExercise(String place) async {
    try {
      emit(ExerciseLoading());

      String taskSource;

      if (place == 'center-task') {
        taskSource = 'internalCenterTask';
      } else {
        taskSource = 'internalHomeTask';
      }

      Response exerciseResponse = await repositories.getData(
          '/task-management/$place/for-child?exerciseType=matching', null);

      String message = exerciseResponse.data['message'] != null
          ? exerciseResponse.data['message'].toString()
          : exerciseResponse.data['messages'].toString().substring(
              1, exerciseResponse.data['messages'].toString().length - 1);

      if (exerciseResponse.statusCode! >= 200 &&
          exerciseResponse.statusCode! < 400) {
        if (exerciseResponse.data['data'] != null) {
          var exerciseBody = exerciseResponse.data['data'];
          int exerciseId = exerciseBody['task'][taskSource]['exerciseId'];
          int taskId = exerciseResponse.data['data']['id'];

          Response detailsResponse = await repositories.getData(
              '/task-management/exercise/$exerciseId', null);

          if (detailsResponse.statusCode! >= 200 &&
              detailsResponse.statusCode! < 400) {
            var detailsBody = detailsResponse.data['data'];

            int mainItem = detailsBody['exercise']['matching']['mainContentId'];
            int item1 = detailsBody['exercise']['matching']['content1Id'];
            int item2 = detailsBody['exercise']['matching']['content2Id'];
            int item3 = detailsBody['exercise']['matching']['content3Id'];

            Response mainItemResponse =
                await repositories.getData('/content/$mainItem', null);
            Response itemResponse1 =
                await repositories.getData('/content/$item1', null);
            Response itemResponse2 =
                await repositories.getData('/content/$item2', null);
            Response itemResponse3 =
                await repositories.getData('/content/$item3', null);

            if ((mainItemResponse.statusCode! >= 200 &&
                    mainItemResponse.statusCode! < 400) &&
                (itemResponse1.statusCode! >= 200 &&
                    itemResponse1.statusCode! < 400) &&
                (itemResponse2.statusCode! >= 200 &&
                    itemResponse2.statusCode! < 400) &&
                (itemResponse3.statusCode! >= 200 &&
                    itemResponse3.statusCode! < 400)) {
              var mainItem = mainItemResponse.data['data']['media']['url'];
              var item1 = itemResponse1.data['data']['media']['url'];
              var item2 = itemResponse2.data['data']['media']['url'];
              var item3 = itemResponse3.data['data']['media']['url'];

              Map<String, dynamic> newBody = {
                "id": exerciseId,
                "exercise": {
                  "statementComposition": null,
                  "numberCompare": null,
                  "numberOrder": null,
                  "matching": {
                    "id": detailsBody['exercise']['matching']['id'],
                    "mainItem": mainItem,
                    "item1": item1,
                    "item2": item2,
                    "item3": item3,
                    "answer": detailsBody['exercise']['matching']['answer'],
                  }
                },
                "exerciseType": "matching"
              };

              emit(ExerciseDone(
                  exercise: Exercise.fromJson(newBody), taskId: taskId));
            } else {
              emit(ExerciseFailed(failedMessage: message));
            }
          } else {
            emit(ExerciseEmpty());
          }
        } else {
          emit(ExerciseEmpty());
        }
      } else {
        emit(ExerciseFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(ExerciseError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> postExerciseAnswer(String place, int exerciseId, bool status,
      int duration, int attempts) async {
    try {
      String taskId;
      if (place == 'center-task') {
        taskId = "centerTaskId";
      } else {
        taskId = "homeTaskId";
      }
      Response response = await repositories.postDataWithToken(
        '/task-management/$place/internal-$place-log',
        {
          taskId: exerciseId,
          "numOfTry": attempts,
          "time": duration,
          "status": status.toString()
        },
      );

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 || response.statusCode! < 400) {
        emit(ExerciseAnswerDone());
      } else {
        emit(ExerciseAnswerFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void onChange(Change<ExerciseState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
