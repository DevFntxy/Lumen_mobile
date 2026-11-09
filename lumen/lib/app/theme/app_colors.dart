import 'package:flutter/painting.dart';

abstract final class AppColors {
  // ── Paleta base (definida por el proyecto) ──────────────────────────
  /// Tono oscuro de botones seleccionados.
  static const Color primaryDark = Color(0xFF8E0023);

  /// Tono claro de botones seleccionados.
  static const Color primaryLight = Color(0xFFC60031);

  /// Botones no seleccionados.
  static const Color unselected = Color(0xFFFFFFFF);

  /// Detalles.
  static const Color detail = Color(0xFF000000);

  // ── Complementarios (propuesta, ajustables) ─────────────────────────
  static const Color background = Color(0xFF0F1315);
  static const Color surface = Color(0xFF1B2225);
  static const Color surfaceRaised = Color(0xFF242C2F);
  static const Color metal = Color(0xFF4A4D45);
  static const Color metalLight = Color(0xFF6B6E64);
  static const Color textPrimary = Color(0xFFE4E4DA);
  static const Color textSecondary = Color(0xFF93927D);

  /// Rojo aclarado para texto de error sobre fondos oscuros
  /// (primaryLight solo llega a ~2.6:1 de contraste como texto).
  static const Color errorText = Color(0xFFFF6B85);

  // ── Efectos ─────────────────────────────────────────────────────────
  static const Color scanline = Color(0x14000000);
  static const Color gridLine = Color(0x0DFFFFFF);
}
