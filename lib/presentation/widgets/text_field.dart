import 'package:flutter/material.dart';
import '../../common/constants/color_constans.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool showPasswordToggle;
  final int maxLines;

  const MyTextField({
    required this.label,
    required this.obscureText,
    required this.keyboardType,
    required this.controller,
    this.showPasswordToggle = false,
    this.maxLines = 1,
    super.key,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late FocusNode _focusNode;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _isObscure = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _toggleObscureText() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      keyboardType: widget.keyboardType,
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      cursorColor: ColorConstant.primaryColor(context),
      style: TextStyle(color: ColorConstant.fontColor(context)),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorConstant.backgroundColor(context),
        labelText: widget.label,
        labelStyle: TextStyle(
          color:
              _focusNode.hasFocus
                  ? ColorConstant.primaryColor(context)
                  : Colors.grey,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.primaryColor(context),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: widget.showPasswordToggle ? _buildSuffixIcon() : null,
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: ColorConstant.primaryColor(context),
      ),
      onPressed: _toggleObscureText,
    );
  }
}
