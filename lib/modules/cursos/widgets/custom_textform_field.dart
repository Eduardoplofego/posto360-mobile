import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CustomTextformField extends StatefulWidget {
  final Function(String) onChanged;
  const CustomTextformField({super.key, required this.onChanged});

  @override
  State<CustomTextformField> createState() => _CustomTextformFieldState();
}

class _CustomTextformFieldState extends State<CustomTextformField> {
  final _searchEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        prefixIconColor: PostoAppUiConfigurations.blueMediumColor,
        fillColor: PostoAppUiConfigurations.lightPurpleColor,
        filled: true,
        hintText: 'Pesquisa rápida',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: PostoAppUiConfigurations.lightPurpleColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: PostoAppUiConfigurations.lightPurpleColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: PostoAppUiConfigurations.lightPurpleColor,
          ),
        ),
      ),
    );
  }
}
