import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../config/app_config.dart';
import '../models/app_model.dart';
import '../models/user_model.dart';
import '../models/empty_response.dart';

part 'membership_service.g.dart';

@RestApi()
abstract class MembershipService {
  factory MembershipService(Dio dio, {String baseUrl}) = _MembershipService;

  @GET('/membership/plans')
  Future<ApiResponse<List<MembershipPlan>>> getPlans();

  @POST('/membership/subscribe')
  Future<ApiResponse<Subscription>> subscribe(@Body() Map<String, String> data);

  @GET('/membership/status')
  Future<ApiResponse<Subscription>> getStatus();

  @POST('/membership/cancel')
  Future<ApiResponse<EmptyResponse>> cancelSubscription();
}

class MembershipServiceClient {
  static MembershipService? _instance;
  static Dio? _dio;

  static MembershipService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = MembershipService(_dio!, baseUrl: AppConfig.baseApiUrl);
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
