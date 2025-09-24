import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/app_constants.dart';

// 认证状态
class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 认证状态提供者
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  
  AuthNotifier(this._authService) : super(const AuthState()) {
    _loadAuthState();
  }

  // 加载认证状态
  Future<void> _loadAuthState() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.userTokenKey);
      
      if (token != null) {
        final userResponse = await _authService.getUserProfile();
        state = state.copyWith(
          isAuthenticated: true,
          user: userResponse.data,
          token: token,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 登录
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _authService.login(LoginRequest(email: email, password: password));
      
      if (response.success && response.data != null) {
        final result = response.data!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, result.accessToken);
        await prefs.setString(AppConstants.userInfoKey, result.user.toJson().toString());
        
        state = state.copyWith(
          isAuthenticated: true,
          user: result.user,
          token: result.accessToken,
          isLoading: false,
        );
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

  // 注册
  Future<bool> register(String email, String username, String password, String firstName, String lastName) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _authService.register(RegisterRequest(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      ));
      
      if (response.success && response.data != null) {
        final user = response.data!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userInfoKey, user.toJson().toString());
        
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
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

  // 登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userTokenKey);
      await prefs.remove(AppConstants.userInfoKey);
      
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 刷新用户信息
  Future<void> refreshUser() async {
    try {
      final response = await _authService.getUserProfile();
      if (response.success && response.data != null) {
        state = state.copyWith(user: response.data);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 社交登录
  Future<bool> socialLogin(String provider) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 模拟社交登录过程
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟社交登录成功
      final mockUser = UserModel(
        id: 'social_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@example.com',
        username: 'social_user',
        firstName: 'Social',
        lastName: 'User',
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: true,
        isPremium: false,
        subscriptionType: 'free',
        createdAt: DateTime.now(),
      );
      
      final mockToken = 'social_token_${DateTime.now().millisecondsSinceEpoch}';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTokenKey, mockToken);
      await prefs.setString(AppConstants.userInfoKey, mockUser.toJson().toString());
      
      state = state.copyWith(
        isAuthenticated: true,
        user: mockUser,
        token: mockToken,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 重置密码
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 模拟发送重置密码邮件
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 更新用户资料
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      if (state.user != null) {
        final response = await _authService.updateProfile({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        });
        
        if (response.success && response.data != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConstants.userInfoKey, response.data!.toJson().toString());
          
          state = state.copyWith(
            user: response.data,
            isLoading: false,
          );
          
          return true;
        } else {
          state = state.copyWith(
            isLoading: false,
            error: response.message,
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 更改密码
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _authService.changePassword({
        'old_password': oldPassword,
        'new_password': newPassword,
      });
      
      if (response.success) {
        state = state.copyWith(isLoading: false);
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

  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 提供者
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceClient.instance;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
