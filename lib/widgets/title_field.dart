import 'package:flutter/material.dart';

class TitleField extends StatefulWidget {
  const TitleField({
    super.key,
    required this.title,
    required this.controller,
    this.hint,
    this.icon,
    this.isPasswordField = false,
    this.focusNode,
  });

  final String title;
  final String? hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPasswordField;
  final FocusNode? focusNode;

  @override
  State<TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff11416B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: const Color(0xffF9FAFB),
              border: Border.all(width: 1, color: const Color(0xffE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                obscureText: widget.isPasswordField ? _obscure : false,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffADAEBC),
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  suffixIcon: widget.isPasswordField
                      ? GestureDetector(
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onTap: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        )
                      : (widget.icon != null ? Icon(widget.icon) : null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
