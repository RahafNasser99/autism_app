// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/plan_models/plans_for_child.dart';

part 'all_plans_state.dart';

class AllPlansCubit extends Cubit<AllPlansState> {
  AllPlansCubit() : super(AllPlansInitial([])) {
    scrollController.addListener(() async {
      await getMorePlans().whenComplete(() => isLoadingMore = false);
    });
  }

  ScrollController scrollController = ScrollController();
  Repositories repositories = Repositories();
  bool isLoadingMore = false;
  int pageCount = 0;
  int page = 0;

  Future<void> getFirstPage() async {
    try {
      page = 0;

      emit(AllPlansLoading([]));

      Response response = await repositories.getData(
          '/plan/child-plans/${ChildAccount().accountId}?page=$page&limit=10',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data['data'];
        pageCount = body['pageCount'];
        var extractedData = body['data'] as List;

        if (extractedData.isNotEmpty) {
          List<PlansForChild> extractedPlans = [];

          for (var plan in extractedData) {
            extractedPlans.add(PlansForChild.fromJson(plan));
          }

          emit(AllPlansDone(plans: extractedPlans));
        } else {
          emit(AllPlansEmpty([]));
        }
      } else {
        emit(AllPlansFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(AllPlansError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getMorePlans() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        page < pageCount) {
      isLoadingMore = true;
      page++;

      try {
        Response response = await repositories.getData(
            '/plan/child-plans/${ChildAccount().accountId}?page=$page&limit=10',
            null);

        String message = response.data['message'] != null
            ? response.data['message'].toString()
            : response.data['messages']
                .toString()
                .substring(1, response.data['messages'].toString().length - 1);

        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          var body = response.data['data'];
          pageCount = body['pageCount'];
          var extractedData = body['data'] as List;

          List<PlansForChild> extractedPlans = [];

          for (var plan in extractedData) {
            extractedPlans.add(PlansForChild.fromJson(plan));
          }

          emit(AllPlansDone(plans: [...state.plans, ...extractedPlans]));
        } else {
          emit(AllPlansFailed(state.plans, failedMessage: message));
        }
      } catch (error) {
        print(error.toString());
        emit(AllPlansError(state.plans,
            errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
      }
    }
  }

  @override
  void onChange(Change<AllPlansState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
