import 'package:dio/dio.dart';

import '../../shared_preferences/shared_preferences_key.dart';
import '../../shared_preferences/shared_preferences_wrapper.dart';

class RequestTokenInterceptor extends QueuedInterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Map<String, dynamic>? authData;
    SharedPreferencesWrapper sharedPreferencesWrapper =
        SharedPreferencesWrapper(key: SharedPreferencesKey.keyAuth);

    if (options.headers.containsKey("requiresToken")) {
      options.headers.remove("requiresToken");
      if (await sharedPreferencesWrapper.hasCache()) {
        authData = await sharedPreferencesWrapper.readData();

        if (authData != null) {
          options.headers
              .addAll({"Authorization": "Bearer ${authData["token"]}"});
        }
      }
    }
    return handler.next(options);
  }
}
