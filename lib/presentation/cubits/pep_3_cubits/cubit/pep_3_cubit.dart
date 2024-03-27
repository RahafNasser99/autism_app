// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/pep_3_test_models/pep_3_test.dart';

part 'pep_3_state.dart';

class Pep3Cubit extends Cubit<Pep3State> {
  Pep3Cubit() : super(Pep3Initial());

  Repositories repositories = Repositories();

  Future<void> getPep3TestResult(int pep3TestId) async {
    try {
      emit(Pep3Loading());

      Response response =
          await repositories.getData('/pep3-test/result/$pep3TestId', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
          .toString()
          .substring(1, response.data['messages'].toString().length - 1);


      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data['data'];

        emit(Pep3Done(pep3test: Pep3Test.fromJson(body)));
        
      } else {
        emit(Pep3Failed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(Pep3Error(errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
