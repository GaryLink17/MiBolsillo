// Archivo: lib/shared/widgets/app_page.dart
//
// Contenedor base de las pantallas que no usan `Scaffold` propio (las que
// viven dentro del shell con barra inferior).

import 'package:flutter/material.dart';

import '../../app/theme/app_page_metrics.dart';

/// Contenedor común de las pantallas: respeta el notch y limita el ancho en
/// tablets para que las líneas de texto no se estiren demasiado.
///
/// No añade `Scaffold`: el shell o la pantalla que lo usa se encarga del fondo
/// y de la barra inferior.
class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppPageMetrics.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
