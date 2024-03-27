// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need_expression.dart';

part 'need_expression_report_state.dart';

class NeedExpressionReportCubit extends Cubit<NeedExpressionReportState> {
  NeedExpressionReportCubit() : super(NeedExpressionReportInitial([])) {
    scrollController.addListener(() async {
      await getMoreNeedExpressionReport(status!)
          .then((_) => isLoadingMore = false);
    });
  }

  Repositories repositories = Repositories();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  String? status;
  late int pageCount;
  int falsePage = 0;
  int truePage = 0;

  Future<void> getNeedExpressionReport(String status) async {
    try {
      falsePage = 0;
      truePage = 0;

      this.status = status;

      emit(NeedExpressionReportLoading([]));

      Response response;
      if (status == 'false') {
        response = await repositories.getData(
            '/needs/child-need-log/${ChildAccount().accountId}?page=$falsePage&limit=10&status=$status',
            null);
      } else {
        response = await repositories.getData(
            '/needs/child-need-log/${ChildAccount().accountId}?page=$truePage&limit=10&status=$status',
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
        final extractedData = body['data']['data'] as List;
        pageCount = body['data']['pageCount'];

        if (extractedData.isEmpty) {
          emit(NeedExpressionReportIsEmpty(needsExpression: []));
        } else {
          final List<NeedExpression> newNeedExpression = [];
          for (var needExpression in extractedData) {
            newNeedExpression.add(NeedExpression.fromJson(needExpression));
          }

          emit(NeedExpressionReportDone(needsExpression: newNeedExpression));
        }
      } else {
        emit(NeedExpressionReportFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error);
      emit(const NeedExpressionReportError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMoreNeedExpressionReport(String status) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        ((status == 'false' && falsePage < pageCount) ||
            (status == 'true' && truePage < pageCount))) {
      isLoadingMore = true;

      try {
        Response response;
        if (status == 'false') {
          falsePage++;
          response = await repositories.getData(
              '/needs/child-need-log/${ChildAccount().accountId}?page=$falsePage&limit=10&status=$status',
              null);
        } else {
          truePage++;
          response = await repositories.getData(
              '/needs/child-need-log/${ChildAccount().accountId}?page=$truePage&limit=10&status=$status',
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
          final extractedData = body['data']['data'] as List;

          if (extractedData.isNotEmpty) {
            final List<NeedExpression> newNeedExpression = [];

            for (var needExpression in extractedData) {
              newNeedExpression.add(NeedExpression.fromJson(needExpression));
            }

            emit(NeedExpressionReportDone(needsExpression: [
              ...state.needsExpression,
              ...newNeedExpression
            ]));
          }
        } else {
          emit(NeedExpressionReportFailed([], failedMessage: message));
        }
      } catch (error) {
        print(error);
        emit(const NeedExpressionReportError([],
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<NeedExpressionReportState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
