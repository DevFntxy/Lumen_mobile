import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/pixel_icons.dart';
import '../../core/widgets/pixel_nav_bar.dart';
import '../router/routes.dart';

/// Marco de las secciones principales: contenido + barra de navegación
/// inferior. Las pantallas de detalle (perfil, ajustes...) quedan fuera.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  /// Ruta actual, para marcar la sección activa.
  final String location;
  final Widget child;

  /// Mismo orden que [AppRoutes.tabPaths].
  static const List<PixelNavItem> _tabs = [
    PixelNavItem(label: 'Inicio', icon: PixelIcons.home),
    PixelNavItem(label: 'Misiones', icon: PixelIcons.quests),
    PixelNavItem(label: 'Inventario', icon: PixelIcons.inventory),
    PixelNavItem(label: 'Códex', icon: PixelIcons.codex),
    PixelNavItem(label: 'Ránking', icon: PixelIcons.leaderboard),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: PixelNavBar(
        items: _tabs,
        currentIndex: AppRoutes.tabPaths.indexOf(location),
        onSelected: (index) => context.go(AppRoutes.tabPaths[index]),
      ),
    );
  }
}
