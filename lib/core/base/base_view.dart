import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

/// Base view widget with common functionality
abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({super.key});

  /// Build the main content
  Widget buildContent(BuildContext context);

  /// Build loading indicator
  Widget buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Build error widget
  Widget buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.clearError(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.errorMessage != null) {
        return buildError(controller.errorMessage!);
      }
      return buildContent(context);
    });
  }
}
