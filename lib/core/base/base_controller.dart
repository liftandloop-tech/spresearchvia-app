import 'package:get/get.dart';

/// Base controller with common functionality for all GetX controllers
abstract class BaseController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  // Error handling
  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  /// Show loading indicator
  void showLoading() {
    _isLoading.value = true;
    _errorMessage.value = null;
  }

  /// Hide loading indicator
  void hideLoading() {
    _isLoading.value = false;
  }

  /// Set error message
  void setError(String message) {
    _errorMessage.value = message;
    _isLoading.value = false;
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = null;
  }

  /// Handle API errors
  void handleError(dynamic error) {
    hideLoading();
    final errorMsg = error.toString();
    setError(errorMsg);
  }

  @override
  void onClose() {
    _isLoading.close();
    _errorMessage.close();
    super.onClose();
  }
}
