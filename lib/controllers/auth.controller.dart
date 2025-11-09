import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/config/api.config.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';

import 'package:spresearchvia2/controllers/user.controller.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  final isFetchingPhoneNumber = false.obs;
  final isLoading = false.obs;
  final isOtpSent = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    if (_storage.isLoggedIn() && _storage.hasAuthToken()) {
      final userData = _storage.getUserData();
      if (userData != null) {
        currentUser.value = User.fromJson(userData);
      }
    }
  }

  Future<bool> sendOtp(String phone) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.post(
        ApiConfig.requestOTP,
        data: {'phone': phone},
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isOtpSent.value = true;
        SnackbarService.showSuccess('OTP sent successfully to $phone');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);

      String errorMessage = error.message;
      if (errorMessage.toLowerCase().contains('timeout')) {
        errorMessage =
            'Request timed out. Please check your internet connection and try again.';
      }

      SnackbarService.showError(errorMessage);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.verifyOTP,
        data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final token = data['token'] ?? data['data']?['token'];
        final userData = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (token != null) {
          await _storage.saveAuthToken(token);
        }

        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserId(user.id);
          await _storage.saveUserData(userData);
          await _storage.setLoggedIn(true);

          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.currentUser.value = user;
          }

          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.loadUserData();
          }
        }

        SnackbarService.showSuccess('Login successful!');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);

      String errorMessage = error.message;
      if (errorMessage.toLowerCase().contains('timeout')) {
        errorMessage =
            'Request timed out. Please check your internet connection and try again.';
      }

      SnackbarService.showError(errorMessage);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createUser({
    required String fullName,
    required String email,
    required String phone,
    required bool termsCondition,
    PersonalInformation? personalInformation,
    AddressDetails? addressDetails,
  }) async {
    try {
      isLoading.value = true;

      final requestData = {
        'fullName': fullName,
        'contactDetails': {'email': email, 'phone': phone},
        'userType': 'user',
        'termsCondition': termsCondition ? 'yes' : 'no',
      };

      if (personalInformation != null) {
        requestData['personalInformation'] = personalInformation.toJson();
      }
      if (addressDetails != null) {
        requestData['addressDetails'] = addressDetails.toJson();
      }

      final response = await _apiClient.post(
        ApiConfig.createUser,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final userData = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (userData != null) {
          final user = User.fromJson(userData);
          await _storage.saveUserId(user.id);
        }

        SnackbarService.showSuccess('Account created successfully!');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.loginUser,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final token = data['token'] ?? data['data']?['token'];
        final userData = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (token != null) {
          await _storage.saveAuthToken(token);
        }

        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserId(user.id);
          await _storage.saveUserData(userData);
          await _storage.setLoggedIn(true);

          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.currentUser.value = user;
          }
        }

        SnackbarService.showSuccess('Login successful!');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _apiClient.post(ApiConfig.logoutUser);

      await _storage.clearAuthData();
      currentUser.value = null;
      isOtpSent.value = false;

      if (Get.isRegistered<UserController>()) {
        final uc = Get.find<UserController>();
        uc.currentUser.value = null;
      }

      SnackbarService.showSuccess('Logged out successfully');

      Get.offAllNamed('/login');
    } catch (e) {
      await _storage.clearAuthData();
      currentUser.value = null;
      isOtpSent.value = false;

      if (Get.isRegistered<UserController>()) {
        final uc = Get.find<UserController>();
        uc.currentUser.value = null;
      }

      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(ApiConfig.forgotPassword(email));

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarService.showSuccess('Password reset link sent to your email');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.resetPassword(token),
        data: {'password': newPassword},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarService.showSuccess('Password reset successfully');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPhoneNumber(String pan, String aadhar) async {
    isFetchingPhoneNumber.value = true;
    Future.delayed(Duration(seconds: 2));

    isFetchingPhoneNumber.value = false;
  }

  void resetOtpState() {
    isOtpSent.value = false;
  }
}
