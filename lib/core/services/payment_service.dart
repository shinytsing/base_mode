import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../config/app_config.dart';
import '../models/app_model.dart';
import '../models/user_model.dart';
import '../models/empty_response.dart';

part 'payment_service.g.dart';

@RestApi()
abstract class PaymentService {
  factory PaymentService(Dio dio, {String baseUrl}) = _PaymentService;

  @POST('/payment/create-intent')
  Future<ApiResponse<PaymentResponse>> createPaymentIntent(@Body() PaymentRequest request);

  @POST('/payment/webhook')
  Future<ApiResponse<EmptyResponse>> handleWebhook(@Body() Map<String, dynamic> data);

  @GET('/payment/history')
  Future<ApiResponse<List<PaymentResponse>>> getPaymentHistory();
}

class PaymentServiceClient {
  static PaymentService? _instance;
  static Dio? _dio;

  static PaymentService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = PaymentService(_dio!, baseUrl: AppConfig.baseApiUrl);
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
