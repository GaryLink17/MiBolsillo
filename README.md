# Mi Bolsillo

App de finanzas personales para Android, con datos locales y sincronización en
la nube (Supabase) a partir del siguiente hito.

## Estado actual

Hito **M0 + M1**: base del proyecto, sistema de diseño y navegación.

- Tema claro/oscuro con los colores del diseño de referencia.
- Tipografía Inter incluida en la app (sin descargas en tiempo de ejecución).
- Tutorial guiado de 4 pasos la primera vez; se puede repetir desde Ajustes.
- Navegación con 5 accesos: Inicio, Movimientos, Cuentas, Categorías y el botón
  central de nuevo movimiento.
- Inicio con datos de muestra para validar tarjetas, cuentas y movimientos.
- Ajustes funcional para cambiar tema y repetir el tutorial.

No hay todavía base de datos, autenticación ni registro real de movimientos.

## Decisiones cerradas

| Tema | Decisión |
| --- | --- |
| Nombre | Mi Bolsillo |
| Package | `com.garyj.mibolsillo` |
| Plataforma inicial | Android; iOS, escritorio y web después |
| Backend | Supabase (Postgres + Auth + RLS) |
| Sincronización | Offline-first: Drift local + cola de cambios |
| Login | Correo/contraseña + Google; huella como desbloqueo local |
| Moneda | Solo DOP, formato `RD$ 86,050.00` |
| Ahorro | Traspaso a una meta; no cuenta como gasto ni altera el balance total |
| Primer uso | Datos base vacíos + tutorial guiado |

## Estructura

```
lib/
  app/            # arranque, router, tema, medidas de página
  core/           # preferencias, formatos
  shared/widgets/ # componentes reutilizables
  features/
    onboarding/   # tutorial de bienvenida
    shell/        # contenedor con la barra inferior
    home/         # inicio y datos de muestra
    movements/    # vista previa de nuevo movimiento
    placeholder/  # pantallas en construcción
    settings/     # ajustes y apariencia
```

## Comandos

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

### Conexión con Supabase

Las credenciales no viven en el repositorio. Copia `env.example.json` a
`env.json`, coloca tu URL y la clave pública (`anon`/`publishable`), y ejecuta:

```bash
flutter run --dart-define-from-file=env.json
flutter build apk --dart-define-from-file=env.json
```

Si `env.json` no existe o está incompleto, la app arranca en modo local sin
fallar. Nunca se usa la `service_role` desde la app.

## Siguientes hitos

1. **M2** Autenticación con Supabase y esquema inicial (perfiles, cuentas,
   categorías, movimientos, metas).
2. **M3** Movimientos: formulario completo, lista, búsqueda y filtros.
3. **M4** Persistencia local con Drift y sincronización offline-first.
4. **M5** Cuentas y metas de ahorro.
5. **M6** Análisis por categorías.
6. **M7** Seguridad local, exportación y recordatorios.
7. **M8** Pruebas, pulido y release.
