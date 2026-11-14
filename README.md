# Mi Bolsillo

Aplicación de finanzas personales para Android, desarrollada con Flutter y
Supabase. Permite registrar ingresos, gastos y ahorros en metas, y consultar
cuentas y movimientos.

## Estado del proyecto

- **M3 completado:** movimientos, búsqueda y filtros, cuentas y metas.
- **M4 en desarrollo:** se ha preparado parte de la base local con Drift. La
  app **todavía no ofrece lectura ni registro offline**: sus pantallas y
  repositorios existentes siguen consultando Supabase.
- **Versión configurada:** `1.0.0+1` en `pubspec.yaml`. Los commits de Git no
  incrementan la versión automáticamente. La versión visible y el número de
  compilación se actualizarán cuando corresponda preparar una distribución.

Las secciones siguientes distinguen lo que funciona actualmente de lo que está
preparado o pendiente. La presencia de un archivo local no significa que sus
cambios estén confirmados en Git ni que una migración se haya aplicado a la
base remota: consultar `git status` y el estado de Supabase.

## Funcionalidad disponible

### Acceso y configuración inicial

- Bienvenida y tutorial de cuatro pasos; puede omitirse o repetirse en Ajustes.
- Registro e inicio de sesión con correo y contraseña mediante Supabase Auth.
  Las rutas internas requieren sesión.
- Configuración del saldo inicial por cuenta; puede omitirse y completarse
  después desde Inicio.
- Tema claro, oscuro o del sistema; selección de idioma y cierre de sesión.
- Textos localizados en español e inglés. El formato monetario de la app usa
  DOP, por ejemplo `RD$ 86,050.00`.

### Inicio y movimientos

- Inicio muestra cuentas, balance total, ingresos y gastos del mes y los cinco
  movimientos más recientes.
- Registro de **gasto, ingreso y ahorro**, con monto, fecha, cuenta y nota;
  gasto e ingreso admiten categoría opcional y ahorro requiere una meta.
- Lista de movimientos agrupada por fecha, con búsqueda por nota y nombre de
  cuenta, categoría o meta; filtros por tipo, rango de fechas, cuenta y
  categoría; y opción para limpiarlos.
- Los filtros actúan sobre la lista cargada en memoria. Para historiales
  grandes quedan pendientes paginación y una estrategia de búsqueda completa
  en el servidor: no se debe asumir que una respuesta limitada contiene todo
  el historial.

### Cuentas y metas

- La pestaña **Cuentas y metas** muestra cuentas reales y su saldo, y metas con
  su progreso. Se pueden crear metas desde `/nueva-meta`.
- Un ahorro se descuenta de la cuenta y suma a la meta. Se muestra negativo en
  la lista porque sale del saldo disponible, pero **no cuenta como gasto ni
  reduce el balance total**.
- El balance total de Inicio suma los saldos de las cuentas y lo ahorrado en
  las metas. La edición y el archivo de metas siguen pendientes.

### Navegación y apariencia

- Navegación inferior: Inicio, Movimientos, Cuentas, Categorías y botón central
  para registrar un movimiento. La pantalla de Categorías sigue en construcción.
- Tipografía Inter incluida, componentes visuales compartidos y temas claro y
  oscuro.

## M4: persistencia local y modo offline

### Alcance acordado

La primera entrega offline será **solo de consulta**: un usuario con sesión y
datos descargados previamente podrá ver la última copia local. El primer acceso
y la descarga inicial requerirán conexión. Se deberá avisar si la información
puede estar desactualizada y distinguir una lista realmente vacía de datos que
nunca se descargaron. Crear movimientos y metas sin conexión se abordará después.

Se acordó eliminar la copia local del usuario al cerrar sesión, sin borrar sus
datos de Supabase. **Esta limpieza todavía no está implementada.** Antes de
permitir cambios offline habrá que definir cómo proteger los cambios pendientes
frente al cierre de sesión.

### Preparado hasta ahora

- Dependencias de Drift y generación de código configuradas en `pubspec.yaml`.
- `lib/core/database/app_database.dart` define tablas para cuentas, metas,
  movimientos, categorías y metadatos de descargas. Las claves incluyen el
  usuario y los montos locales se representan en **centavos enteros**.
- `lib/core/formatting/money_cents.dart` convierte entre textos decimales y
  centavos sin operaciones de punto flotante. Antes de conectar Supabase hay que
  conservar la precisión desde la respuesta original.
