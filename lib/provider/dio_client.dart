import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

// TODO: Refactor dio's initialization

class DioHandler {
  factory DioHandler.instance() => _singleton;

  DioHandler._internal() {
    if (kIsWeb) {
      dio.interceptors.addAll([
        authTokenInterceptor,
        errorHandlerInterceptor,
      ]);
    } else {
      getApplicationDocumentsDirectory().then((dir) {
        dio.interceptors.addAll([
          authTokenInterceptor,
          errorHandlerInterceptor,
        ]);
      });
    }

    dio = Dio();
  }

  static final DioHandler _singleton = DioHandler._internal();

  late Dio dio;
}

class GeneralException implements Exception {
  GeneralException(
    this.message,
    this.code,
    this.stackTrace,
  );

  String message;
  int code;
  StackTrace stackTrace;

  @override
  String toString() =>
      '''GeneralException(message: $message, code: $code, stackTrace: $stackTrace)''';
}

final authTokenInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    try {
      final jwt = GetStorage().read<String>('jwtToken');
      log('JWT ${jwt!}');
      options.headers.addEntries([
        MapEntry<String, String>(
          'Authorization',
          'Bearer $jwt',
        )
      ]);
    } catch (e) {
      log('json web token not found');
    }
    return handler.next(options);
  },
);

final errorHandlerInterceptor = InterceptorsWrapper(
  onError: (error, handler) async {
    log(error.message);
    if (error.response != null) {
      handler.next(error);
    } else {
      error.error = GeneralException('message', 500, StackTrace.current);
      handler.next(error);
    }
  },
);
