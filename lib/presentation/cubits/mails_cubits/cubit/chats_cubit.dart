// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/mail_models/mail.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial([])) {
    scrollController.addListener(() async {
      await getMoreMails(otherAccountId)
          .whenComplete(() => isLoadingMore = false);
    });
  }

  Repositories repositories = Repositories();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  int pageCount = 0;
  int page = 0;
  int otherAccountId = 0;

  Future<void> getFirstPage(int otherAccountId) async {
    try {
      page = 0;

      this.otherAccountId = otherAccountId;

      emit(ChatsLoading([]));

      Response response = await repositories.getData(
          '/communication-management/communication/$otherAccountId?page=$page&limit=10',
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

        final List<MailModel> extractedMails = [];

        for (var mail in extractedData) {
          extractedMails.add(MailModel.fromJson(mail));
        }

        emit(ChatsDone(mails: extractedMails));
      } else {
        emit(ChatsFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(ChatsError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreMails(int otherAccountId) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response = await repositories.getData(
            '/communication-management/communication/$otherAccountId?page=$page&limit=10',
            null);
        String message = response.data['messages']
            .toString()
            .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 &&
            response.statusCode! < 400 &&
            response.data['data']['data'] != null) {
          var body = response.data;

          var extractedData = body['data']['data'] as List;

          final List<MailModel> extractedMails = [];

          for (var mail in extractedData) {
            extractedMails.add(MailModel.fromJson(mail));
          }

          emit(ChatsDone(mails: [...state.mails, ...extractedMails]));
        } else {
          emit(ChatsFailed(state.mails, failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(ChatsError(state.mails,
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }
}
