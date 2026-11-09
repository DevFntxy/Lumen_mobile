import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Campo de texto con etiqueta superior, bordes rectos y cursor de bloque.
/// Con `obscure` incluye el botón para mostrar u ocultar el contenido.
class PixelTextField extends StatefulWidget {
  const PixelTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    this.obscure = false,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscure;
  final bool enabled;

  @override
  State<PixelTextField> createState() => _PixelTextFieldState();
}

class _PixelTextFieldState extends State<PixelTextField> {
  bool _hidden = true;

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: color, width: 3),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: widget.obscure && _hidden,
          autocorrect: !widget.obscure,
          enableSuggestions: !widget.obscure,
          style: AppTextStyles.body,
          cursorColor: AppColors.unselected,
          cursorWidth: 8,
          cursorHeight: 18,
          cursorRadius: Radius.zero,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.surfaceRaised,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: _border(AppColors.metal),
            enabledBorder: _border(AppColors.metal),
            disabledBorder: _border(AppColors.metal),
            focusedBorder: _border(AppColors.primaryLight),
            errorBorder: _border(AppColors.errorText),
            focusedErrorBorder: _border(AppColors.errorText),
            errorStyle:
                AppTextStyles.caption.copyWith(color: AppColors.errorText),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.obscure
                ? TextButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const RoundedRectangleBorder(),
                      textStyle: AppTextStyles.caption.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: Text(_hidden ? 'VER' : 'OCULTAR'),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
