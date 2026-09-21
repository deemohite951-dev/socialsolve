import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response.data['access']);
        await prefs.setString('refresh_token', response.data['refresh']);
        await prefs.setString('user_data', jsonEncode(response.data['user']));
        return UserModel.fromJson(response.data['user']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to log in');
    }
    return null;
  }

  Future<void> register(String username, String email, String password) async {
    try {
      await _client.dio.post(
        ApiConstants.register,
        data: {'username': username, 'email': email, 'password': password},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Registration failed');
    }
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}