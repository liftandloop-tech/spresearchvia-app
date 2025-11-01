import 'package:get/get.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';

import 'package:spresearchvia2/controllers/user.controller.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

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
        '/user/send-otp',
        data: {'phone': phone},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isOtpSent.value = true;
        Get.snackbar(
          'Success',
          'OTP sent successfully to $phone',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      print(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/verify-otp',
        data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
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
          // Sync the global UserController so Profile screen sees the user immediately
          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.currentUser.value = user;
          }
          // Force UserController to reload all user data for dashboard/profile
          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.loadUserData();
          }
        }

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
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
        '/user/create-user',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final userData = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (userData != null) {
          final user = User.fromJson(userData);
          await _storage.saveUserId(user.id);
        }

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/login',
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
          // Sync UserController as well
          if (Get.isRegistered<UserController>()) {
            final uc = Get.find<UserController>();
            uc.currentUser.value = user;
          }
        }

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _apiClient.post('/user/logout');

      await _storage.clearAuthData();
      currentUser.value = null;
      isOtpSent.value = false;

      // Clear UserController if registered
      if (Get.isRegistered<UserController>()) {
        final uc = Get.find<UserController>();
        uc.currentUser.value = null;
      }

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to login screen after logout
      Get.offAllNamed('/login');
    } catch (e) {
      await _storage.clearAuthData();
      currentUser.value = null;
      isOtpSent.value = false;

      // Clear UserController if registered
      if (Get.isRegistered<UserController>()) {
        final uc = Get.find<UserController>();
        uc.currentUser.value = null;
      }

      // Navigate to login screen even if logout API fails
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/forget-password',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Password reset link sent to your email',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/reset-password/$token',
        data: {'password': newPassword},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Password reset successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetOtpState() {
    isOtpSent.value = false;
  }
}
