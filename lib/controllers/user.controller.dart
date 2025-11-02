import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/core/utils/file_validator.dart';
import 'package:path/path.dart' as path;
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';
import 'package:spresearchvia2/core/utils/error_message_handler.dart';
import 'package:spresearchvia2/core/utils/custom_snackbar.dart';

class UserController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  final isLoading = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = _storage.getUserData();
    if (userData != null) {
      currentUser.value = User.fromJson(userData);
    }
  }

  String? get userId => _storage.getUserId();

  Future<bool> updateProfile({
    PersonalInformation? personalInformation,
    AddressDetails? addressDetails,
    ContactDetails? contactDetails,
  }) async {
    try {
      final uid = userId;
      if (uid == null) {
        CustomSnackbar.showWarning('User not logged in');
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

      final response = await _apiClient.put(
        '/user/update/$uid',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final userData = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (userData != null) {
          final user = User.fromJson(userData);
          currentUser.value = user;
          await _storage.saveUserData(userData);
        }

        CustomSnackbar.showSuccess('Profile updated successfully');
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

  Future<bool> changeProfileImage(File imageFile) async {
    try {
      final uid = userId;
      if (uid == null) {
        CustomSnackbar.showWarning('User not logged in');
        return false;
      }

      final validationError = FileValidator.validateImageFile(imageFile);
      if (validationError != null) {
        CustomSnackbar.showWarning(validationError);
        return false;
      }

      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: path.basename(imageFile.path),
        ),
      });

      final response = await _apiClient.patch(
        '/user/image-change/$uid',
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final imageUrl =
            data['imageUrl'] ??
            data['data']?['imageUrl'] ??
            data['data']?['files']?.filesObj?.path;

        if (imageUrl != null && currentUser.value != null) {
          String fullImageUrl = imageUrl;
          if (!imageUrl.startsWith('http')) {
            final baseUrl = _apiClient.dio.options.baseUrl;
            fullImageUrl = '$baseUrl$imageUrl';
          }

          currentUser.value = currentUser.value!.copyWith(
            profileImage: fullImageUrl,
          );

          final userData = currentUser.value!.toJson();
          await _storage.saveUserData(userData);
        }

        CustomSnackbar.showSuccess('Profile image updated successfully');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Change Profile Image', error);
      CustomSnackbar.showError(
        ErrorMessageHandler.getUserFriendlyMessage(error),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<User>?> getUserList() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/user/user-list');

      if (response.statusCode == 200) {
        final data = response.data;
        final userList = data['data'] ?? data['users'] ?? [];

        return (userList as List).map((json) => User.fromJson(json)).toList();
      }

      return null;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Get User List', error);
      CustomSnackbar.showError(
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
        '/user/delete-user/$userIdToDelete',
      );

      if (response.statusCode == 200) {
        CustomSnackbar.showSuccess('User deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      ErrorMessageHandler.logError('Delete User', error);
      CustomSnackbar.showError(
        ErrorMessageHandler.getUserFriendlyMessage(error),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    loadUserData();
  }
}
