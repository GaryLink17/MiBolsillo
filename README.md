# Mi Bolsillo

App de finanzas personales para Android, con datos en la nube (Supabase).

## Estado actual

Hito **M3**: movimientos y metas de ahorro.

- Tema claro/oscuro con los colores del diseño de referencia.
- Tipografía Inter incluida en la app (sin descargas en tiempo de ejecución).
- Entrada: bienvenida → tutorial de 4 pasos → acceso → inicio. El tutorial se
  puede omitir y repetir desde Ajustes; quien ya tiene cuenta puede saltarlo.
- Acceso con correo y contraseña mediante Supabase. Sin sesión no se llega a
  ninguna pantalla interna.
- Saldo inicial por cuenta (Efectivo, Banco, Ahorros y Tarjeta) al terminar el
  registro; se puede omitir y configurar después desde Inicio.
- Inicio muestra el balance total, las cuentas, los totales del mes y los
  últimos movimientos. El balance total suma los saldos de las cuentas más lo
  ahorrado en las metas.
- Movimientos admite gasto, ingreso y ahorro, con monto, fecha, cuenta,
  categoría (opcional) o meta y nota. La lista se agrupa por día y muestra los
  totales del mes.
- La lista permite buscar por nota, cuenta, categoría o meta y combinar filtros
  de tipo, cuenta, categoría y rango de fechas.
- Un ahorro se descuenta de la cuenta y se suma a la meta. Aparece en negativo
  porque sale del saldo disponible, pero no cuenta como gasto ni reduce el
  balance total.
- Cuentas y metas muestra las cuentas reales con su saldo y las metas con su
  progreso; las metas se crean desde `/nueva-meta`.
- Navegación con 5 accesos: Inicio, Movimientos, Cuentas, Categorías y el botón
  central de nuevo movimiento.
- Ajustes funcional para cambiar tema, repetir el tutorial y cerrar sesión.

La persistencia offline y el análisis por categorías llegan en los siguientes
hitos.

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
  core/           # configuración, preferencias, formatos y l10n
  l10n/           # textos en español e inglés
  shared/widgets/ # componentes reutilizables
  features/
    onboarding/   # tutorial de bienvenida
    welcome/      # pantalla de bienvenida
    auth/         # acceso y registro
    accounts/     # cuentas y saldo inicial
    goals/        # metas de ahorro
    categories/   # categorías de gasto e ingreso
    movements/    # gastos, ingresos y ahorros
    home/         # inicio
    placeholder/  # pantallas en construcción
    settings/     # ajustes y apariencia
```

## Comandos

```bash
flutter pub get
flutter gen-l10n
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

### Base de datos

Las migraciones viven en `supabase/migrations`:

- `0001_init.sql`: perfiles, cuentas, categorías, movimientos, metas, RLS y
  vistas `account_balances` y `goal_balances`.
- `0002_account_balances_initial_balance.sql`: incluye el saldo inicial en el
  cálculo de las cuentas.

## Siguientes hitos

1. **M4** Persistencia local con Drift y sincronización offline-first.
2. **M5** Metas de ahorro: listado y registro de ahorros listos; faltan edición
   y archivo de metas.
3. **M6** Análisis por categorías.
4. **M7** Seguridad local, exportación y recordatorios.
5. **M8** Pruebas, pulido y release.
