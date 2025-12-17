import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/user.dart';
import '../core/routes/app_routes.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../services/snackbar.service.dart';
import 'user.controller.dart';
import '../core/utils/validators.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient;
  final SecureStorageService _storage;

  AuthController({ApiClient? apiClient, SecureStorageService? storage})
    : _apiClient = apiClient ?? ApiClient(),
      _storage = storage ?? SecureStorageService();

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
    try {
      if (_storage.isLoggedIn() && await _storage.hasAuthToken()) {
        final userData = await _storage.getUserData();
        if (userData != null) {
          try {
            currentUser.value = User.fromJson(userData);
          } catch (e) {
            await _storage.clearAuthData();
          }
        }
      }
    } catch (e) {
      // Ignore auth check errors
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
          final existingData = await _storage.getUserData();
          await _storage.saveUserData({...?existingData, 'phone': phone});
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
    required String fullName,
    required String phone,
  }) async {
    try {
      print('DEBUG: createUser called with name: $fullName, phone: $phone');
      isLoading.value = true;
      final response = await _apiClient.post(
        ApiConfig.createUser,
        data: {'fullName': fullName, 'phone': phone},
      );

      print('DEBUG: createUser response status: ${response.statusCode}');
      print('DEBUG: createUser response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final message = data['message'] ?? '';

        if (message.contains('already exist')) {
          SnackbarService.showWarning(
            'User already exists. Please login to continue',
          );
          return false;
        }

        final userData = data['data']?['user'];
        if (userData != null) {
          final userId = userData['_id'];
          await _storage.saveUserData({
            'userId': userId,
            'fullName': fullName,
            'phone': phone,
            'tempUser': true,
          });
          SnackbarService.showSuccess('OTP sent successfully!');
          return true;
        }

        SnackbarService.showError(
          'Failed to create account. Please try again.',
        );
        return false;
      } else {
        SnackbarService.showError('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp({
    required String userId,
    required String pan,
    required String dob,
    required String aadhaarNumber,
    String userType = 'user',
  }) async {
    try {
      isLoading.value = true;

      final aadhaarInt = int.tryParse(Validators.cleanAadhar(aadhaarNumber));
      if (aadhaarInt == null) {
        SnackbarService.showError('Invalid Aadhaar number');
        return false;
      }

      final response = await _apiClient.put(
        ApiConfig.signUp(userId),
        data: {
          'pan': Validators.formatPAN(pan),
          'dob': Validators.normalizeDob(dob),
          'aadhaarNumber': aadhaarInt,
          'userType': userType,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final message = data['message'] ?? '';

        if (message.contains('signed up successfully')) {
          final userData = data['data']?['existUser'];
          if (userData != null) {
            final phone = userData['phone'];
            if (phone != null) {
              await _storage.saveUserData({
                'userId': userId,
                'phone': phone,
                'userObject': userData['userObject'],
                'tempUser': true,
              });
            }
            SnackbarService.showSuccess('KYC completed successfully');
            return true;
          }
        }

        SnackbarService.showError('Signup failed');
        return false;
      }
      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      final msg = error.message.toLowerCase();

      if (msg.contains('invalid pan') || msg.contains('invalid dob')) {
        SnackbarService.showError(
          'Invalid PAN or Date of Birth. Please check and try again.',
        );
      } else if (msg.contains('no phone number')) {
        SnackbarService.showError(
          'No phone number found in KYC records. Please contact support.',
        );
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

        if (token != null && userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;

          await _storage.saveAuthToken(token);
          await _storage.saveUserId(user.id);
          await _storage.saveUserData(userData);
          await _storage.setLoggedIn(true);

          if (Get.isRegistered<UserController>()) {
            final userController = Get.find<UserController>();
            userController.currentUser.value = user;

            userController.loadUserData();
          } else {
            Get.put(UserController()).currentUser.value = user;
          }
        }
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

  Future<bool> hasActiveSubscription({bool forceRefresh = false}) async {
    try {
      final cached = forceRefresh
          ? null
          : await _storage.getCachedSubscriptionStatus();

      if (cached == true && !forceRefresh) {
        return true;
      }

      final userId = await _storage.getUserId();

      if (userId == null) {
        if (currentUser.value?.id != null && currentUser.value!.id.isNotEmpty) {
          // Use currentUser.id as fallback
        } else {
          return false;
        }
      }

      final idToUse = userId ?? currentUser.value!.id;
      final response = await _apiClient.get(ApiConfig.getUserPlan(idToUse));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final planData = data?['activePlan'];

        bool planIsActive(Map<String, dynamic>? planJson) {
          if (planJson == null) {
            return false;
          }

          final rawStatus = planJson['status'].toString().toLowerCase();
          final isActiveFlag = rawStatus == 'active';
          final endDateValue = planJson['endDate'] ?? planJson['expiryDate'];

          final expiry = endDateValue != null
              ? DateTime.tryParse(endDateValue.toString())
              : null;

          final isNotExpired = expiry == null || expiry.isAfter(DateTime.now());

          return isActiveFlag && isNotExpired;
        }

        if (planIsActive(planData)) {
          await _storage.cacheSubscriptionStatus(true);
          return true;
        }

        await _storage.cacheSubscriptionStatus(false);
        return false;
      }

      return cached ?? false;
    } catch (e) {
      final cached = await _storage.getCachedSubscriptionStatus();
      return cached ?? false;
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
      Get.offAllNamed(AppRoutes.getStarted);
    } catch (e) {
      await _storage.clearAuthData();
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.getStarted);
    } finally {
      isLoading.value = false;
    }
  }

  /*
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
  */

  void resetOtpState() {
    isOtpSent.value = false;
  }
}
