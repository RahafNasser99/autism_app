// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';

import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/need_expression_models/need.dart';

part 'need_section_state.dart';

class NeedSectionCubit extends Cubit<NeedSectionState> {
  NeedSectionCubit() : super(NeedSectionLoading());

  Repositories repositories = Repositories();
  List<Need> needs = [];

  Future<List<Need>> getNeeds(int parentNeedId, int needsLevel) async {
    try {
      Response response = await repositories.getData(
          '/needs/by-parent/$parentNeedId', {'childLevel': needsLevel});

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 &&
          response.statusCode! < 400 &&
          response.data['data'] != null) {
        var body = response.data;
        final extractedData = body['data'] as List;

        for (var need in extractedData) {
          needs.add(Need.fromJson(need));
        }

        emit(NeedSectionDone());
      } else {
        if (response.data['data'] == null) {
          emit(NeedSectionNoNeeds());
        } else {
          emit(NeedSectionFailed(failedMessage: message));
        }
      }
    } catch (error) {
      print(error.toString());
      emit(NeedSectionError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
    return needs;
  }
}
