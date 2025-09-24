import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../config/app_config.dart';
import '../models/user_model.dart';
import '../models/empty_response.dart';
import '../utils/app_constants.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/auth/login')
  Future<ApiResponse<LoginResult>> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<ApiResponse<UserModel>> register(@Body() RegisterRequest request);

  @POST('/auth/forgot-password')
  Future<ApiResponse<EmptyResponse>> forgotPassword(@Body() Map<String, String> request);

  @POST('/auth/reset-password')
  Future<ApiResponse<EmptyResponse>> resetPassword(@Body() Map<String, String> request);

  @GET('/user/profile')
  Future<ApiResponse<UserModel>> getUserProfile();

  @POST('/user/logout')
  Future<ApiResponse<EmptyResponse>> logout();

  @PUT('/user/profile')
  Future<ApiResponse<UserModel>> updateProfile(@Body() Map<String, dynamic> data);

  @POST('/user/change-password')
  Future<ApiResponse<EmptyResponse>> changePassword(@Body() Map<String, String> data);
}

class AuthServiceClient {
  static AuthService? _instance;
  static Dio? _dio;

  static AuthService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = AuthService(_dio!, baseUrl: AppConfig.baseApiUrl);
    }
    return _instance!;
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 添加认证头
          final token = _getStoredToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // 添加通用头
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token过期，尝试刷新
            _refreshToken().then((success) {
              if (success) {
                // 重新发送请求
                final options = error.requestOptions;
                final token = _getStoredToken();
                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                _dio!.fetch(options).then(handler.resolve).catchError(handler.next);
              } else {
                handler.next(error);
              }
            });
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  static String? _getStoredToken() {
    // 这里应该从SharedPreferences获取token
    // 为了简化，暂时返回null
    return null;
  }

  static Future<bool> _refreshToken() async {
    try {
      // 实现token刷新逻辑
      return false;
    } catch (e) {
      return false;
    }
  }
}
