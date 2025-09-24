import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../config/api_config.dart';

part 'third_party_service.g.dart';
part 'third_party_service.freezed.dart';

/// 第三方服务客户端
@RestApi(baseUrl: ApiConfig.thirdPartyServiceUrl)
abstract class ThirdPartyService {
  factory ThirdPartyService(Dio dio, {String baseUrl}) = _ThirdPartyService;

  // ==================== 高德地图服务 ====================
  
  /// 地理编码（地址转坐标）
  @POST('/amap/geocode')
  Future<AmapGeocodeResponse> amapGeocode(@Body() AmapGeocodeRequest request);

  /// 逆地理编码（坐标转地址）
  @POST('/amap/regeocode')
  Future<AmapRegeocodeResponse> amapRegeocode(@Body() AmapRegeocodeRequest request);

  // ==================== Pixabay图片服务 ====================
  
  /// 搜索图片
  @POST('/pixabay/search')
  Future<PixabaySearchResponse> pixabaySearchImages(@Body() PixabaySearchRequest request);

  // ==================== OpenWeather天气服务 ====================
  
  /// 获取天气信息
  @POST('/weather')
  Future<OpenWeatherResponse> openWeatherGetWeather(@Body() OpenWeatherRequest request);

  // ==================== Google搜索服务 ====================
  
  /// Google搜索
  @POST('/google/search')
  Future<GoogleSearchResponse> googleSearch(@Body() GoogleSearchRequest request);

  // ==================== 邮件服务 ====================
  
  /// 发送邮件
  @POST('/email/send')
  Future<EmailSendResponse> sendEmail(@Body() EmailSendRequest request);

  // ==================== 服务状态检查 ====================
  
  /// 检查服务状态
  @GET('/status/{service}')
  Future<ServiceStatusResponse> checkServiceStatus(@Path('service') String service);

  /// 获取所有服务状态
  @GET('/status')
  Future<AllServiceStatusResponse> getAllServiceStatus();
}

// ==================== 高德地图服务模型 ====================

/// 地理编码请求
@freezed
class AmapGeocodeRequest with _$AmapGeocodeRequest {
  const factory AmapGeocodeRequest({
    required String address,
  }) = _AmapGeocodeRequest;

  factory AmapGeocodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AmapGeocodeRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$AmapGeocodeRequestToJson(this);
}

/// 地理编码响应
@freezed
class AmapGeocodeResponse with _$AmapGeocodeResponse {
  const factory AmapGeocodeResponse({
    required String status,
    required String info,
    required String infocode,
    required String count,
    required List<AmapGeocode> geocodes,
  }) = _AmapGeocodeResponse;

  factory AmapGeocodeResponse.fromJson(Map<String, dynamic> json) =>
      _$AmapGeocodeResponseFromJson(json);
}

/// 地理编码结果
@freezed
class AmapGeocode with _$AmapGeocode {
  const factory AmapGeocode({
    required String formattedAddress,
    required String province,
    required String city,
    required String district,
    required String township,
    required AmapNeighborhood neighborhood,
    required AmapBuilding building,
    required String adcode,
    required String location,
    required String level,
  }) = _AmapGeocode;

  factory AmapGeocode.fromJson(Map<String, dynamic> json) =>
      _$AmapGeocodeFromJson(json);
}

/// 高德地图邻里信息
@freezed
class AmapNeighborhood with _$AmapNeighborhood {
  const factory AmapNeighborhood({
    required String name,
  }) = _AmapNeighborhood;

  factory AmapNeighborhood.fromJson(Map<String, dynamic> json) =>
      _$AmapNeighborhoodFromJson(json);
}

/// 高德地图建筑信息
@freezed
class AmapBuilding with _$AmapBuilding {
  const factory AmapBuilding({
    required String name,
  }) = _AmapBuilding;

  factory AmapBuilding.fromJson(Map<String, dynamic> json) =>
      _$AmapBuildingFromJson(json);
}

/// 逆地理编码请求
@freezed
class AmapRegeocodeRequest with _$AmapRegeocodeRequest {
  const factory AmapRegeocodeRequest({
    required double longitude,
    required double latitude,
  }) = _AmapRegeocodeRequest;

  factory AmapRegeocodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AmapRegeocodeRequestFromJson(json);
}

/// 逆地理编码响应
@freezed
class AmapRegeocodeResponse with _$AmapRegeocodeResponse {
  const factory AmapRegeocodeResponse({
    required String status,
    required String info,
    required String infocode,
    required AmapRegeocode regeocode,
  }) = _AmapRegeocodeResponse;

