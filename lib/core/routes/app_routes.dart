import 'package:get/get.dart';
import 'package:spresearchvia2/screens/auth/otp_verification.screen.dart';
import 'package:spresearchvia2/screens/auth/forgot_mpin.screen.dart';
import 'package:spresearchvia2/screens/auth/set_mpin.screen.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/signup.screen.dart';
import '../../screens/splash/splash.screen.dart';
import '../../screens/auth/login.screen.dart';
import '../../screens/tabs.screen.dart';
import '../../screens/dashboard/dashboard.screen.dart';
import '../../screens/profile/profile.screen.dart';
import '../../screens/profile/edit_profile.screen.dart';
import '../../screens/research/research_reports.screen.dart';
import '../../screens/research/research_report_detail.screen.dart';
import '../../screens/subscription/choose_plan.screen.dart';
import '../../screens/subscription/premium.screen.dart';
import '../../screens/subscription/subscription_history.screen.dart';
import '../../screens/subscription/quick_renewal.screen.dart' as subscription;
import '../../screens/renewal/quick_renewal.screen.dart' as renewal;
import '../../screens/notification/notification_settings.screen.dart';
import '../../screens/setting/settings.screen.dart';
import '../../screens/payment/payment_success.screen.dart';
import '../../screens/payment/payment_faliure.screen.dart';
import '../../screens/kyc/kyc_intro.dart';
import '../../screens/kyc/pan_verification_screen.dart';
import '../../screens/kyc/aadhar_verification_screen.dart';
import '../../screens/kyc/digio_connect_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otpVerification = '/otp';
  static const String forgotMpin = '/forgot-mpin';
  static const String setMpin = '/set-mpin';
  static const String tabs = '/tabs';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String researchReports = '/research-reports';
  static const String researchReportDetail = '/research-report-detail';
  static const String choosePlan = '/choose-plan';
  static const String premium = '/premium';
  static const String subscriptionHistory = '/subscription-history';
  static const String subscriptionQuickRenewal = '/subscription-quick-renewal';
  static const String renewalQuickRenewal = '/renewal-quick-renewal';
  static const String notificationSettings = '/notification-settings';
  static const String settings = '/settings';
  static const String paymentSuccess = '/payment-success';
  static const String paymentFailure = '/payment-failure';
  static const String kycIntro = '/kyc-intro';
  static const String panVerification = '/pan-verification';
  static const String aadharVerification = '/aadhar-verification';
  static const String digioConnect = '/digio-connect';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: getStarted, page: () => const GetStartedScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: otpVerification, page: () => OTPVerificationScreen()),
    GetPage(name: forgotMpin, page: () => const ForgotMpinScreen()),
    GetPage(name: setMpin, page: () => const SetMpinScreen()),
    GetPage(name: tabs, page: () => const TabsScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfileScreen()),
    GetPage(name: researchReports, page: () => ResearchReportsScreen()),
    GetPage(
      name: researchReportDetail,
      page: () => ResearchReportDetailScreen(report: Get.arguments),
    ),
    GetPage(name: choosePlan, page: () => ChoosePlanScreen()),
    GetPage(name: premium, page: () => PremiumScreen()),
    GetPage(name: subscriptionHistory, page: () => SubscriptionHistoryScreen()),
    GetPage(
      name: subscriptionQuickRenewal,
      page: () => subscription.QuickRenewalScreen(),
    ),
    GetPage(
      name: renewalQuickRenewal,
      page: () => renewal.QuickRenewalScreen(),
    ),
    GetPage(
      name: notificationSettings,
      page: () => NotificationSettingScreen(),
    ),
    GetPage(name: settings, page: () => SettingsScreen()),
    GetPage(name: paymentSuccess, page: () => const PaymentSuccessScreen()),
    GetPage(name: paymentFailure, page: () => PaymentFaliureScreen()),
    GetPage(name: kycIntro, page: () => const KycIntroScreen()),
    GetPage(name: panVerification, page: () => const PanVerificationScreen()),
    GetPage(
      name: aadharVerification,
      page: () => const AadharVerificationScreen(),
    ),
    GetPage(name: digioConnect, page: () => const DigioConnectScreen()),
  ];
}
