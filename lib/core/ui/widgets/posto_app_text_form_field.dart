import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class PostoAppTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final ValueNotifier<bool> _obscureTextVN;
  final ValueChanged<String>? onChanged;

  PostoAppTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    required this.obscureText,
    this.onChanged,
  }) : _obscureTextVN = ValueNotifier<bool>(obscureText);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureTextVN,
      builder: (_, value, child) {
        return TextFormField(
          controller: controller,
          obscureText: value,
          validator: validator,
          onChanged: onChanged,
          cursorColor: context.theme.primaryColor,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon:
                obscureText
                    ? IconButton(
                      onPressed: () {
                        _obscureTextVN.value = !_obscureTextVN.value;
                      },
                      icon: Icon(
                        value ? Icons.visibility : Icons.visibility_off_sharp,
                        size: 24,
                        color: Colors.grey,
                      ),
                    )
                    : null,
            labelText: label,
            labelStyle: TextStyle(
              color: PostoAppUiConfigurations.purpleColor,
              fontSize: 16,
            ),
            hintStyle: TextStyle(color: PostoAppUiConfigurations.purpleColor),
            errorStyle: const TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Color(0xFF0C7AF0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Color(0xFF0C7AF0)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            fillColor: Colors.white,
          ),
        );
      },
    );
  }
}
