import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';

/// Controller for KYC operations
/// Handles document uploads and KYC verification
class KycController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  // Observable variables
  final isLoading = false.obs;
  final isAadharUploaded = false.obs;
  final isPanUploaded = false.obs;
  final isKycCompleted = false.obs;

  /// Get current user ID
  String? get userId => _storage.getUserId();

  /// Upload PAN card
  Future<bool> uploadPanCard({
    required File panFile,
    required String panNumber,
  }) async {
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
          panFile.path,
          filename: panFile.path.split('/').last,
        ),
        'panNumber': panNumber,
      });

      final response = await _apiClient.uploadFile(
        '/user/kyc/pancard-upload/$uid',
        formData: formData,
        queryParameters: {'type': 'pancard'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isPanUploaded.value = true;
        Get.snackbar(
          'Success',
          'PAN card uploaded successfully',
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

  /// Upload Aadhar card (front and back)
  Future<bool> uploadAadharCard({
    required File frontFile,
    required File backFile,
    required String aadharNumber,
  }) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      isLoading.value = true;

      // Create form data with multiple files
      final formData = dio.FormData.fromMap({
        'files': [
          await dio.MultipartFile.fromFile(
            frontFile.path,
            filename: 'aadhar_front_${frontFile.path.split('/').last}',
          ),
          await dio.MultipartFile.fromFile(
            backFile.path,
            filename: 'aadhar_back_${backFile.path.split('/').last}',
          ),
        ],
        'aadhaarNumber': aadharNumber,
      });

      final response = await _apiClient.uploadFile(
        '/user/kyc/aadhaar-upload/$uid',
        formData: formData,
        queryParameters: {'type': 'aadhaar'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isAadharUploaded.value = true;
        Get.snackbar(
          'Success',
          'Aadhar card uploaded successfully',
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

  /// Complete document KYC (Digio integration)
  Future<bool> completeDocumentKyc({
    required String email,
    required String name,
    required String signType, // 'aadhaar' or 'pancard'
  }) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/kyc/document-kyc/$uid',
        data: {'email': email, 'name': name, 'sign_type': signType},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isKycCompleted.value = true;
        Get.snackbar(
          'Success',
          'KYC verification initiated successfully',
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

  /// Reset KYC status
  void resetKycStatus() {
    isAadharUploaded.value = false;
    isPanUploaded.value = false;
    isKycCompleted.value = false;
  }
}
