import 'dart:convert';
import 'dart:io';

/// API测试脚本
/// 用于测试集成的AI服务和第三方服务
void main() async {
  print('🚀 QAToolBox API测试开始...\n');
  
  // 测试AI服务
  await testAIServices();
  
  // 测试第三方服务
  await testThirdPartyServices();
  
  print('\n✅ API测试完成！');
}

/// 测试AI服务
Future<void> testAIServices() async {
  print('🤖 测试AI服务...');
  
  final baseUrl = 'http://localhost:8080/api/v1';
  
  try {
    // 测试获取可用AI服务
    print('  📋 获取可用AI服务列表...');
    final servicesResponse = await _makeRequest('$baseUrl/ai/services');
    if (servicesResponse != null) {
      final services = jsonDecode(servicesResponse)['services'] as List;
      print('  ✅ 找到 ${services.length} 个可用AI服务:');
      for (final service in services) {
        print('    - ${service['name']}: ${service['description']}');
      }
    }
    
    // 测试AI文本生成
    print('  💬 测试AI文本生成...');
    final generateRequest = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': '你好，请简单介绍一下你自己。'}
      ],
      'temperature': 0.7,
      'max_tokens': 100
    };
    
    final generateResponse = await _makeRequest(
      '$baseUrl/ai/generate',
      method: 'POST',
      body: jsonEncode(generateRequest),
    );
    
    if (generateResponse != null) {
      final response = jsonDecode(generateResponse);
      if (response['choices'] != null && response['choices'].isNotEmpty) {
        final content = response['choices'][0]['message']['content'];
        print('  ✅ AI回复: $content');
      }
    }
    
    // 测试服务统计
    print('  📊 获取AI服务统计...');
    final statsResponse = await _makeRequest('$baseUrl/ai/stats');
    if (statsResponse != null) {
      final stats = jsonDecode(statsResponse);
      print('  ✅ 总服务数: ${stats['totalServices']}, 可用服务数: ${stats['availableServices']}');
    }
    
  } catch (e) {
    print('  ❌ AI服务测试失败: $e');
  }
  
  print('');
}

/// 测试第三方服务
Future<void> testThirdPartyServices() async {
  print('🌐 测试第三方服务...');
  
  final baseUrl = 'http://localhost:8080/api/v1';
  
  try {
    // 测试获取所有服务状态
    print('  📋 获取所有服务状态...');
    final statusResponse = await _makeRequest('$baseUrl/third-party/status');
    if (statusResponse != null) {
      final statuses = jsonDecode(statusResponse)['services'] as List;
      print('  ✅ 服务状态:');
      for (final status in statuses) {
        final icon = status['status'] == 'available' ? '✅' : '❌';
        print('    $icon ${status['service']}: ${status['message']}');
      }
    }
    
    // 测试高德地图地理编码
    print('  🗺️ 测试高德地图地理编码...');
    final geocodeRequest = {
      'address': '北京市天安门广场'
    };
    
    final geocodeResponse = await _makeRequest(
      '$baseUrl/third-party/amap/geocode',
      method: 'POST',
      body: jsonEncode(geocodeRequest),
    );
    
    if (geocodeResponse != null) {
      final response = jsonDecode(geocodeResponse);
      if (response['status'] == '1' && response['geocodes'].isNotEmpty) {
        final geocode = response['geocodes'][0];
        print('  ✅ 地理编码成功: ${geocode['formatted_address']} -> ${geocode['location']}');
      } else {
        print('  ⚠️ 地理编码失败: ${response['info']}');
      }
    }
    
    // 测试Pixabay图片搜索
    print('  🖼️ 测试Pixabay图片搜索...');
    final pixabayRequest = {
      'query': 'nature',
      'category': 'nature',
      'per_page': 5
    };
    
    final pixabayResponse = await _makeRequest(
      '$baseUrl/third-party/pixabay/search',
      method: 'POST',
      body: jsonEncode(pixabayRequest),
    );
    
    if (pixabayResponse != null) {
      final response = jsonDecode(pixabayResponse);
      if (response['hits'] != null && response['hits'].isNotEmpty) {
        print('  ✅ 找到 ${response['totalHits']} 张图片');
        for (int i = 0; i < response['hits'].length && i < 3; i++) {
          final hit = response['hits'][i];
          print('    - ${hit['tags']} (${hit['user']})');
        }
      } else {
        print('  ⚠️ 未找到图片');
      }
    }
    
    // 测试OpenWeather天气查询
    print('  🌤️ 测试OpenWeather天气查询...');
    final weatherRequest = {
      'city': 'Beijing',
      'country_code': 'CN'
    };
    
    final weatherResponse = await _makeRequest(
      '$baseUrl/third-party/weather',
      method: 'POST',
      body: jsonEncode(weatherRequest),
    );
    
    if (weatherResponse != null) {
      final response = jsonDecode(weatherResponse);
      if (response['cod'] == 200) {
        final main = response['main'];
        final weather = response['weather'][0];
        print('  ✅ 天气查询成功: ${response['name']} - ${weather['description']}, 温度: ${main['temp']}°C');
      } else {
        print('  ⚠️ 天气查询失败: ${response['message']}');
      }
    }
    
  } catch (e) {
    print('  ❌ 第三方服务测试失败: $e');
  }
  
  print('');
}

/// 发送HTTP请求
Future<String?> _makeRequest(String url, {String method = 'GET', String? body}) async {
  try {
    final client = HttpClient();
    final request = await client.openUrl(method, Uri.parse(url));
    
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    if (body != null) {
      request.write(body);
    }
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    client.close();
    
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      print('  ⚠️ HTTP ${response.statusCode}: $responseBody');
      return null;
    }
  } catch (e) {
    print('  ❌ 请求失败: $e');
    return null;
  }
}

/// 测试特定AI服务
Future<void> testSpecificAIService(String serviceType) async {
  print('🔧 测试特定AI服务: $serviceType');
  
  final baseUrl = 'http://localhost:8080/api/v1';
  
  try {
    final testResponse = await _makeRequest('$baseUrl/ai/services/$serviceType/test');
    if (testResponse != null) {
      final response = jsonDecode(testResponse);
      if (response['success']) {
        print('  ✅ $serviceType 服务测试成功');
      } else {
        print('  ❌ $serviceType 服务测试失败');
      }
    }
  } catch (e) {
    print('  ❌ $serviceType 服务测试异常: $e');
  }
}

/// 测试特定第三方服务
Future<void> testSpecificThirdPartyService(String serviceType) async {
  print('🔧 测试特定第三方服务: $serviceType');
  
  final baseUrl = 'http://localhost:8080/api/v1';
  
  try {
    final statusResponse = await _makeRequest('$baseUrl/third-party/status/$serviceType');
    if (statusResponse != null) {
      final response = jsonDecode(statusResponse);
      final icon = response['status'] == 'available' ? '✅' : '❌';
      print('  $icon $serviceType: ${response['message']}');
    }
  } catch (e) {
    print('  ❌ $serviceType 服务状态检查异常: $e');
  }
}
