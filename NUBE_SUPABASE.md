# Datos compartidos con Supabase

Con esto el administrador y los técnicos trabajan sobre la misma información, desde cualquier equipo o celular: lo que el técnico registra en campo (informes, fotos, firma) aparece en el panel del administrador, y las órdenes que crea el administrador aparecen en el celular del técnico.

## Por qué Supabase
- Plan gratuito suficiente para esta operación: 500 MB de base de datos, 1 GB para fotos, 50.000 usuarios activos y 5 GB de transferencia al mes.
- Incluye usuarios con contraseña, base de datos, almacenamiento de fotos y actualización en tiempo real.
- Ya usas Supabase en tu aplicación de Gestión financiera: puedes **reutilizar el mismo proyecto** (el plan gratuito permite 2 proyectos activos). Las tablas nuevas llevan el prefijo `ops_` y no tocan las de la otra aplicación.

## Límites del plan gratuito que debes conocer
- **Pausa por inactividad:** un proyecto gratuito se pausa si pasa 1 semana sin actividad. Se reactiva desde el panel de Supabase y los datos se conservan. Usándolo a diario no ocurre.
- **Sin copias de seguridad automáticas.** Descarga un respaldo desde **Respaldo y seguridad** cada semana.
- Con fotos de ~100 a 150 KB, 1 GB alcanza para varios miles de fotos.

## Paso a paso (unos 15 minutos)

### 1. Preparar la base de datos
1. Entra a supabase.com y abre tu proyecto.
2. Menú **SQL Editor** → **New query**.
3. Pega TODO el contenido de `docs/supabase_operaciones.sql` y pulsa **Run**.
4. El script ya deja como administrador al usuario `jeanc200129@gmail.com` (debe existir en Authentication → Users). Si usas otro correo, cámbialo en la última sección del script antes de ejecutarlo.

### 2. Cerrar el registro público
**Authentication → Providers → Email** y desactiva **Allow new users to sign up**. Solo tú creas las cuentas.

### 3. Crear las cuentas de los técnicos
Para cada técnico:
1. **Authentication → Users → Add user → Create new user**: correo y contraseña temporal.
2. En **SQL Editor** ejecuta (cambiando el correo):
   ```sql
   insert into public.ops_members (user_id, role)
   select id, 'tecnico' from auth.users where email = 'correo.del.tecnico@gmail.com'
   on conflict (user_id) do update set role = 'tecnico';
   ```
3. En la aplicación: **Técnicos → Nuevo técnico**, con el mismo correo en «Correo de acceso». Así la aplicación sabe qué órdenes le corresponden.

### 4. Activar la nube en la aplicación
1. En el repositorio de GitHub abre `config.js`.
2. Reemplaza `window.OPS_CLOUD = null;` por la línea comentada que sigue (quita las dos barras `//`). Ya trae la URL y la clave pública de tu proyecto.
3. Guarda (commit). Espera unos minutos y recarga la página con Ctrl + F5.

### 5. Primer ingreso
1. Entra con tu correo de administrador. Como la nube está vacía, la aplicación te pregunta:
   - **Subir los datos de este equipo a la nube**: elige esta opción en el equipo donde ya tienes tu información.
   - **Empezar vacío**.
2. A partir de ahí, todo se guarda solo. La barra lateral muestra «Nube: sincronizado».
3. Los técnicos entran con su correo y contraseña desde el celular. Verán solo sus servicios.

## Qué ve cada rol
| | Administrador | Técnico |
|---|---|---|
| Órdenes, clientes, técnicos | Todo | Solo lectura (sus servicios) |
| Informes de servicio | Todo | Crea y completa los suyos |
| Cotizaciones, finanzas, cartera, entregas | Todo | No tiene acceso (lo bloquea la base de datos) |

## Cosas que debes cuidar
- **Un solo administrador creando registros a la vez.** Si dos personas editan exactamente el mismo registro al mismo tiempo, prevalece el último que guarda.
- **No cierres sesión con «sin conexión».** Espera a que diga «sincronizado».
- Las fotos nuevas se suben al tomarlas; si no hay internet, se reintentan al volver a entrar.
- **Cambia la contraseña de tu cuenta** si la compartiste por chat o por correo.
- Nunca pegues la clave `service_role` en ningún archivo.

## Si algo falla
- **«Tu usuario no tiene acceso»**: falta la fila en `ops_members` (paso 3.2) o no ejecutaste el SQL.
- **«Tu correo no está asignado a ningún técnico»**: falta crear el técnico en la aplicación con el mismo correo (paso 3.3).
- **Pantalla de ingreso no aparece**: `config.js` sigue en `null` o no se subió a la raíz del repositorio.
- **Proyecto pausado**: ábrelo en supabase.com y pulsa **Restore project**.
