import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/utils/uuid_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @preResolve
  Future<Dio> provideDioCreate(LocalStorageDataSource localStorageDataSource) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        baseUrl: AppConstants.appApiBaseUrl,
      ),
    );

    dio.interceptors.add(_getHttpInterceptors(localStorageDataSource));
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
        ),
      );
    }
    return dio;
  }

  InterceptorsWrapper _getHttpInterceptors(LocalStorageDataSource localStorageDataSource) {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) async {
        final token = await localStorageDataSource.accessToken;
        final deviceId = await getDeviceId();
        if (token.isNotEmpty && options.headers['Authorization'] == null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (options.contentType == null) {
          options.headers['Content-Type'] = 'application/json';
        }
        options.headers['accept'] = '*/*';
        options.headers['x-device'] = deviceId;
        return handler.next(options);
      },
      onError: (error, errorHandler) async {
        if (error.response?.statusCode == 401) {
          // final requestOptions = error.requestOptions;
          // final dio = Dio();
          // if (kDebugMode) {
          //   dio.interceptors.add(
          //     PrettyDioLogger(requestBody: true, requestHeader: true),
          //   );
          // }
          // final refreshToken = localStorageDataSource.read(StorageKey.refreshToken);
          // final remoteUserDataSource = RemoteUserDataSource(dio, baseUrl: AppConstants.appApiBaseUrl);
          //
          // try {
          //   final newToken = await remoteUserDataSource.refreshToken(RefreshTokenRequest(refreshToken: refreshToken ?? ''));
          //   localStorageDataSource
          //     ..accessToken = newToken.token
          //     ..refreshToken = newToken.refreshToken;
          //   final headers = <String, dynamic>{
          //     ...requestOptions.headers,
          //   };
          //   headers['Authorization'] = 'JWT ${newToken.token}';
          //
          //   final response = await dio.request<dynamic>(
          //     AppConstants.appApiBaseUrl + requestOptions.path,
          //     options: Options(method: requestOptions.method, headers: headers),
          //     data: requestOptions.data,
          //     queryParameters: requestOptions.queryParameters,
          //   );
          //   return errorHandler.resolve(response);
          // } on DioException catch (e) {
          //   /// navigate to login page
          //   if (e.response?.statusCode == 400) {
          //     return errorHandler.next(error);
          //   }
          //   return errorHandler.next(e);
          // } catch (e) {
          //   return errorHandler.next(error);
          // }
          return errorHandler.next(error);
        } else if (error.response?.statusCode == 403) {
          /// navigate to login page
          return errorHandler.next(error);
        } else {
          return errorHandler.next(error);
        }
      },
    );
  }
}
