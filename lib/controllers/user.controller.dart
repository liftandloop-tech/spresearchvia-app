import 'dart:io';
import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/user.dart';
import '../core/utils/file_validator.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../core/utils/error_message_handler.dart';
import '../services/snackbar.service.dart';

class UserController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  final isLoading = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    try {
      final userData = await _storage.getUserData();

      if (userData != null && userData.isNotEmpty) {
        if (userData.containsKey('tempUser')) {
          currentUser.value = null;
          return;
        }
        currentUser.value = User.fromJson(userData);
      } else {}
    } catch (e) {
      currentUser.value = null;
    }
  }

  Future<String?> get userId => _storage.getUserId();

  Future<bool> updateProfile({
    PersonalInformation? personalInformation,
    AddressDetails? addressDetails,
    ContactDetails? contactDetails,
  }) async {
    try {
      final uid = await userId;
      if (uid == null) {
        SnackbarService.showWarning('User not logged in');
        return false;
      }

      isLoading.value = true;

      final requestData = <String, dynamic>{};

      if (personalInformation != null) {
        requestData['personalInformation'] = personalInformation.toJson();

        requestData['fullName'] = personalInformation.fullName;
      }
      if (addressDetails != null) {
        requestData['addressDetails'] = addressDetails.toJson();
      }
      if (contactDetails != null) {
        requestData['contactDetails'] = contactDetails.toJson();
      }

      SnackbarService.showError(
        'Profile update is temporarily unavailable. Please contact support.',
      );
      isLoading.value = false;
      return false;

      /* DISABLED - Backend route commented out
      final response = await _apiClient.put(
        ApiConfig.updateProfile(uid),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userData = data['data']?['user'] ?? data['user'];

        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserData(userData);
        }

        SnackbarService.showSuccess('Profile updated successfully');
        return true;
      }

      return false;
      */
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changeProfileImage(File imageFile) async {
    try {
      final uid = await userId;
      if (uid == null) {
        SnackbarService.showWarning('User not logged in');
        return false;
      }

      final validationError = FileValidator.validateImageFile(imageFile);
      if (validationError != null) {
        SnackbarService.showWarning(validationError);
        return false;
      }

      SnackbarService.showError(
        'Profile image change is temporarily unavailable. Please contact support.',
      );
      return false;

      /* DISABLED - Backend route commented out
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: path.basename(imageFile.path),
        ),
      });

      final response = await _apiClient.patch(
        ApiConfig.changeImage(uid),
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final files = data['data']?['files'];

        if (files != null && currentUser.value != null) {
          final filePath = files['filesObj']?['path'];
          if (filePath != null) {
            String fullImageUrl = filePath;
            if (!filePath.startsWith('http')) {
              final baseUrl = _apiClient.dio.options.baseUrl.replaceAll(
                '/api',
                '',
              );
              fullImageUrl = '$baseUrl/$filePath';
            }

            currentUser.value = currentUser.value!.copyWith(
              profileImage: fullImageUrl,
            );

            final userData = currentUser.value!.toJson();
            await _storage.saveUserData(userData);
          }
        }

        SnackbarService.showSuccess('Profile image updated successfully');
        return true;
      }

      return false;
      */
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Change Profile Image', error);
      SnackbarService.showError(
        ErrorMessageHandler.getUserFriendlyMessage(error),
      );
      return false;
    } finally {}
  }

  Future<List<User>?> getUserList() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get(ApiConfig.userList);

      if (response.statusCode == 200) {
        final data = response.data;
        final userList = data['data'] ?? data['users'] ?? [];

        return (userList as List).map((json) => User.fromJson(json)).toList();
      }

      return null;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Get User List', error);
      SnackbarService.showError(
        ErrorMessageHandler.getUserFriendlyMessage(error),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteUser(String userIdToDelete) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.delete(
        ApiConfig.deleteUser(userIdToDelete),
      );

      if (response.statusCode == 200) {
        SnackbarService.showSuccess('User deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Delete User', error);
      SnackbarService.showError(
        ErrorMessageHandler.getUserFriendlyMessage(error),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    try {
      final uid = await userId;
      if (uid == null) return;

      loadUserData();

      /* DISABLED - No backend route available
      final response = await _apiClient.get(ApiConfig.getUserById(uid));

      if (response.statusCode == 200) {
        final data = response.data;
        final userData = data['data']?['user'] ?? data['user'];

        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserData(userData);
        }
      }
      */
    } catch (e) {
      loadUserData();
    }
  }
}
