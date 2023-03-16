import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: "https://student.valuxapps.com/api/",
        receiveDataWhenStatusError: true,
        headers: {"Content-Type": "application/json", "lang": "ar"}));
  }

  static Future<Response> getData(
      {required String path,
      required Map<String, dynamic> query,
      String? token}) async {
    dio!.options.headers = {"Authorization": token};
    return await dio!.get(path, queryParameters: query);
  }

  static Future<Response> postData(
      {required String path,
       Map<String, dynamic>? query,
      required Map<String, dynamic> data,
      String? token}) async {
    dio!.options.headers = {"Authorization": token};
    return await dio!.post(path, queryParameters: query, data: data);
  }
}
