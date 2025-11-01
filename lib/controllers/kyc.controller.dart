import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spresearchvia2/core/utils/file_validator.dart';
import 'package:spresearchvia2/core/utils/validators.dart';
import 'package:path/path.dart' as path;
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';

class KycController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  final isLoading = false.obs;
  final isAadharUploaded = false.obs;
  final isPanUploaded = false.obs;
  final isKycCompleted = false.obs;

  String? get userId => _storage.getUserId();

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

      final panValidation = Validators.validatePAN(panNumber);
      if (panValidation != null) {
        Get.snackbar('Error', panValidation);
        return false;
      }

      final fileValidation = FileValidator.validateDocumentFile(panFile);
      if (fileValidation != null) {
        Get.snackbar('Error', fileValidation);
        return false;
      }

      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          panFile.path,
          filename: path.basename(panFile.path),
        ),
        'panNumber': panNumber.toUpperCase(),
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

      final aadharValidation = Validators.validateAadhar(aadharNumber);
      if (aadharValidation != null) {
        Get.snackbar('Error', aadharValidation);
        return false;
      }

      final frontFileValidation = FileValidator.validateDocumentFile(frontFile);
      if (frontFileValidation != null) {
        Get.snackbar('Error', 'Front image: $frontFileValidation');
        return false;
      }

      final backFileValidation = FileValidator.validateDocumentFile(backFile);
      if (backFileValidation != null) {
        Get.snackbar('Error', 'Back image: $backFileValidation');
        return false;
      }

      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'frontFile': await dio.MultipartFile.fromFile(
          frontFile.path,
          filename: 'aadhar_front_${path.basename(frontFile.path)}',
        ),
        'backFile': await dio.MultipartFile.fromFile(
          backFile.path,
          filename: 'aadhar_back_${path.basename(backFile.path)}',
        ),
        'aadhaarNumber': Validators.cleanAadhar(aadharNumber),
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

  Future<bool> completeDocumentKyc({
    required String email,
    required String name,
    required String signType,
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

  void resetKycStatus() {
    isAadharUploaded.value = false;
    isPanUploaded.value = false;
    isKycCompleted.value = false;
  }
}