- `BalanceSnapshotState` define estados de carga, captura disponible,
  desactualizada y no disponible; todavía no está conectado a la interfaz.
- `LocalBalanceSnapshotStore` permite leer y reemplazar cuentas, metas y
  metadatos de un usuario en una transacción. Una captura vacía se distingue de
  una ausente; si falla una inserción, se conserva la captura anterior.
- `AppDatabase.persistent()` prepara una base en el directorio de soporte de la
  app, pero la aplicación todavía no la crea. Hay pruebas en memoria y con un
  archivo temporal; **su apertura en Android aún no se ha probado**.
- Las pruebas de claves y consultas filtradas comprueban separación de datos,
  pero **no sustituyen** la futura capa que vincule siempre el acceso al usuario
  autenticado ni la limpieza al cerrar sesión.

### Captura conjunta de Supabase

`supabase/migrations/0003_balance_snapshot.sql` prepara una función de solo
lectura que reúne cuentas y metas activas en una sentencia y devuelve montos
como texto decimal. Está pensada para ejecutarse con los permisos del usuario y
respetar RLS mediante `security invoker`.

**Estado: preparada localmente, no aplicada ni probada en Supabase.** No está
conectada a Drift ni a las pantallas. Antes de usarla hay que validar su SQL,
permisos, listas vacías, montos y aislamiento entre usuarios. El proyecto actual
se usa con datos de prueba; para comprobar el aislamiento harán falta al menos
dos usuarios. Cualquier dato temporal debe identificarse y limpiarse sin afectar
otros registros.

### Pendientes de M4

#### 1. Descarga y actualización local

- [ ] Revisar, aplicar y probar la función conjunta de saldos en un entorno de
      prueba, verificando RLS, listas vacías, montos y un ahorro entre cuenta y
      meta. No aplicar migraciones sin revisar el entorno y sus permisos.
- [ ] Convertir los montos de la respuesta exacta a centavos y validar el
      contenido antes de guardar una captura completa.
- [ ] Conectar la descarga al reemplazo transaccional de Drift; conservar la
      captura anterior ante fallos de red, datos o almacenamiento.
- [ ] Diseñar la descarga de movimientos y categorías, con paginación o una
      estrategia que no marque como completo un historial parcial.
- [ ] Resolver la coherencia de los totales mensuales cuando no se dispone del
      historial completo. Una conexión de red no garantiza acceso a Supabase.

#### 2. Repositorios e interfaz

- [ ] Adaptar gradualmente repositorios y providers de Riverpod para observar
      streams de Drift. La sincronización actualizará la base local y, desde
      ella, la interfaz; las pantallas actuales todavía requieren adaptación.
- [ ] Conectar Inicio y Cuentas y metas a una misma captura coherente.
- [ ] Conectar Movimientos, búsquedas y filtros a los datos locales.
- [ ] Mostrar carga, captura disponible, datos posiblemente desactualizados y
      ausencia de descarga, con opción de reintentar cuando corresponda.
- [ ] Probar la base persistente en Android y revisar el diseño en el teléfono.

#### 3. Sesión y privacidad

- [ ] Verificar el inicio offline con una sesión previamente guardada; no
      asumir que una sesión caducada permita acceso sin validación.
- [ ] Vincular todas las consultas locales al usuario autenticado y evitar que
      una persona vea datos de otra al compartir dispositivo.
- [ ] Implementar y probar la eliminación de la copia local al cerrar sesión.
- [ ] Probar cierres inesperados durante una actualización o limpieza.

#### 4. Pruebas de lectura offline

- [ ] Probar primera instalación sin descarga, listas vacías y fallos de red.
- [ ] Descargar datos, desconectar internet y consultar la app; cerrarla y
      abrirla de nuevo sin conexión.
- [ ] Probar reconexión, actualización, cambio de usuario y datos obsoletos.
- [ ] Verificar saldos, balance total, metas, movimientos y avisos en Android.

### Etapa posterior: escritura y sincronización offline

- [ ] Diseñar una tabla dedicada **`SyncQueue`** para operaciones pendientes,
      preservando dependencias como crear una meta antes de enviar su ahorro.
- [ ] Definir identificadores, orden, reintentos, errores y protección contra
      envíos duplicados. Decidir una fuente de verdad para el estado de envío.
