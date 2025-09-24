class AppConstants {
  // 存储键名
  static const String userTokenKey = 'user_token';
  static const String userInfoKey = 'user_info';
  static const String membershipKey = 'membership_info';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // API端点
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userProfileEndpoint = '/user/profile';
  static const String membershipEndpoint = '/membership';
  static const String paymentEndpoint = '/payment';
  
  // 应用标识
  static const String qaToolBoxProId = 'qa_toolbox_pro';
  static const String lifeModeId = 'life_mode';
  static const String fitTrackerId = 'fit_tracker';
  static const String socialHubId = 'social_hub';
  static const String creativeStudioId = 'creative_studio';
  
  // 错误消息
  static const String networkError = '网络连接失败，请检查网络设置';
  static const String serverError = '服务器错误，请稍后重试';
  static const String authError = '认证失败，请重新登录';
  static const String permissionError = '权限不足，请升级会员';
  
  // 成功消息
  static const String loginSuccess = '登录成功';
  static const String registerSuccess = '注册成功';
  static const String paymentSuccess = '支付成功';
  static const String updateSuccess = '更新成功';
  
  // 默认值
  static const int defaultPageSize = 20;
  static const int maxRetryCount = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration tokenRefreshInterval = Duration(minutes: 15);
}
