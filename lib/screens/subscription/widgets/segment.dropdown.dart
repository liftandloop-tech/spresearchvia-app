import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_dimensions.dart';

class SegmentDropdownController extends GetxController {
  final selectedSegment = 'Equity Cash'.obs;
  final isOpen = false.obs;

  List<String> get segments => [
    'Index Future',
    'Stock Future',
    'Index Option',
    'Stock Option',
    'Equity Cash',
    'MCX',
    'NCDEX',
  ];

  void selectSegment(String segment) {
    selectedSegment.value = segment;
    isOpen.value = false;
  }

  void toggleDropdown() {
    isOpen.value = !isOpen.value;
  }
}

class SegmentDropdownMenu extends StatefulWidget {
  const SegmentDropdownMenu({super.key});

  @override
  State<SegmentDropdownMenu> createState() => _SegmentDropdownMenuState();
}

class _SegmentDropdownMenuState extends State<SegmentDropdownMenu> {
  final controller = Get.put(SegmentDropdownController());
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    controller.isOpen.value = false;
  }

  void _createOverlay() {
    final responsive = Responsive.of(context);
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
                      border: Border.all(color: AppTheme.borderGrey),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: controller.segments.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: AppTheme.borderGrey,
                      ),
                      itemBuilder: (context, index) {
                        final segment = controller.segments[index];
                        return Obx(() {
                          final isSelected = segment == controller.selectedSegment.value;
                          return InkWell(
                            onTap: () {
                              controller.selectSegment(segment);
                              _removeOverlay();
                            },
                            child: Container(
                              padding: responsive.padding(
                                horizontal: AppDimensions.paddingMedium,
                                vertical: 14,
                              ),
                              color: isSelected
                                  ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      segment,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: AppTheme.primaryGreen,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _createOverlay();
      controller.isOpen.value = true;
    } else {
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Obx(
        () => InkWell(
          key: _key,
          onTap: _toggleDropdown,
          borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
          child: Container(
            padding: responsive.padding(
              horizontal: AppDimensions.paddingMedium,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: controller.isOpen.value ? AppTheme.primaryBlue : AppTheme.borderGrey,
              ),
              borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.selectedSegment.value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                Icon(
                  controller.isOpen.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