  factory AmapRegeocodeResponse.fromJson(Map<String, dynamic> json) =>
      _$AmapRegeocodeResponseFromJson(json);
}

/// 逆地理编码结果
@freezed
class AmapRegeocode with _$AmapRegeocode {
  const factory AmapRegeocode({
    required String formattedAddress,
    required AmapAddressComponent addressComponent,
    required String location,
  }) = _AmapRegeocode;

  factory AmapRegeocode.fromJson(Map<String, dynamic> json) =>
      _$AmapRegeocodeFromJson(json);
}

/// 高德地图地址组件
@freezed
class AmapAddressComponent with _$AmapAddressComponent {
  const factory AmapAddressComponent({
    required String province,
    required String city,
    required String district,
    required String township,
  }) = _AmapAddressComponent;

  factory AmapAddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AmapAddressComponentFromJson(json);
}

// ==================== Pixabay图片服务模型 ====================

/// Pixabay搜索请求
@freezed
class PixabaySearchRequest with _$PixabaySearchRequest {
  const factory PixabaySearchRequest({
    required String query,
    @Default('all') String category,
    @Default(100) int minWidth,
    @Default(100) int minHeight,
    @Default(20) int perPage,
  }) = _PixabaySearchRequest;

  factory PixabaySearchRequest.fromJson(Map<String, dynamic> json) =>
      _$PixabaySearchRequestFromJson(json);
}

/// Pixabay搜索响应
@freezed
class PixabaySearchResponse with _$PixabaySearchResponse {
  const factory PixabaySearchResponse({
    required int total,
    required int totalHits,
    required List<PixabayImage> hits,
  }) = _PixabaySearchResponse;

  factory PixabaySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PixabaySearchResponseFromJson(json);
}

/// Pixabay图片
@freezed
class PixabayImage with _$PixabayImage {
  const factory PixabayImage({
    required int id,
    required String pageURL,
    required String type,
    required String tags,
    required String previewURL,
    required int previewWidth,
    required int previewHeight,
    required String webformatURL,
    required int webformatWidth,
    required int webformatHeight,
    required String largeImageURL,
    required int imageWidth,
    required int imageHeight,
    required int imageSize,
    required int views,
    required int downloads,
    required int collections,
    required int likes,
    required int comments,
    required int userID,
    required String user,
    required String userImageURL,
  }) = _PixabayImage;

  factory PixabayImage.fromJson(Map<String, dynamic> json) =>
      _$PixabayImageFromJson(json);
}

// ==================== OpenWeather天气服务模型 ====================

/// 天气查询请求
@freezed
class OpenWeatherRequest with _$OpenWeatherRequest {
  const factory OpenWeatherRequest({
    required String city,
    @Default('CN') String countryCode,
  }) = _OpenWeatherRequest;

  factory OpenWeatherRequest.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherRequestFromJson(json);
}

/// 天气查询响应
@freezed
class OpenWeatherResponse with _$OpenWeatherResponse {
  const factory OpenWeatherResponse({
    required OpenWeatherCoord coord,
    required List<OpenWeatherWeather> weather,
    required String base,
    required OpenWeatherMain main,
    required int visibility,
    required OpenWeatherWind wind,
    required OpenWeatherClouds clouds,
    required int dt,
    required OpenWeatherSys sys,
    required int timezone,
    required int id,
    required String name,
    required int cod,
  }) = _OpenWeatherResponse;

  factory OpenWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherResponseFromJson(json);
}

/// 天气坐标
@freezed
class OpenWeatherCoord with _$OpenWeatherCoord {
  const factory OpenWeatherCoord({
    required double lon,
    required double lat,
  }) = _OpenWeatherCoord;

  factory OpenWeatherCoord.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherCoordFromJson(json);
}

