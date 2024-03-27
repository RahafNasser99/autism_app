// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise_details.dart';

part 'time_exercise_details_state.dart';

class TimeExerciseDetailsCubit extends Cubit<TimeExerciseDetailsState> {
  TimeExerciseDetailsCubit() : super(TimeExerciseDetailsInitial([]));

  Repositories repositories = Repositories();

  Future<void> getExerciseDetails(int exerciseId) async {
    try {
      emit(TimeExerciseDetailsLoading([]));
      Response response = await repositories.getData(
          '/time-management/time-learning/details-time-exercise-log/${ChildAccount().accountId}/$exerciseId',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        var extractedData = body['data'] as List;
        List<TimeExerciseDetails> extractedDetails = [];

        for (var exercise in extractedData) {
          extractedDetails.add(TimeExerciseDetails.fromJson(exercise));
        }

        emit(TimeExerciseDetailsDone(timeExerciseDetails: extractedDetails));
      } else {
        emit(TimeExerciseDetailsFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(TimeExerciseDetailsError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  @override
  void onChange(Change<TimeExerciseDetailsState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
