import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_model.dart';
import '../services/app_service.dart';

// 应用状态
class AppState {
  final List<AppModel> apps;
  final List<AppModel> installedApps;
  final bool isLoading;
  final String? error;

  const AppState({
    this.apps = const [],
    this.installedApps = const [],
    this.isLoading = false,
    this.error,
  });

  AppState copyWith({
    List<AppModel>? apps,
    List<AppModel>? installedApps,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      apps: apps ?? this.apps,
      installedApps: installedApps ?? this.installedApps,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 应用状态提供者
class AppNotifier extends StateNotifier<AppState> {
  final AppService _appService;
  
  AppNotifier(this._appService) : super(const AppState()) {
    loadApps();
  }

  // 加载所有应用
  Future<void> loadApps() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _appService.getApps();
      
      if (response.success && response.data != null) {
        state = state.copyWith(
          apps: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 加载已安装的应用
  Future<void> loadInstalledApps() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _appService.getInstalledApps();
      
      if (response.success && response.data != null) {
        state = state.copyWith(
          installedApps: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 安装应用
  Future<bool> installApp(String appId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _appService.installApp(appId);
      
      if (response.success) {
        // 重新加载已安装的应用
        await loadInstalledApps();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 卸载应用
  Future<bool> uninstallApp(String appId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _appService.uninstallApp(appId);
      
      if (response.success) {
        // 重新加载已安装的应用
        await loadInstalledApps();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 检查应用是否已安装
  bool isAppInstalled(String appId) {
    return state.installedApps.any((app) => app.id == appId);
  }

  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 提供者
final appServiceProvider = Provider<AppService>((ref) {
  return AppServiceClient.instance;
});

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  final appService = ref.watch(appServiceProvider);
  return AppNotifier(appService);
});
