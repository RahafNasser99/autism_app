// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/note_models/note.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'notes_list_state.dart';

class NotesListCubit extends Cubit<NotesListState> {
  NotesListCubit() : super(const NotesListInitial([])) {
    scrollController.addListener(() async {
      await getMoreNotes(status!).whenComplete(() => isLoadingMore = false);
    });
  }

  Repositories repositories = Repositories();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  int pageCount = 0;
  String? status;
  int page = 0;

  Future<void> getFirstPage(String status) async {
    try {
      page = 0;

      this.status = status;

      emit(const NotesListLoading([]));

      Response response;

      if (status == 'center') {
        response = await repositories.getData(
            '/note/center-notes/${ChildAccount().accountId}?page=$page&limit=10}',
            null);
      } else {
        response = await repositories.getData(
            '/note/family-notes/${ChildAccount().accountId}?page=$page&limit=10}',
            null);
      }

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 &&
          response.statusCode! < 400 &&
          response.data['data']['data'] != null) {
        var body = response.data;
        pageCount = body['data']['pageCount'];

        var extractedData = body['data']['data'] as List;
        if (extractedData.isEmpty) {
          emit(NotesListIsEmpty(notes: []));
        } else {
          final List<Note> extractedNotes = [];

          for (var note in extractedData) {
            extractedNotes.add(Note.fromJson(note));
          }

          emit(NotesListDone(notes: extractedNotes));
        }
      } else {
        emit(NotesListFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(const NotesListError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreNotes(String status) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response;

        if (status == 'center') {
          response = await repositories.getData(
              '/note/center-notes/${ChildAccount().accountId}?page=$page&limit=10}',
              null);
        } else {
          response = await repositories.getData(
              '/note/family-notes/${ChildAccount().accountId}?page=$page&limit=10}',
              null);
        }
        String message = response.data['message'] != null
            ? response.data['message'].toString()
            : response.data['messages']
                .toString()
                .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 &&
            response.statusCode! < 400 &&
            response.data['data']['data'] != null) {
          var body = response.data;

          var extractedData = body['data']['data'] as List;

          final List<Note> extractedNotes = [];

          for (var note in extractedData) {
            extractedNotes.add(Note.fromJson(note));
          }

          emit(NotesListDone(notes: [...state.notes, ...extractedNotes]));
        } else {
          emit(NotesListFailed([], failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(const NotesListError([],
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<NotesListState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