/// 天气信息
@freezed
class OpenWeatherWeather with _$OpenWeatherWeather {
  const factory OpenWeatherWeather({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _OpenWeatherWeather;

  factory OpenWeatherWeather.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherWeatherFromJson(json);
}

/// 天气主要信息
@freezed
class OpenWeatherMain with _$OpenWeatherMain {
  const factory OpenWeatherMain({
    required double temp,
    required double feelsLike,
    required double tempMin,
    required double tempMax,
    required int pressure,
    required int humidity,
  }) = _OpenWeatherMain;

  factory OpenWeatherMain.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherMainFromJson(json);
}

/// 天气风力信息
@freezed
class OpenWeatherWind with _$OpenWeatherWind {
  const factory OpenWeatherWind({
    required double speed,
    required int deg,
  }) = _OpenWeatherWind;

  factory OpenWeatherWind.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherWindFromJson(json);
}

/// 天气云量信息
@freezed
class OpenWeatherClouds with _$OpenWeatherClouds {
  const factory OpenWeatherClouds({
    required int all,
  }) = _OpenWeatherClouds;

  factory OpenWeatherClouds.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherCloudsFromJson(json);
}

/// 天气系统信息
@freezed
class OpenWeatherSys with _$OpenWeatherSys {
  const factory OpenWeatherSys({
    required int type,
    required int id,
    required String country,
    required int sunrise,
    required int sunset,
  }) = _OpenWeatherSys;

  factory OpenWeatherSys.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherSysFromJson(json);
}

// ==================== Google搜索服务模型 ====================

/// Google搜索请求
@freezed
class GoogleSearchRequest with _$GoogleSearchRequest {
  const factory GoogleSearchRequest({
    required String query,
    @Default(10) int num,
  }) = _GoogleSearchRequest;

  factory GoogleSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchRequestFromJson(json);
}

/// Google搜索响应
@freezed
class GoogleSearchResponse with _$GoogleSearchResponse {
  const factory GoogleSearchResponse({
    required String kind,
    required GoogleSearchURL url,
    required GoogleSearchQueries queries,
    required GoogleSearchContext context,
    required GoogleSearchInformation searchInformation,
    required List<GoogleSearchItem> items,
  }) = _GoogleSearchResponse;

  factory GoogleSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchResponseFromJson(json);
}

/// Google搜索URL信息
@freezed
class GoogleSearchURL with _$GoogleSearchURL {
  const factory GoogleSearchURL({
    required String type,
    required String template,
  }) = _GoogleSearchURL;

  factory GoogleSearchURL.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchURLFromJson(json);
}

/// Google搜索查询信息
@freezed
class GoogleSearchQueries with _$GoogleSearchQueries {
  const factory GoogleSearchQueries({
    required List<GoogleSearchRequest> request,
  }) = _GoogleSearchQueries;

  factory GoogleSearchQueries.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchQueriesFromJson(json);
}

/// Google搜索上下文
@freezed
class GoogleSearchContext with _$GoogleSearchContext {
  const factory GoogleSearchContext({
    required String title,
  }) = _GoogleSearchContext;

  factory GoogleSearchContext.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchContextFromJson(json);
}

/// Google搜索信息
@freezed
class GoogleSearchInformation with _$GoogleSearchInformation {
  const factory GoogleSearchInformation({
    required double searchTime,
    required String formattedSearchTime,
    required String totalResults,
    required String formattedTotalResults,
  }) = _GoogleSearchInformation;

  factory GoogleSearchInformation.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchInformationFromJson(json);
}

/// Google搜索结果项
@freezed
class GoogleSearchItem with _$GoogleSearchItem {
  const factory GoogleSearchItem({
    required String kind,
    required String title,
    required String htmlTitle,
    required String link,
    required String displayLink,
    required String snippet,
    required String htmlSnippet,
    required String formattedURL,
    required GoogleSearchPagemap pagemap,
  }) = _GoogleSearchItem;

  factory GoogleSearchItem.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchItemFromJson(json);
}

/// Google搜索页面映射
@freezed
class GoogleSearchPagemap with _$GoogleSearchPagemap {
  const factory GoogleSearchPagemap({
    required List<GoogleSearchMetatag> metatags,
  }) = _GoogleSearchPagemap;

  factory GoogleSearchPagemap.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchPagemapFromJson(json);
}

/// Google搜索元标签
@freezed
class GoogleSearchMetatag with _$GoogleSearchMetatag {
  const factory GoogleSearchMetatag({
    required String title,
    required String description,
  }) = _GoogleSearchMetatag;

  factory GoogleSearchMetatag.fromJson(Map<String, dynamic> json) =>
      _$GoogleSearchMetatagFromJson(json);
}

// ==================== 邮件服务模型 ====================

/// 邮件发送请求
@freezed
class EmailSendRequest with _$EmailSendRequest {
  const factory EmailSendRequest({
    required List<String> to,
    required String subject,
    required String body,
    @Default(false) bool isHTML,
  }) = _EmailSendRequest;

  factory EmailSendRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailSendRequestFromJson(json);
}

/// 邮件发送响应
@freezed
class EmailSendResponse with _$EmailSendResponse {
  const factory EmailSendResponse({
    required bool success,
    required String message,
  }) = _EmailSendResponse;

  factory EmailSendResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailSendResponseFromJson(json);
}

// ==================== 服务状态模型 ====================

/// 服务状态响应
@freezed
class ServiceStatusResponse with _$ServiceStatusResponse {
  const factory ServiceStatusResponse({
    required String service,
    required String status,
    required String message,
  }) = _ServiceStatusResponse;

  factory ServiceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceStatusResponseFromJson(json);
}

/// 所有服务状态响应
@freezed
class AllServiceStatusResponse with _$AllServiceStatusResponse {
  const factory AllServiceStatusResponse({
    required List<ServiceStatusResponse> services,
    required int count,
  }) = _AllServiceStatusResponse;

  factory AllServiceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$AllServiceStatusResponseFromJson(json);
}

/// 第三方服务客户端管理器
class ThirdPartyServiceClient {
  static ThirdPartyService? _instance;
  static Dio? _dio;

  static ThirdPartyService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = ThirdPartyService(_dio!, baseUrl: ApiConfig.thirdPartyServiceUrl);
    }
    return _instance!;
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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

  // ==================== 高德地图服务便捷方法 ====================

  /// 地理编码（地址转坐标）
  static Future<AmapGeocodeResponse> geocode(String address) async {
    try {
      final request = AmapGeocodeRequest(address: address);
      return await instance.amapGeocode(request);
    } catch (e) {
      throw Exception('地理编码失败: $e');
    }
  }

  /// 逆地理编码（坐标转地址）
  static Future<AmapRegeocodeResponse> regeocode(double longitude, double latitude) async {
    try {
      final request = AmapRegeocodeRequest(
        longitude: longitude,
        latitude: latitude,
      );
      return await instance.amapRegeocode(request);
    } catch (e) {
      throw Exception('逆地理编码失败: $e');
    }
  }

  // ==================== Pixabay图片服务便捷方法 ====================

  /// 搜索图片
  static Future<PixabaySearchResponse> searchImages({
    required String query,
    String category = 'all',
    int minWidth = 100,
    int minHeight = 100,
    int perPage = 20,
  }) async {
    try {
      final request = PixabaySearchRequest(
        query: query,
        category: category,
        minWidth: minWidth,
        minHeight: minHeight,
        perPage: perPage,
      );
      return await instance.pixabaySearchImages(request);
    } catch (e) {
      throw Exception('搜索图片失败: $e');
    }
  }

  // ==================== OpenWeather天气服务便捷方法 ====================

  /// 获取天气信息
  static Future<OpenWeatherResponse> getWeather({
    required String city,
    String countryCode = 'CN',
  }) async {
    try {
      final request = OpenWeatherRequest(
        city: city,
        countryCode: countryCode,
      );
      return await instance.openWeatherGetWeather(request);
    } catch (e) {
      throw Exception('获取天气信息失败: $e');
    }
  }

  // ==================== Google搜索服务便捷方法 ====================

  /// Google搜索
  static Future<GoogleSearchResponse> search({
    required String query,
    int num = 10,
  }) async {
    try {
      final request = GoogleSearchRequest(
        query: query,
        num: num,
      );
      return await instance.googleSearch(request);
    } catch (e) {
      throw Exception('Google搜索失败: $e');
    }
  }

  // ==================== 邮件服务便捷方法 ====================

  /// 发送邮件
  static Future<EmailSendResponse> sendEmail({
    required List<String> to,
    required String subject,
    required String body,
    bool isHTML = false,
  }) async {
    try {
      final request = EmailSendRequest(
        to: to,
        subject: subject,
        body: body,
        isHTML: isHTML,
      );
      return await instance.sendEmail(request);
    } catch (e) {
      throw Exception('发送邮件失败: $e');
    }
  }

  // ==================== 服务状态检查便捷方法 ====================

  /// 检查服务状态
  static Future<ServiceStatusResponse> checkServiceStatus(String service) async {
    try {
      return await instance.checkServiceStatus(service);
    } catch (e) {
      throw Exception('检查服务状态失败: $e');
    }
  }

  /// 获取所有服务状态
  static Future<List<ServiceStatusResponse>> getAllServiceStatus() async {
    try {
      final response = await instance.getAllServiceStatus();
      return response.services;
    } catch (e) {
      throw Exception('获取所有服务状态失败: $e');
    }
  }
}
