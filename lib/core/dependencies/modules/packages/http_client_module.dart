import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tv_app/core/environment/environment_service.dart';

@module
abstract class HttpClientModule {
  @lazySingleton
  Dio appRouter() {
    final Dio dio = Dio();
    dio.options.baseUrl = EnvironmentService.baseUrl;

    return dio;
  }
}