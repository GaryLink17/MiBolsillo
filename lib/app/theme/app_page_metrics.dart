// Archivo: lib/app/theme/app_page_metrics.dart
//
// Medidas compartidas por las pantallas para que todas respiren igual.

import 'package:flutter/material.dart';

/// Métricas de página.
///
/// `maxContentWidth` evita que en tablets las líneas de texto y los formularios
/// se estiren demasiado; `pagePadding` es el margen interior común.
abstract final class AppPageMetrics {
  static const double maxContentWidth = 640;
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(20, 12, 20, 24);
}
