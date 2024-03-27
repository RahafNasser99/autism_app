// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/pep_3_test_models/pep3_tests_for_child.dart';

part 'pep_3_tests_state.dart';

class Pep3TestsCubit extends Cubit<Pep3TestsState> {
  Pep3TestsCubit() : super(Pep3TestsInitial([]));

  Repositories repositories = Repositories();

  Future<void> getChildPep3Tests() async {
    try {
      emit(Pep3TestsLoading([]));
      Response response = await repositories.getData(
          '/pep3-test/child-tests/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        final extractedData = body['data'] as List;
        final List<Pep3TestsForChild> extractedTests = [];

        if (extractedData.isEmpty) {
          emit(Pep3TestsEmpty([]));
        } else {
          for (var test in extractedData) {
            extractedTests.add(Pep3TestsForChild.fromJson(test));
          }
          emit(Pep3TestsDone(pep3TestsForChild: extractedTests));
        }
      } else {
        emit(Pep3TestsFailed(failedMessage: message));
      }
    } catch (error) {
      emit(Pep3TestsError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));

      print(error.toString());
    }
  }

  @override
  void onChange(Change<Pep3TestsState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
