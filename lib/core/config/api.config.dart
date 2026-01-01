import 'app.config.dart';

abstract class ApiConfig {
  static String get baseUrl => AppConfig.baseUrl;

  static const String createUser = '/user/create-user';
  static String signUp(String userId) => '/user/sign-up?userId=$userId';
  static const String sendOtp = '/user/send-otp';
  static const String verifyOtp = '/user/verify-otp';
  static const String setMpin = '/user/set-mpin';
  static const String login = '/user/login';
  static const String logout = '/user/logout';

  static const String userList = '/user/user-list';
  static String deleteUser(String userId) => '/user/delete-user/$userId';
  static String uploadProfileImage(String userId) =>
      '/user/image-change/$userId';

  static String uploadAadhar(String userId) =>
      '/user/kyc/aadhaar-upload/$userId';
  static String uploadPancard(String userId) =>
      '/user/kyc/pancard-upload/$userId';
  static String documentKYC(String userId) => '/user/kyc/document-kyc/$userId';

  static String purchasePlan(String userId) => '/user/purchase/plan/$userId';
  static const String verifyPayment = '/user/purchase/razorpay/verify';

  static const String segmentPurchase = '/serments/segment-purchase';
  static const String segmentPaymentVerify = '/serments/segment-payment-verify';
  static const String createSegments = '/serments/create-segments';
  static const String updateSegments = '/serments/update-segments';
  static const String deleteSegments = '/serments/delete-segments';
  static const String listSegments = '/serments/list-segments';
  static String segmentPaymentHistory(String userId) =>
      '/serments/segment-payment-history/$userId';
  static String getUserActiveSegment(String userId) =>
      '/serments/user-active-segment?userId=$userId';

  static String getUserPlan(String userId) =>
      '/user/purchase/user-active-plan/$userId';
  static String userSubscriptionHistory(String userId) =>
      '/user/purchase/user-subscription-history/$userId';
  static String toggleExpiryReminders(String userId) =>
      '/user/purchase/expiry-reminders/$userId';

  static const String createReport = '/reports/create-report';

  static String reportList({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String? startDate,
    String? endDate,
  }) {
    final buffer = StringBuffer(
      '/reports/report-list?page=$page&pageSize=$pageSize',
    );
    if (search.isNotEmpty) {
      buffer.write('&search=${Uri.encodeComponent(search)}');
    }
    if (startDate != null && startDate.isNotEmpty) {
      buffer.write('&startDate=${Uri.encodeComponent(startDate)}');
    }
    if (endDate != null && endDate.isNotEmpty) {
      buffer.write('&endDate=${Uri.encodeComponent(endDate)}');
    }
    return buffer.toString();
  }

  static String userReportList(
    String userId, {
    String reportType = 'Trading calls',
    int page = 1,
    int pageSize = 10,
  }) =>
      '/reports/user-report-list/$userId?reportType=${Uri.encodeComponent(reportType)}&page=$page&pageSize=$pageSize';

  static String downloadReport(String reportId) =>
      '/reports/download-report/$reportId';
  static String deleteReport(String reportId) =>
      '/reports/report-delete/$reportId';
  static const String reportPublicStatusChange =
      '/reports/report-public-status-change';
}
