/// Error Message Handler
/// Converts technical errors into user-friendly messages
class ErrorMessageHandler {
  /// Get user-friendly error message from exception
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) return 'Something went wrong';

    final errorString = error.toString().toLowerCase();

    // Permission errors
    if (errorString.contains('camera_access_denied') ||
        errorString.contains('camera access') ||
        errorString.contains('camera permission')) {
      return 'Camera Permission Denied';
    }
    if (errorString.contains('photo_access_denied') ||
        errorString.contains('photo library') ||
        errorString.contains('gallery permission')) {
      return 'Gallery Permission Denied';
    }
    if (errorString.contains('storage_access_denied') ||
        errorString.contains('storage permission')) {
      return 'Storage Permission Denied';
    }
    if (errorString.contains('permission denied') ||
        errorString.contains('access denied')) {
      return 'Permission Denied';
    }

    // Network errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socketexception')) {
      return 'Network Error';
    }

    // File/Upload errors
    if (errorString.contains('file not found')) {
      return 'File Not Found';
    }
    if (errorString.contains('upload failed') ||
        errorString.contains('failed to upload')) {
      return 'Upload Failed';
    }
    if (errorString.contains('file too large') ||
        errorString.contains('exceeds maximum size')) {
      return 'File Too Large';
    }

    // Authentication errors
    if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return 'Session Expired';
    }
    if (errorString.contains('forbidden') || errorString.contains('403')) {
      return 'Access Forbidden';
    }
    if (errorString.contains('invalid credentials') ||
        errorString.contains('wrong password')) {
      return 'Invalid Credentials';
    }

    // Validation errors
    if (errorString.contains('invalid email')) {
      return 'Invalid Email';
    }
    if (errorString.contains('invalid phone')) {
      return 'Invalid Phone Number';
    }
    if (errorString.contains('required field')) {
      return 'Required Field Missing';
    }

    // Payment errors
    if (errorString.contains('payment failed') ||
        errorString.contains('transaction failed')) {
      return 'Payment Failed';
    }
    if (errorString.contains('payment cancelled') ||
        errorString.contains('transaction cancelled')) {
      return 'Payment Cancelled';
    }

    // Server errors
    if (errorString.contains('500') ||
        errorString.contains('internal server')) {
      return 'Server Error';
    }
    if (errorString.contains('503') ||
        errorString.contains('service unavailable')) {
      return 'Service Unavailable';
    }
    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'Not Found';
    }

    // Generic fallback
    return 'Something Went Wrong';
  }

  /// Log full error details for debugging (only in debug mode)
  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    print('❌ ERROR in $context:');
    print('   Error: $error');
    if (stackTrace != null) {
      print('   Stack: $stackTrace');
    }
    // TODO: Send to crash reporting service (Firebase Crashlytics, Sentry, etc.)
  }
}
