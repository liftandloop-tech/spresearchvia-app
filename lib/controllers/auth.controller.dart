import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/user.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../services/snackbar.service.dart';
import 'user.controller.dart';
import '../core/utils/validators.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

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
    if (_storage.isLoggedIn() && await _storage.hasAuthToken()) {
      final userData = await _storage.getUserData();
      if (userData != null) {
        currentUser.value = User.fromJson(userData);
      }
    }
  }

  Future<bool> sendOtp(String phone) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.sendOtp,
        data: {'phone': phone},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'User not exist') {
          SnackbarService.showError('User not found. Please sign up first.');
          return false;
        }
        isOtpSent.value = true;
        SnackbarService.showSuccess('OTP sent to your phone');
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

  Future<bool> verifyOtp(String otp) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.verifyOtp,
        data: {'otp': int.tryParse(otp) ?? otp},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'User not exist' ||
            data['message'] == 'OTP Invalid') {
          SnackbarService.showError(data['message']);
          return false;
        }
        final phone = data['data']?['phone'];
        if (phone != null) {
          await _storage.saveUserData({'phone': phone});
        }
        SnackbarService.showSuccess('OTP verified successfully');
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

  Future<bool> createUser({
    required String pan,
    required String dob,
    required String aadhaarNumber,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.post(
        ApiConfig.createUser,
        data: {
          'pan': Validators.formatPAN(pan),
          'dob': Validators.normalizeDob(dob),
          'aadhaarNumber': Validators.cleanAadhar(aadhaarNumber),
          'userType': 'user',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final message = data['message'] ?? '';
        
        if (message == 'user already exist') {
          SnackbarService.showError('User already exists');
          return false;
        }
        
        final userData = data['data']?['user'];
        if (userData != null) {
          // Don't save to storage yet - only save phone for OTP verification
          final phone = userData['userObject']?['APP_MOB_NO'];
          if (phone != null) {
            await _storage.saveUserData({'phone': phone, 'tempUser': userData});
          }
          SnackbarService.showSuccess('OTP sent to your phone');
          return true;
        }
        
        SnackbarService.showError('Failed to create user');
        return false;
      }
      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      final msg = error.message.toLowerCase();
      
      if (msg.contains('invalid pan') || msg.contains('invalid dob')) {
        SnackbarService.showError('Invalid PAN or Date of Birth. Please check and try again.');
      } else if (msg.contains('no phone number')) {
        SnackbarService.showError('No phone number found in KYC records. Please contact support.');
      } else if (error.statusCode == 403 || msg.contains('token')) {
        SnackbarService.showError('KYC service temporarily unavailable. Please try again later.');
      } else {
        SnackbarService.showError(error.message);
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    String? email,
    String? phone,
    required String mPin,
  }) async {
    try {
      isLoading.value = true;

      final requestData = {'mPin': int.tryParse(mPin) ?? mPin};
      if (email != null) requestData['email'] = email;
      if (phone != null) requestData['phone'] = phone;

      final response = await _apiClient.post(
        ApiConfig.login,
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'Invalid credentials') {
          SnackbarService.showError('Invalid credentials');
          return false;
        }
        final token = data['data']?['token'];
        final userData = data['data']?['user'];

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
            Get.find<UserController>().currentUser.value = user;
          } else {
            Get.put(UserController()).currentUser.value = user;
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

  Future<bool> setMpin(String phone, String mPin) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.post(
        ApiConfig.setMpin,
        data: {'phone': phone, 'mPin': int.tryParse(mPin) ?? mPin},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] == 'User not exist') {
          SnackbarService.showError('User not found');
          return false;
        }
        final token = data['data']?['token'];
        final userData = data['data']?['user'];

        if (token != null) {
          await _storage.saveAuthToken(token);
        }
        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserId(user.id);
          // Clear temp data and save actual user data
          await _storage.clearAuthData();
          await _storage.saveAuthToken(token!);
          await _storage.saveUserData(userData);
          await _storage.setLoggedIn(true);

          if (Get.isRegistered<UserController>()) {
            Get.find<UserController>().currentUser.value = user;
          } else {
            Get.put(UserController()).currentUser.value = user;
          }
        }
        SnackbarService.showSuccess('MPIN set successfully');
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
      await _apiClient.post(ApiConfig.logout);
      await _storage.clearAuthData();
      currentUser.value = null;
      isOtpSent.value = false;

      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().currentUser.value = null;
      }
      SnackbarService.showSuccess('Logged out successfully');
      Get.offAllNamed('/get-started');
    } catch (e) {
      await _storage.clearAuthData();
      currentUser.value = null;
      Get.offAllNamed('/get-started');
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

  void resetOtpState() {
    isOtpSent.value = false;
  }
}
