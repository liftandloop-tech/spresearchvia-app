import 'package:get/get.dart';
import 'package:spresearchvia/screens/kyc/sebi_compilance_check.dart';
import 'package:spresearchvia/screens/renewal/quick_renewal.screen.dart';
import 'package:spresearchvia/screens/subscription/registration.screen.dart';
import 'package:spresearchvia/screens/subscription/select_segment.screen.dart';
import 'package:spresearchvia/controllers/segment_plan.controller.dart';
import '../../screens/subscription/receipt.screen.dart';
import '../../screens/subscription/confirm_payment.screen.dart';
import '../../screens/auth/get_started.dart';
import '../../screens/auth/create_account.screen.dart';
import '../../screens/auth/signup.screen.dart';
import '../../screens/splash/splash.screen.dart';
import '../../screens/auth/login.screen.dart';
import '../../screens/auth/otp_verification.screen.dart';
import '../../screens/auth/forgot_mpin.screen.dart';
import '../../screens/auth/set_mpin.screen.dart';
import '../../screens/tabs.screen.dart';
import '../../screens/dashboard/dashboard.screen.dart';
import '../../screens/profile/profile.screen.dart';
import '../../screens/profile/view_profile.screen.dart';
import '../../screens/research/research_reports.screen.dart';
import '../../screens/research/research_report_detail.screen.dart';
import '../../screens/subscription/choose_plan.screen.dart';
import '../../screens/subscription/subscription_history.screen.dart';
import '../../screens/notification/notification_settings.screen.dart';
import '../../screens/setting/settings.screen.dart';
import '../../screens/subscription/payment/payment_success.screen.dart';
import '../../screens/subscription/payment/payment_faliure.screen.dart';
import '../../screens/kyc/kyc_intro.dart';
import '../../screens/kyc/pan_verification_screen.dart';
import '../../screens/kyc/aadhar_verification_screen.dart';
import '../../screens/kyc/digio_connect_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String signup = '/signup';
  static const String otpVerification = '/otp-verification';
  static const String forgotMpin = '/forgot-mpin';
  static const String setMpin = '/set-mpin';
  static const String tabs = '/tabs';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String researchReports = '/research-reports';
  static const String researchReportDetail = '/research-report-detail';
  static const String choosePlan = '/choose-plan';
  static const String subscriptionHistory = '/subscription-history';
  static const String subscriptionQuickRenewal = '/subscription-quick-renewal';
  static const String selectSegment = '/select-segment';
  static const String notificationSettings = '/notification-settings';
  static const String receipt = '/receipt';
  static const String confirmPayment = '/confirm-payment';
  static const String quickRenewal = "/quick-renewal";
  static const String settings = '/settings';
  static const String paymentSuccess = '/payment-success';
  static const String paymentFailure = '/payment-failure';
  static const String kycIntro = '/kyc-intro';
  static const String panVerification = '/pan-verification';
  static const String aadharVerification = '/aadhar-verification';
  static const String digioConnect = '/digio-connect';
  static const String registrationScreen = '/registration';
  static const String sebiCompilanceCheck = '/sebi-compilance-check';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: getStarted, page: () => const GetStartedScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: createAccount, page: () => const CreateAccountScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: otpVerification, page: () => const OtpVerificationScreen()),
    GetPage(name: forgotMpin, page: () => const ForgotMpinScreen()),
    GetPage(name: setMpin, page: () => const SetMpinScreen()),
    GetPage(name: quickRenewal, page: () => const QuickRenewalScreen()),
    GetPage(name: tabs, page: () => const TabsScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => const ViewProfileScreen()),
    GetPage(name: researchReports, page: () => const ResearchReportsScreen()),
    GetPage(name: sebiCompilanceCheck, page: () => const SebiComplianceCheck()),
    GetPage(
      name: researchReportDetail,
      page: () => ResearchReportDetailScreen(report: Get.arguments),
    ),
    GetPage(name: choosePlan, page: () => const ChoosePlanScreen()),
    GetPage(
      name: subscriptionHistory,
      page: () => const SubscriptionHistoryScreen(),
    ),
    GetPage(
      name: selectSegment,
      page: () => SelectSegmentScreen(),
      binding: BindingsBuilder(() {
        Get.put(SegmentPlanController());
      }),
    ),
    GetPage(
      name: notificationSettings,
      page: () => const NotificationSettingScreen(),
    ),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: paymentSuccess, page: () => const PaymentSuccessScreen()),
    GetPage(name: paymentFailure, page: () => const PaymentFaliureScreen()),
    GetPage(name: kycIntro, page: () => const KycIntroScreen()),
    GetPage(name: panVerification, page: () => const PanVerificationScreen()),
    GetPage(
      name: aadharVerification,
      page: () => const AadharVerificationScreen(),
    ),
    GetPage(name: digioConnect, page: () => const DigioConnectScreen()),
    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),
    GetPage(name: receipt, page: () => const ReceiptScreen()),
    GetPage(name: confirmPayment, page: () => const ConfirmPaymentScreen()),
  ];
}
