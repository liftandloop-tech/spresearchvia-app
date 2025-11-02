import 'package:flutter/material.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.planName,
    required this.amount,
    required this.validity,
    required this.selected,
    this.popular = false,
    required this.onTap,
  });
  final String planName;
  final int amount, validity;
  final bool popular, selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? Color(0xffEFF6FF) : Colors.white,
          border: Border.all(
            width: 2,
            color: selected ? Color(0xff163174) : Color(0xffE5E7EB),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      planName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff11416B),
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? Color(0xff163174) : Colors.white,
                      border: Border.all(color: Color(0xffD1D5DB)),
                    ),
                    child: Visibility(
                      visible: selected,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              '₹$amount',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xff11416B),
              ),
            ),
            SizedBox(height: 5),
            Text(
              '$validity days validity',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xff4B5563),
              ),
            ),
            SizedBox(height: 5),
            Visibility(
              visible: popular,
              child: Container(
                width: 150,
                height: 30,
                padding: EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                  color: Color(0xff163174),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Most Popular',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPlanCard extends StatefulWidget {
  const CustomPlanCard({
    super.key,
    required this.selected,
    required this.controller,
    required this.onTap,
  });

  final bool selected;
  final TextEditingController controller;
  final void Function() onTap;

  @override
  State<CustomPlanCard> createState() => _CustomPlanCardState();
}

class _CustomPlanCardState extends State<CustomPlanCard> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !widget.selected) {
        widget.onTap();
      }
    });
  }

  @override
  void didUpdateWidget(CustomPlanCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.selected && oldWidget.selected) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.selected ? Color(0xffEFF6FF) : Colors.white,
          border: Border.all(
            width: 2,
            color: widget.selected ? Color(0xff163174) : Color(0xffE5E7EB),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Custom Plan',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff11416B),
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.selected ? Color(0xff163174) : Colors.white,
                      border: Border.all(color: Color(0xffD1D5DB)),
                    ),
                    child: Visibility(
                      visible: widget.selected,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3),
            TitleField(
              title: 'Enter Amount',
              hint: '0',
              keyboardType: TextInputType.number,
              controller: widget.controller,
              icon: Icons.currency_rupee_outlined,
              focusNode: _focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