- [ ] Guardar movimientos y metas localmente cuando no haya conexión.
- [ ] Incorporar cambios pendientes a los saldos sin contarlos dos veces.
- [ ] Sincronizar al recuperar acceso a Supabase y resolver rechazos o conflictos.
- [ ] Mostrar al usuario los cambios pendientes y protegerlos al cerrar sesión.
- [ ] Probar interrupciones, fallos, reconexiones y reinicios de la aplicación.

## Decisiones de producto y seguridad

| Tema | Decisión o estado |
| --- | --- |
| Nombre y paquete | Mi Bolsillo; `com.garyj.mibolsillo`. |
| Plataforma inicial | Android; otras plataformas se evaluarán después. |
| Backend | Supabase: PostgreSQL, Auth y RLS. |
| Credenciales en la app | Solo clave pública `anon`/publishable; nunca `service_role`. RLS sigue siendo necesaria. |
| Idiomas | Español e inglés; español como idioma base de la app. |
| Moneda | Solo DOP; formato de presentación `RD$ 86,050.00`. |
| Ahorro | Traslado de cuenta a meta; no es gasto ni cambia el balance total. |
| Datos locales | Drift/SQLite y centavos enteros; la lectura offline aún no está integrada. |
| Acceso futuro | Google y desbloqueo local con huella son planes; no se consideran implementados. |

## Arquitectura y estructura

La app usa Riverpod para estado, GoRouter para navegación, repositorios de datos
y Supabase para las operaciones actuales. La arquitectura offline prevista es:

```text
Pantalla → Riverpod → Repositorio → Drift
                              ↑
                       Sincronización ↔ Supabase
```

La dirección anterior es un **objetivo de M4**, no una descripción de todas las
pantallas actuales. `SyncQueue` y la sincronización aún no existen.

```text
lib/
  app/                 # arranque, rutas y tema
  core/                # configuración, base local, formatos y preferencias
  l10n/                # recursos de idioma y código generado
  shared/widgets/      # componentes visuales compartidos
  features/
    accounts/          # cuentas y saldo inicial
    auth/              # autenticación
    balances/          # estados y almacenamiento local de capturas
    categories/        # modelos y acceso a categorías
    goals/             # metas de ahorro
    home/              # pantalla de Inicio
    movements/         # registro, búsqueda y lista de movimientos
    onboarding/        # tutorial
    placeholder/       # pantallas en construcción
    settings/          # preferencias y sesión
    shell/             # navegación principal
    welcome/           # bienvenida
supabase/migrations/   # esquema y migraciones SQL
test/                  # pruebas automatizadas
```

## Base de datos Supabase

- `0001_init.sql`: perfiles, cuentas, categorías, movimientos, metas, RLS y
  vistas `account_balances` y `goal_balances`.
- `0002_account_balances_initial_balance.sql`: alinea la vista de saldos de
  cuentas e incluye el saldo inicial en su cálculo.
- `0003_balance_snapshot.sql`: función conjunta de saldos **pendiente de aplicar
  y probar**. No asumir que existe en el proyecto remoto.

Las vistas de saldos existentes respetan RLS mediante `security_invoker`. El
proyecto usa datos de prueba; antes de modificar Supabase o limpiar registros,
verificar el entorno, identificar los datos y no borrar información ajena.

## Preparación y comandos

El SDK de Dart requerido está definido en `pubspec.yaml`. Para instalar las
dependencias y ejecutar las comprobaciones:

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter analyze
flutter test
```

Drift genera `lib/core/database/app_database.g.dart`; regenerarlo después de
cambiar las tablas. Para ejecutar con Supabase, copiar `env.example.json` a
`env.json`, completar la URL y la clave pública y ejecutar:

```bash
flutter run --dart-define-from-file=env.json
```

`env.json` está excluido de Git. No incluir contraseñas, tokens de usuario ni
claves privadas en el repositorio. Sin configuración de Supabase, la app puede
arrancar, pero eso **no significa que el modo offline esté implementado**.

La última verificación completa registrada para la etapa de capturas fue de
**67 pruebas aprobadas** y análisis sin problemas. La migración `0003` se creó
después y aún no se ha ejecutado ni validado en PostgreSQL. Ejecutar las pruebas
de nuevo tras cualquier modificación de código.

## Hitos posteriores

1. **M4:** completar lectura offline; después, registro y sincronización.
2. **M5:** edición y archivo de metas.
3. **M6:** análisis por categorías.
4. **M7:** seguridad local, exportación y recordatorios.
5. **M8:** pruebas finales, pulido y publicación.
