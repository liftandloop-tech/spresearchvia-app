import 'app.config.dart';

abstract class ApiConfig {
  static String get baseUrl => AppConfig.baseUrl;

  static const String createUser = '/user/create-user';
  static const String sendOtp = '/user/send-otp';
  static const String verifyOtp = '/user/verify-otp';
  static const String setMpin = '/user/set-mpin';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static String forgotPassword(String email) =>
      '/user/forget-password?email=$email';
  static String resetPassword(String token) => '/user/reset-password/$token';

  static String updateProfile(String userId) => '/user/update/$userId';
  static String changeImage(String userId) => '/user/image-change/$userId';
  static const String userList = '/user/user-list';
  static String deleteUser(String userId) => '/user/delete-user/$userId';

  static String uploadAadhar(String userId) =>
      '/user/kyc/aadhaar-upload/$userId';
  static String uploadPancard(String userId) =>
      '/user/kyc/pancard-upload/$userId';
  static String documentKYC(String userId) => '/user/kyc/document-kyc/$userId';

  static String purchasePlan(String userId) => '/user/purchase/plan/$userId';
  static const String verifyPayment = '/user/purchase/razorpay/verify';
  static String getUserPlan(String userId) =>
      '/user/purchase/user-plan/$userId';
  static String toggleExpiryReminders(String userId) =>
      '/user/purchase/expiry-reminders/$userId';

  static const String createReport = '/reports/create-report';
  static const String reportList = '/reports/report-list';
  static String downloadReport(String reportId) =>
      '/reports/download-report/$reportId';

  
  static String reportListWithFilters({
    String? category,
    String search = '',
    String? date,
  }) {
    final buffer = StringBuffer('/reports/report-list?');
    if (category != null && category.isNotEmpty)
      buffer.write('category=$category&');
    buffer.write('search=${Uri.encodeComponent(search)}&');
    if (date != null && date.isNotEmpty)
      buffer.write('date=${Uri.encodeComponent(date)}');
    return buffer.toString();
  }
}