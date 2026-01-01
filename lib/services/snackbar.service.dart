import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../core/theme/app_theme.dart';
import '../core/utils/error_message_handler.dart';

enum SnackbarType { success, error, warning, info }

abstract class SnackbarService {
  static OverlayEntry? _currentSnackbar;

  static void show(
    String message, {
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    BuildContext? context,
  }) {
    _dismiss();

    try {
      BuildContext? overlayContext;

      overlayContext = getx.Get.overlayContext;

      if (overlayContext == null && context != null) {
        overlayContext = context;
      }

      if (overlayContext == null && context != null) {
        overlayContext = Navigator.maybeOf(context)?.context;
      }

      if (overlayContext == null) {
        debugPrint('SnackbarService: No overlay context available');

        getx.Get.snackbar(
          title ?? "",
          message,
          backgroundColor: backgroundColor ?? AppTheme.primaryBlueDark,
          colorText: Colors.white,
          snackPosition: getx.SnackPosition.BOTTOM,
          duration: duration,
          titleText: const SizedBox.shrink(),
        );
        return;
      }

      final overlay = Overlay.maybeOf(overlayContext);
      if (overlay == null) {
        debugPrint('SnackbarService: No overlay found, using fallback');

        getx.Get.snackbar(
          "",
          message,
          backgroundColor: backgroundColor ?? AppTheme.primaryBlueDark,
          colorText: Colors.white,
          snackPosition: getx.SnackPosition.BOTTOM,
          duration: duration,
          titleText: const SizedBox.shrink(),
        );
        return;
      }

      _currentSnackbar = OverlayEntry(
        builder: (context) => _SnackbarWidget(
          message: message,
          title: title,
          icon: icon ?? Icons.notifications_outlined,
          backgroundColor: backgroundColor ?? AppTheme.primaryBlueDark,
          duration: duration,
          onTap: onTap,
          onDismiss: _dismiss,
        ),
      );

      overlay.insert(_currentSnackbar!);
    } catch (e) {
      debugPrint('SnackbarService error: $e');

      try {
        getx.Get.snackbar(
          "",
          message,
          backgroundColor: backgroundColor ?? AppTheme.primaryBlueDark,
          colorText: Colors.white,
          snackPosition: getx.SnackPosition.BOTTOM,
          duration: duration,
          titleText: const SizedBox.shrink(),
        );
      } catch (_) {}
    }
  }

  static void showSuccess(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    show(
      message,
      title: title,
      icon: Icons.check_circle_rounded,
      backgroundColor: AppTheme.success,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showError(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    show(
      message,
      title: title,
      icon: Icons.error_rounded,
      backgroundColor: AppTheme.error,
      duration: duration ?? const Duration(seconds: 4),
      context: context,
    );
  }

  static void showErrorFromException(
    dynamic error, {
    String? title,
    String? customMessage,
    Duration? duration,
  }) {
    ErrorMessageHandler.logError(title ?? 'Error', error);

    final message =
        customMessage ?? ErrorMessageHandler.getUserFriendlyMessage(error);

    showError(message, title: title, duration: duration);
  }

  static void showWarning(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    show(
      message,
      title: title,
      icon: Icons.warning_rounded,
      backgroundColor: AppTheme.warning,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showInfo(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    show(
      message,
      title: title,
      icon: Icons.info_rounded,
      backgroundColor: AppTheme.primaryBlueDark,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showLoading(String message, {String? title}) {
    _dismiss();

    final overlayState = getx.Get.overlayContext;
    if (overlayState == null) return;

    _currentSnackbar = OverlayEntry(
      builder: (context) => _SnackbarWidget(
        message: message,
        title: title,
        icon: Icons.hourglass_empty_rounded,
        backgroundColor: AppTheme.primaryBlueDark,
        duration: const Duration(days: 365),
        showLoading: true,
        onDismiss: _dismiss,
      ),
    );

    Overlay.of(overlayState).insert(_currentSnackbar!);
  }

  static void _dismiss() {
    _currentSnackbar?.remove();
    _currentSnackbar = null;
  }

  static void closeAll() => _dismiss();

  static void close() => _dismiss();

  static void showSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(message, duration: duration);
  }

  static void showSuccessContext(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    showSuccess(message, duration: duration);
  }

  static void showErrorContext(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showError(message, duration: duration);
  }

  static void showErrorFromExceptionContext(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showErrorFromException(
      error,
      customMessage: customMessage,
      duration: duration,
    );
  }

  static void showWarningContext(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    showWarning(message, duration: duration);
  }

  static void showInfoContext(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    showInfo(message, duration: duration);
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final String? title;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;
  final bool showLoading;

  const _SnackbarWidget({
    required this.message,
    this.title,
    required this.icon,
    required this.backgroundColor,
    required this.duration,
    this.onTap,
    required this.onDismiss,
    this.showLoading = false,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    if (!widget.showLoading) {
      Future.delayed(widget.duration, _dismiss);
    }
  }

  void _dismiss() async {
    if (!mounted) return;

    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap ?? _dismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.backgroundColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: widget.showLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(widget.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.title != null && widget.title!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                widget.title!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!widget.showLoading)
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _dismiss,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
