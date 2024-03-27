// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/models/plan_models/plan.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'plan_target_state.dart';

class PlanTargetCubit extends Cubit<PlanTargetState> {
  PlanTargetCubit() : super(PlanTargetInitial());

  Repositories repositories = Repositories();

  Future<void> getPlanByChildId() async {
    try {
      emit(PlanTargetLoading());

      Response response = await repositories.getData(
          '/plan/child-plan/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        if ((body['data']['plan']['goal'] as List).isNotEmpty) {
          emit(PlanTargetDone(plan: Plan.fromJson(body['data']['plan'])));
        } else {
          emit(PlanTargetEmpty());
        }
      } else {
        if (response.data['data'] == null) {
          emit(PlanTargetEmpty());
        } else {
          emit(PlanTargetFailed(failedMessage: message));
        }
      }
    } catch (error) {
      print(error.toString());
      emit(PlanTargetError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }

  Future<void> getPlanByPlanId(int planId) async {
    try {
      emit(PlanTargetLoading());

      Response response = await repositories.getData('/plan/$planId', null);

      String message = response.data['messages']
          .toString()
          .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        emit(PlanTargetDone(plan: Plan.fromJson(body['data']['plan'])));
      } else {
        emit(PlanTargetFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(PlanTargetError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
