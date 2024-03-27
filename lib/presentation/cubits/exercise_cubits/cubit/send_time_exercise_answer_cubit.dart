import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';

part 'send_time_exercise_answer_state.dart';

class SendTimeExerciseAnswerCubit extends Cubit<SendTimeExerciseAnswerState> {
  SendTimeExerciseAnswerCubit() : super(SendTimeExerciseAnswerInitial());

  Repositories repositories = Repositories();

  Future<void> postExerciseAnswer(
      exerciseId, bool status, int duration, int attempts) async {
    try {
      Response response = await repositories.postDataWithToken(
        '/time-management/time-learning/time-exercise-log',
        {
          "exerciseId": exerciseId,
          "status": status.toString(),
          "numOfTry": attempts,
          "time": duration
        },
      );

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 || response.statusCode! < 400) {
        emit(SendTimeExerciseAnswerDone());
      } else {
        emit(SendTimeExerciseAnswerFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
