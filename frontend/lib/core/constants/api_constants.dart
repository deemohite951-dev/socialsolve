class ApiConstants {
  // Use http://10.0.2.2:8000 for Android Emulator, http://127.0.0.1:8000 for Web/Desktop/iOS Sim
  static const String baseUrl = 'https://socialsolve-xxxx.onrender.com/api'; 
  // static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String currentUser = '$baseUrl/auth/me/';
  static const String issues = '$baseUrl/issues/';
  static const String issueStats = '$baseUrl/issues/stats/';
}