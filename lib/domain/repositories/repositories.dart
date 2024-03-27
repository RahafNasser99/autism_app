// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';

class Repositories {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: Constant.ipAddress,
      followRedirects: false,
      validateStatus: (status) => true,
    ),
  );


  //---------------- POST Without Token ----------------//
  Future<Response> postDataWithoutToken(
      String url, Map<String, dynamic> data) async {
    Response response = await dio.post(dio.options.baseUrl + url,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: data);
    print('---------------- In Repositories ----------------');
    print(response);
    return response;
  }

  //---------------- POST With Token ----------------//
  Future<Response> postDataWithToken(
      String url, Map<String, dynamic>? data) async {
    Response response = await dio.post(dio.options.baseUrl + url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ChildAccount().getAccessToken()}'
        }),
        data: data);
    print('---------------- In Repositories ----------------');
    print(response);
    return response;
  }

  //---------------- PUT ----------------//
  Future<Response> putData(String url, var data) async {
    Response response = await dio.put(dio.options.baseUrl + url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ChildAccount().getAccessToken()}'
        }),
        data: data);
    print('---------------- In Repositories ----------------');
    print(response);
    return response;
  }

  //---------------- GET ----------------//
  Future<Response> getData(String url, Map<String, dynamic>? data) async {
    Response response = await dio.get(
      dio.options.baseUrl + url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ChildAccount().getAccessToken()}'
        },
      ),
      data: data,
    );
    print('---------------- In Repositories ----------------');
    print(response);
    return response;
  }

  //---------------- Delete ----------------//
  Future<Response> deleteData(String url, Map<String, dynamic>? data) async {
    Response response = await dio.delete(
      dio.options.baseUrl + url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ChildAccount().getAccessToken()}'
        },
      ),
      data: data,
    );
    print('---------------- In Repositories ----------------');
    print(response);
    return response;
  }

}
