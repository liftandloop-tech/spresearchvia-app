abstract class ApiConfig {
  static const String baseUrl = 'https://spresearchviaapp.koyeb.app/api';

  static const String createUser = '/user/create-user';
  static const String loginUser = '/user/login';
  static const String logoutUser = '/user/logout';
  static const String verifyOTP = '/user/verify-otp';
  static const String requestOTP = '/user/send-otp';
  static String forgotPassword(String email) =>
      '/user/forget-password?email=$email';
  static String resetPassword(String token) => '/user/reset-password/$token';

  static String updateProfile(String userId) => '/user/update/$userId';
  static const String changeImage = '/user/image-change';
  static const String userList = '/user/user-list';
  static String deleteUser(String userId) => '/user/delete/$userId';

  static String uploadAadhar(String userId) =>
      '/user/kyc/aadhaar-upload/$userId?type=aadhaar';
  static String uploadPancard(String userId) =>
      '/user/kyc/pancard-upload/$userId?type=pancard';
  static String documentKYC(String userId) => '/user/kyc/document-kyc/$userId';

  static String purchasePlan(String userId) => '/user/purchase/plan/$userId';
  static const String verifyPayment = '/user/purchase/razorpay/verify';
  static String getUserPlan(String userId) =>
      '/user/purchase/user-plan/$userId';
  static String toggleExpiryReminders(String userId) =>
      '/user/purchase/expiry-reminders/$userId';

  static const String createPackage = '/user/plan/package-create';

  static const String createReport = '/reports/create-report?type=report';
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
