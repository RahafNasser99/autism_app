// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/account_models/teacher_specialist_account.dart';

part 'teachers_specialists_state.dart';

class TeachersSpecialistsCubit extends Cubit<TeachersSpecialistsState> {
  TeachersSpecialistsCubit() : super(TeachersSpecialistsLoading());

  Repositories repositories = Repositories();
  List<TeacherSpecialistAccount> teachers = [];
  List<TeacherSpecialistAccount> specialists = [];

  Future<List<TeacherSpecialistAccount>> getTeachers() async {
    try {
      emit(TeachersSpecialistsLoading());
      Response response = await repositories.getData(
          '/class/child-teachers/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        final extractedData = body['data']['data'] as List;

        if (extractedData.isNotEmpty) {
          for (var account in extractedData) {
            teachers.add(TeacherSpecialistAccount.fromJson(account));
          }

          emit(TeachersSpecialistsDone());
        } else {
          emit(TeachersSpecialistsNoMember());
        }
      } else {
        emit(TeachersSpecialistsFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(const TeachersSpecialistsError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
    return teachers;
  }

  Future<List<TeacherSpecialistAccount>> getSpecialists() async {
    try {
      emit(TeachersSpecialistsLoading());
      Response response = await repositories.getData(
          '/class/child-specialists/${ChildAccount().accountId}', null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;
        final extractedData = body['data']['data'] as List;
        if (extractedData.isNotEmpty) {
          for (var account in extractedData) {
            specialists.add(TeacherSpecialistAccount.fromJson(account));
          }
          emit(TeachersSpecialistsDone());
        } else {
          emit(TeachersSpecialistsNoMember());
        }
      } else {
        emit(TeachersSpecialistsFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(const TeachersSpecialistsError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
    return specialists;
  }

  @override
  void onChange(Change<TeachersSpecialistsState> change) {
    print(change.currentState);
    print(change.nextState);
    super.onChange(change);
  }
}
