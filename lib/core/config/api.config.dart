abstract class ApiConfig {
  static const String baseUrl = 'https://spresearchviaapp.koyeb.app/api';

  static const String createUser = '$baseUrl/user/create-user';
  static const String loginUser = '$baseUrl/user/login';
  static const String changeImage = '$baseUrl/user/image-change';
  static String resetPassword(String token) =>
      '$baseUrl/user/reset-password/$token';
  static String forgotPassword(String email) =>
      '$baseUrl/user/forget-password?email=$email';
  static const String logoutUser = '$baseUrl/user/logout';
  static String updateProfile(String userId) => '$baseUrl/user/update/$userId';

  static const String verifyOTP = '$baseUrl/user/verify-otp';
  static const String requestOTP = '$baseUrl/user/send-otp';

  static String uploadAadhar(String userId) =>
      '$baseUrl/user/kyc/aadhaar-upload/$userId?type=aadhaar';
  static String uploadPancard(String userId) =>
      '$baseUrl/user/kyc/pancard-upload/$userId?type=pancard';
  static String documentKYC(String userId) =>
      '$baseUrl/user/kyc/document-kyc/$userId';

  static const String purchasePlan = '$baseUrl/user/purchase/plan';
  static const String createPackage = '$baseUrl/user/plan/package-create';

  static const String createReport =
      '$baseUrl/reports/create-report?type=report';
  static String downloadReport(String reportId) =>
      '$baseUrl/reports/download-report/$reportId';
  static String reportList({
    String? category,
    String search = '',
    String? date,
  }) {
    final buffer = StringBuffer('$baseUrl/reports/report-list?');
    if (category != null && category.isNotEmpty)
      buffer.write('category=$category&');
    buffer.write('search=${Uri.encodeComponent(search)}&');
    if (date != null && date.isNotEmpty)
      buffer.write('date=${Uri.encodeComponent(date)}');
    return buffer.toString();
  }
}
