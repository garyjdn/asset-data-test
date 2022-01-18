import 'package:dio/dio.dart';

class Environment {
  static const baseUrl = 'https://petronastest.be.assetdata.io';
  static const apiPath = '$baseUrl/api/v1/';
  static const assetPath = apiPath + 'assets/';
  static BaseOptions dioBaseOptions = BaseOptions(
    baseUrl: apiPath,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
}
