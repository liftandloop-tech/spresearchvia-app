import 'package:get/get.dart';
import '../../../controllers/segment_plan.controller.dart';

class SegmentDropdownController extends GetxController {
  final selectedSegment = 'SPARK'.obs;
  final isOpen = false.obs;

  List<String> get segments => [
    // 'Index Future',
    // 'Stock Future',
    // 'Index Option',
    // 'Stock Option',
    // 'Equity Cash',
    // 'MCX',
    // 'NCDEX',
    // 'currency',
    // 'HNI Custom Plan',
    'SPARK',
    'SPLENDID',
    'HNI CUSTOMIZE CORPORATE PLAN',
  ];

  void selectSegment(String segment) {
    selectedSegment.value = segment;
    isOpen.value = false;

    try {
      final segmentPlanController = Get.find<SegmentPlanController>();
      segmentPlanController.filterBySegment(segment);
    } catch (e) {
      Get.log('Error finding SegmentPlanController: $e');
    }
  }

  void toggleDropdown() {
    isOpen.value = !isOpen.value;
  }
}
