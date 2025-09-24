import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../config/app_config.dart';
import '../models/app_model.dart';
import '../models/user_model.dart';
import '../models/empty_response.dart';

part 'app_service.g.dart';

@RestApi()
abstract class AppService {
  factory AppService(Dio dio, {String baseUrl}) = _AppService;

  @GET('/apps')
  Future<ApiResponse<List<AppModel>>> getApps();

  @GET('/apps/{id}')
  Future<ApiResponse<AppModel>> getAppByID(@Path('id') String appId);

  @POST('/apps/{id}/install')
  Future<ApiResponse<EmptyResponse>> installApp(@Path('id') String appId);

  @DELETE('/apps/{id}/uninstall')
  Future<ApiResponse<EmptyResponse>> uninstallApp(@Path('id') String appId);

  @GET('/apps/installed')
  Future<ApiResponse<List<AppModel>>> getInstalledApps();
}

class AppServiceClient {
  static AppService? _instance;
  static Dio? _dio;

  static AppService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = AppService(_dio!, baseUrl: AppConfig.baseApiUrl);
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
          handler.next(error);
        },
      ),
    );
  }

  static String? _getStoredToken() {
    // 这里应该从SharedPreferences获取token
    return null;
  }
}
