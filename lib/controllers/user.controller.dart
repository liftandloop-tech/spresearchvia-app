import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';

/// Controller for user profile operations
/// Handles profile updates, image changes, and user data management
class UserController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  // Observable variables
  final isLoading = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load user data from storage
  void loadUserData() {
    final userData = _storage.getUserData();
    if (userData != null) {
      currentUser.value = User.fromJson(userData);
    }
  }

  /// Get current user ID
  String? get userId => _storage.getUserId();

  /// Update user profile
  Future<bool> updateProfile({
    PersonalInformation? personalInformation,
    AddressDetails? addressDetails,
    ContactDetails? contactDetails,
  }) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      isLoading.value = true;

      final requestData = <String, dynamic>{};

      if (personalInformation != null) {
        requestData['personalInformation'] = personalInformation.toJson();
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

        Get.snackbar(
          'Success',
          'Profile updated successfully',
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

  /// Change profile image
  Future<bool> changeProfileImage(File imageFile) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      isLoading.value = true;

      // Create form data
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiClient.uploadFile(
        '/user/image-change/$uid',
        formData: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final imageUrl = data['imageUrl'] ?? data['data']?['imageUrl'];

        if (imageUrl != null && currentUser.value != null) {
          currentUser.value = currentUser.value!.copyWith(
            profileImage: imageUrl,
          );

          // Update storage
          final userData = currentUser.value!.toJson();
          await _storage.saveUserData(userData);
        }

        Get.snackbar(
          'Success',
          'Profile image updated successfully',
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

  /// Get user list (admin functionality)
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
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user (admin functionality)
  Future<bool> deleteUser(String userIdToDelete) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.delete(
        '/user/delete-user/$userIdToDelete',
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'User deleted successfully',
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

  /// Refresh user data from server
  Future<void> refreshUserData() async {
    loadUserData();
  }
}
