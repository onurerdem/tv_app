import 'package:dio/dio.dart';
import 'package:tv_app/core/utils/constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = BASE_URL;
  }

  Future<Response> get(String path) async {
    return await dio.get(path);
  }
}
