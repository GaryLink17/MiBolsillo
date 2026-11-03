# Mi Bolsillo

App de finanzas personales para Android, con datos locales y sincronización en
la nube (Supabase) a partir del siguiente hito.

## Estado actual

Hito **M2**: conexión con Supabase, acceso real y saldo inicial.

- Tema claro/oscuro con los colores del diseño de referencia.
- Tipografía Inter incluida en la app (sin descargas en tiempo de ejecución).
- Entrada: bienvenida → tutorial de 4 pasos → acceso → inicio. El tutorial se
  puede omitir y repetir desde Ajustes; quien ya tiene cuenta puede saltarlo.
- Acceso con correo y contraseña mediante Supabase. Sin sesión no se llega a
  ninguna pantalla interna.
- Saldo inicial por cuenta (Efectivo, Banco, Ahorros y Tarjeta) al terminar el
  registro; se puede omitir y configurar después desde Inicio.
- Inicio muestra el balance total y las cuentas reales del usuario.
- Navegación con 5 accesos: Inicio, Movimientos, Cuentas, Categorías y el botón
  central de nuevo movimiento.
- Ajustes funcional para cambiar tema, repetir el tutorial y cerrar sesión.

Los movimientos, las metas de ahorro y la sincronización offline llegan en los
siguientes hitos.

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
