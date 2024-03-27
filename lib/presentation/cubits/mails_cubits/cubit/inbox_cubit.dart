// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/mail_models/mails.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';

part 'inbox_state.dart';

class InboxCubit extends Cubit<InboxState> {
  InboxCubit() : super(InboxInitial([])) {
    scrollController.addListener(() async {
      await getMoreInbox().whenComplete(
        () => isLoadingMore = false,
      );
    });
  }

  Repositories repositories = Repositories();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  int pageCount = 0;
  int page = 0;

  Future<void> getFirstPage() async {
    try {
      page = 0;

      emit(InboxLoading([]));

      Response response = await repositories.getData(
          '/communication-management/communication/chats?page=$page&limit=10',
          null);

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
          emit(InboxEmpty());
        } else {
          final List<MailsModel> extractedInbox = [];

          for (var mail in extractedData) {
            extractedInbox.add(MailsModel.fromJson(mail));
          }

          emit(InboxDone(mails: extractedInbox));
        }
      } else {
        emit(InboxFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(InboxError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreInbox() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response = await repositories.getData(
            '/communication-management/communication/chats?page=$page&limit=10',
            null);

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

          if (extractedData.isNotEmpty) {
            final List<MailsModel> extractedInbox = [];

            for (var mail in extractedData) {
              extractedInbox.add(MailsModel.fromJson(mail));
            }

            emit(InboxDone(mails: [...state.mails, ...extractedInbox]));
          }
        } else {
          emit(InboxFailed(state.mails, failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(InboxError(state.mails,
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<InboxState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
