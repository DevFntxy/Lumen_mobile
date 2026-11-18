import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show AutofillHints, FilteringTextInputFormatter, LengthLimitingTextInputFormatter;

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Código numérico en casillas separadas. Debajo hay un único campo de texto
/// invisible, así el teclado, pegar y el autocompletado del SMS/correo
/// funcionan con normalidad. Lee el valor con `controller.text`.
///
/// [onCompleted] se llama al llegar a [length] dígitos.
class PixelOtpField extends StatefulWidget {
  const PixelOtpField({
    super.key,
    required this.controller,
    this.length = 6,
    this.enabled = true,
    this.hasError = false,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String>? onCompleted;

  @override
  State<PixelOtpField> createState() => _PixelOtpFieldState();
}

class _PixelOtpFieldState extends State<PixelOtpField> {
  final FocusNode _focus = FocusNode();
  String _lastNotified = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    final text = widget.controller.text;
    if (text.length < widget.length) {
      _lastNotified = '';
      return;
    }
    if (text != _lastNotified) {
      _lastNotified = text;
      widget.onCompleted?.call(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([widget.controller, _focus]),
          builder: (context, _) {
            final text = widget.controller.text;
            final activeIndex =
                text.length < widget.length ? text.length : widget.length - 1;
            return Row(
              children: [
                for (var i = 0; i < widget.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _Cell(
                      char: i < text.length ? text[i] : '',
                      active: _focus.hasFocus && i == activeIndex,
                      error: widget.hasError,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              showCursor: false,
              enableInteractiveSelection: false,
              style: const TextStyle(color: Colors.transparent),
              decoration: InputDecoration(
                labelText: 'Código de ${widget.length} dígitos',
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.char, required this.active, required this.error});

  final String char;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final Color border;
    if (error) {
      border = AppColors.errorText;
    } else if (active) {
      border = AppColors.primaryLight;
    } else if (char.isNotEmpty) {
      border = AppColors.metalLight;
    } else {
      border = AppColors.metal;
    }

    return AspectRatio(
      aspectRatio: 0.85,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          border: Border.all(color: border, width: 3),
        ),
        child: Text(char, style: AppTextStyles.title),
      ),
    );
  }
}
