import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for filtering input

class TextFieldInput extends StatelessWidget {
  final String? value1;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool isNumeric;
  final bool isEdit;

  const TextFieldInput({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.isPassword,
    this.isNumeric = false,
    this.isEdit = true,
    this.value1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Vui lòng điền đầy đủ thông tin";
          }
          return null;
        },
        onSaved: (value) {
          value = value1;
        },
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumeric
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          hintText: hint,
          icon: Icon(icon),
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          enabled: isEdit,
          labelText: value1,
        ),
      ),
    );
  }
}
