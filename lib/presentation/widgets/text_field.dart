import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool showPasswordToggle;

  const MyTextField({
    required this.label,
    required this.obscureText,
    required this.keyboardType,
    required this.controller,
    this.showPasswordToggle = false,
    super.key,
  });

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: widget.showPasswordToggle
            ? _buildSuffixIcon()
            : null,
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return IconButton(
      icon: _isObscure ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
      onPressed: _toggleObscureText,
    );
  }
}
