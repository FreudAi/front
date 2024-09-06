import 'dart:async';

import 'package:get/get.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:madaride/service/auth_service.dart';
import 'package:madaride/utils/file_secure_storage.dart';

class AuthInterceptor implements InterceptorContract {

  final authService = AuthService();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? token = await SecureStorage().getToken();
    request.headers['Authorization'] = 'Bearer $token';
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401) {
      // Logique de rafraîchissement du token
      await authService.refreshToken();
      Get.snackbar('Token expiré', 'rafraîchissement nécessaire');
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}