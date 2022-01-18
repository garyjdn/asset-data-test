import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bloc/auth/auth_cubit.dart';
import 'data/data_providers/rest/auth_rest.dart';
import 'data/data_providers/rest/brand_rest.dart';
import 'data/data_providers/rest/interceptors/request_token_interceptor.dart';
import 'data/data_providers/rest/manufacturer_rest.dart';
import 'data/data_providers/shared_preferences/shared_preferences_key.dart';
import 'data/data_providers/shared_preferences/shared_preferences_wrapper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/brand_repository.dart';
import 'data/repositories/manufacturer_repository.dart';
import 'helpers/environment.dart';
import 'ui/brand_form_screen.dart';
import 'ui/login_screen.dart';

void main() {
  Dio dio = Dio(Environment.dioBaseOptions)
    ..interceptors.addAll([
      RequestTokenInterceptor(),
    ]);
  dio.options.headers['content-type'] = "application/json";
  dio.options.headers['Accept'] = "application/json";

  // Init Data Provider Layer
  final _authRest = AuthRest(dio);
  final _manufacturerRest = ManufacturerRest(dio);
  final _brandRest = BrandRest(dio);
  final _authSharedPref =
      SharedPreferencesWrapper(key: SharedPreferencesKey.keyAuth);

  // Init Repository Layer
  final _authRepository =
      AuthRepository(authRest: _authRest, authSharedPref: _authSharedPref);
  final _manufacturerRepository =
      ManufacturerRepository(manufacturerRest: _manufacturerRest);
  final _brandRepository = BrandRepository(brandRest: _brandRest);

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => _authRepository,
      ),
      RepositoryProvider(
        create: (context) => _manufacturerRepository,
      ),
      RepositoryProvider(
        create: (context) => _brandRepository,
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository: _authRepository),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context, listen: false);
    initializeDateFormatting();
    return ScreenUtilInit(
      builder: () {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const BrandFormScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}
