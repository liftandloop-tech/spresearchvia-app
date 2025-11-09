import 'package:get/get.dart';
import 'package:spresearchvia2/screens/auth/widgets/account_type_toggle.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';

class SignupController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final phoneNumber = ''.obs;

  Future<String?> verifyPanAadhar({
    required String pan,
    required String aadhar,
    required AccountType accountType,
  }) async {
    try {
      isLoading.value = true;

      //

      await Future.delayed(Duration(seconds: 2));
      phoneNumber.value = '+91-9876543210';
      return phoneNumber.value;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> requestOtp(String phone) async {
    try {
      isLoading.value = true;

      //

      await Future.delayed(Duration(seconds: 1));
      SnackbarService.showSuccess('OTP sent successfully to $phone');
      return true;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      isLoading.value = true;

      //

      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeSignup({
    required String pan,
    required String aadhar,
    required String phone,
    required AccountType accountType,
  }) async {
    try {
      isLoading.value = true;

      //

      await Future.delayed(Duration(seconds: 1));
      SnackbarService.showSuccess('Account created successfully!');
      return true;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    phoneNumber.value = '';
    isLoading.value = false;
  }
}
