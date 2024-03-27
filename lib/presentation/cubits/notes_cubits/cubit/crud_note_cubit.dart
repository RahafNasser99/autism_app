// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'crud_note_state.dart';

class CrudNoteCubit extends Cubit<CrudNoteState> {
  CrudNoteCubit() : super(CrudNoteInitial());

  Repositories repositories = Repositories();

  Future<void> addNote(String note) async {
    try {
      emit(CrudNoteLoading());

      Response response =
          await repositories.postDataWithToken('/note/family-note', {
        'note': note,
        'childAccountId': ChildAccount().accountId,
      });

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(CrudNoteDone());
      } else {
        emit(CrudNoteFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(CrudNoteError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      emit(CrudNoteLoading());

      Response response =
          await repositories.deleteData('/note/family-note/$noteId', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        emit(CrudNoteDone());
      } else {
        emit(CrudNoteFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(CrudNoteError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
