// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/pep_3_test_models/domain.dart';

part 'plan_domains_state.dart';

class PlanDomainsCubit extends Cubit<PlanDomainsState> {
  PlanDomainsCubit() : super(PlanDomainsInitial([]));

  Repositories repositories = Repositories();

  Future<void> getDomains() async {
    try {
      emit(PlanDomainsLoading([]));

      Response response = await repositories.getData('/pep3-test/domain', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
          .toString()
          .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        var extractedData = body['data'] as List;
        List<Domain> extractedDomains = [];

        for (var domain in extractedData) {
          if (domain['id'] <= 6 || domain['id'] == 11) {
            extractedDomains.add(Domain.fromJson(domain));
          }
        }

        emit(PlanDomainsDone(domains: extractedDomains));
      } else {
        emit(PlanDomainsFailed([], failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(PlanDomainsError([],
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
