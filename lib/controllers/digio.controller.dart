import 'package:get/get.dart';
import 'package:spresearchvia/core/config/api.config.dart';

import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/snackbar.service.dart';
import '../services/secure_storage.service.dart';

class DigioController extends GetxController {
  final RxBool connecting = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> connectDigio({
    required String email,
    required String name,
    required String userId,
  }) async {
    try {
      connecting.value = true;

      final token = await SecureStorageService().getAuthToken();
      if (token == null || token.isEmpty) {
        SnackbarService.showError('User token missing. Please login again.');
        return null;
      }

      final response = await _apiClient.post(
        ApiConfig.documentKYC(userId),
        data: {'email': email, 'name': name, 'sign_type': 'aadhaar'},
      );

      SnackbarService.showSuccess('Digio connected successfully');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return null;
    } finally {
      connecting.value = false;
    }
  }
}
