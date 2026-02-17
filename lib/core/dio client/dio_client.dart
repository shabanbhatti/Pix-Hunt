import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/Utils/toast.dart';
import 'package:pix_hunt_project/core/constants/constants_env.dart';
import 'package:pix_hunt_project/core/errors/exceptions/dio_exceptions.dart';

class DioClient {
  late Dio dio;
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.pexels.com/v1/',
        headers: {'Authorization': EnvUtils.apiKey ?? ''},
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          final msg = DioErrorHandler.handle(e);
          ToastUtils.showToast(msg, color: Colors.red);
          handler.next(e);
        },
      ),
    );
  }
}
