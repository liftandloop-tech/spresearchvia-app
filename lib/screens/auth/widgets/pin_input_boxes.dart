import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputBoxes extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final bool obscureText;

  const PinInputBoxes({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.obscureText = false,
  });

  @override
  State<PinInputBoxes> createState() => _PinInputBoxesState();
}

class _PinInputBoxesState extends State<PinInputBoxes> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: controllers[index].text.isNotEmpty
                  ? Color(0xff0B3A70)
                  : Color(0xffD1D5DB),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            obscureText: widget.obscureText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff0B3A70),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty && index < widget.length - 1) {
                focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                focusNodes[index - 1].requestFocus();
              }
              
              final pin = controllers.map((c) => c.text).join();
              if (pin.length == widget.length) {
                widget.onCompleted(pin);
              }
            },
          ),
        );
      }),
    );
  }
}
