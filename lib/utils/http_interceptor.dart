import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:madaride/utils/file_secure_storage.dart';

class AuthInterceptor implements InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? token = await SecureStorage().getToken();
    request.headers['Authorization'] = 'Bearer $token';
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    throw UnimplementedError();
  }
}