// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/plan_models/target.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

part 'plan_report_state.dart';

class PlanReportCubit extends Cubit<PlanReportState> {
  PlanReportCubit() : super(PlanReportInitial([]));

  Repositories repositories = Repositories();

  Future<void> getPlanReport(int domainId) async {
    try {
      emit(PlanReportLoading([]));

      Response response = await repositories.getData(
          '/plan/plan-progressive-report/${ChildAccount().accountId}?domainId=$domainId',
          null);

      String message =response.data['message'] != null
          ? response.data['message'].toString()
          :  response.data['messages']
          .toString()
          .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        var extractedData = body['data'] as List;

        List<Target> report = [];

        for (var list in extractedData) {
          for (var target in list) {
            report.add(Target.fromJson(target));
          }
        }

        emit(PlanReportDone(report: report));
      } else {
        if (response.data['data'] == null) {
          emit(PlanReportEmpty([]));
        } else {
          emit(PlanReportFailed([], failedMessage: message));
        }
      }
    } catch (error) {
      print(error.toString());
      emit(PlanReportError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
