// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'need_expression_handle_state.dart';

class NeedExpressionHandleCubit extends Cubit<NeedExpressionHandleState> {
  NeedExpressionHandleCubit() : super(NeedExpressionHandleInitial());

  Repositories repositories = Repositories();

  Future<void> markNeedExpressionAsDone(int needId) async {
    try {
      emit(NeedExpressionHandleLoading());

      Response response = await repositories
          .postDataWithToken('/needs/mark-child-need-done', {'id': needId});

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(NeedExpressionHandleDone());
      } else {
        emit(NeedExpressionHandleFailed(failedMessage: message));
      }
    } catch (error) {
      print(error);
      emit(const NeedExpressionHandleError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> markAllNeedExpressionAsDone() async {
    try {
      emit(NeedExpressionHandleLoading());

      Response response = await repositories.postDataWithToken(
          '/needs/mark-all-child-need-done/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(NeedExpressionHandleDone());
      } else {
        emit(NeedExpressionHandleFailed(failedMessage: message));
      }
    } catch (error) {
      print(error);
      emit(const NeedExpressionHandleError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> postNeedExpression(int needId) async {
    try {
      emit(NeedExpressionHandleLoading());

      Response response = await repositories.postDataWithToken(
          '/needs/need-to-child-need-log/$needId', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(NeedExpressionHandleDone());

        final AudioPlayer audioPlayer = AudioPlayer();
        final AudioCache player = AudioCache(prefix: 'assets/sounds/');
        final needNotification = await player.load('needs-notification.mp3');
        audioPlayer.setUrl(needNotification.path, isLocal: true);
        await audioPlayer.play(needNotification.path);
      } else {
        emit(NeedExpressionHandleFailed(failedMessage: message));
      }
    } catch (error) {
      print(error);
      emit(const NeedExpressionHandleError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  @override
  void onChange(Change<NeedExpressionHandleState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
