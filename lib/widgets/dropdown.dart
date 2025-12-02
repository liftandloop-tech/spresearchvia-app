import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _DropdownController extends GetxController {
  final isOpen = false.obs;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;

  @override
  void onClose() {
    overlayEntry?.remove();
    super.onClose();
  }

  void toggleDropdown(
    BuildContext context,
    Widget Function(BuildContext) overlayBuilder,
  ) {
    if (isOpen.value) {
      closeDropdown();
    } else {
      openDropdown(context, overlayBuilder);
    }
  }

  void openDropdown(
    BuildContext context,
    Widget Function(BuildContext) overlayBuilder,
  ) {
    overlayEntry = OverlayEntry(builder: overlayBuilder);
    Overlay.of(context).insert(overlayEntry!);
    isOpen.value = true;
  }

  void closeDropdown() {
    overlayEntry?.remove();
    overlayEntry = null;
    isOpen.value = false;
  }
}

class StateSelector extends StatelessWidget {
  StateSelector({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.onChanged,
  });

  final String label;
  final String? hint;
  final String? value;
  final ValueChanged<String?> onChanged;

  final List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  Widget _createOverlayWidget(
    BuildContext context,
    _DropdownController controller,
  ) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: controller.closeDropdown,
      child: Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: CompositedTransformFollower(
              link: controller.layerLink,
              showWhenUnlinked: false,
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: indianStates.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No options',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: indianStates.length,
                          itemBuilder: (context, index) {
                            final item = indianStates[index];
                            final selected = value == item;
                            return InkWell(
                              onTap: () {
                                onChanged(item);
                                controller.closeDropdown();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Colors.blue.shade50
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: selected
                                        ? Colors.blue
                                        : Colors.black87,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_DropdownController(), tag: '$label-$hashCode');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        CompositedTransformTarget(
          link: controller.layerLink,
          child: GestureDetector(
            onTap: () => controller.toggleDropdown(
              context,
              (ctx) => _createOverlayWidget(context, controller),
            ),
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value ?? hint ?? 'Select $label',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: value != null ? Colors.black87 : Colors.grey,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      controller.isOpen.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
