// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/task_models/internal_task_details.dart';

part 'internal_task_details_state.dart';

class InternalTaskDetailsCubit extends Cubit<InternalTaskDetailsState> {
  InternalTaskDetailsCubit() : super(InternalTaskDetailsInitial());

  Repositories repositories = Repositories();
  late InternalTaskDetails internalTaskDetails;

  Future<void> getInternalExerciseDetails(
      String place, int taskId, int exerciseId) async {
    print(taskId);
    try {
      emit(InternalTaskDetailsLoading());

      Response response = await repositories.getData(
          '/task-management/$place/details-internal-$place-log/${ChildAccount().accountId}/$taskId',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        Response detailsResponse = await repositories.getData(
            '/task-management/exercise/$exerciseId', null);

        if (detailsResponse.statusCode! >= 200 &&
            detailsResponse.statusCode! < 400) {
          var detailsBody = detailsResponse.data['data'];

          List extractedDate = body['data'] as List;

          List<InternalTaskDetails> extractedDetails = [];

          for (var details in extractedDate) {
            extractedDetails.add(InternalTaskDetails.fromJson(details));
          }

          emit(InternalTaskDetailsDone(
            internalTaskDetails: extractedDetails,
            exercise: Exercise.fromJson(detailsBody),
          ));
        } else {
          emit(InternalTaskDetailsFailed(failedMessage: message));
        }
      }
    } catch (error) {
      print(error.toString());
      emit(InternalTaskDetailsError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getInternalMatchingExerciseDetails(
      String place, int taskId, int exerciseId) async {
    print(taskId);
    try {
      emit(InternalTaskDetailsLoading());

      Response response = await repositories.getData(
          '/task-management/$place/details-internal-$place-log/${ChildAccount().accountId}/$taskId',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        Response detailsResponse = await repositories.getData(
            '/task-management/exercise/$exerciseId', null);

        if (detailsResponse.statusCode! >= 200 &&
            detailsResponse.statusCode! < 400) {
          var detailsBody = detailsResponse.data['data'];

          List extractedDate = body['data'] as List;

          List<InternalTaskDetails> extractedDetails = [];

          for (var details in extractedDate) {
            extractedDetails.add(InternalTaskDetails.fromJson(details));
          }

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

            emit(InternalTaskDetailsDone(
              internalTaskDetails: extractedDetails,
              exercise: Exercise.fromJson(newBody),
            ));
          }
        }
      } else {
        emit(InternalTaskDetailsFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(InternalTaskDetailsError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
