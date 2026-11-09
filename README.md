# EXTINPLAGAS Y FUMIGACIONES CALI — Aplicativo interno

Aplicativo web de uso interno para la gestión de una empresa de control de plagas, vectores y extintores. Funciona en un solo archivo (`index.html`), sin instalación ni servidor.

## Portales

**Administración** (con contraseña)
- Resumen de órdenes y servicios
- Órdenes de servicio y **calendario** (día, semana, mes) con horas, técnico y tiempos libres
- **Cotizaciones** con documento profesional (mismo formato del informe), editables, IVA por cotización, fotos ilimitadas, lectura de RUT y envío formal por correo con tu autorización
- **Entregas y ventas** de extintores e insumos, con catálogo, inventario y descuento de stock
- **Finanzas** (modelo de «Gestión financiera»): resumen mensual, ventas, pagos con retención e ICA, cartera con estado de cuenta, gastos, socios con reparto de utilidad por línea, informe consolidado imprimible e importación de los datos de la aplicación anterior
- **Recordatorios de cobro** por correo y WhatsApp (con un clic), activables por cliente
- **Certificados y servicios**: extintores, fumigación y seguridad industrial, con vencimientos, encargado, celular, precio habitual y descripción
- **Clientes** con línea de servicio, precio, estado de pago, persona que atiende, instrucciones para el técnico e historial; lectura del RUT en PDF sin IA. **Técnicos**
- **Respaldo y seguridad**: copia de seguridad, restauración y cambio de contraseña

**Técnicos**
- Servicios asignados con hora y dirección
- Check-in con hora y ubicación
- **Informe de servicio** con el formato de la empresa: datos del cliente y del servicio, **plagas y vectores con descripción profesional** (más "Otros"), **varios químicos** (cantidad, unidad y método), notas, recomendaciones específicas y de seguridad con tiempo de reingreso, **fotos sin límite**, firma del cliente, encabezado y pie con numeración de páginas, listo para PDF
- Informe imprimible o en PDF

## Instalarlo como app

Desde la dirección de GitHub Pages se instala en PC, tablet y celular, con ícono propio y funcionamiento sin conexión. Ver `docs/INSTALAR_COMO_APP.md`.

## Cómo usarlo

1. Abre `index.html` en un navegador, o publícalo con GitHub Pages (ver `docs/SUBIR_A_GITHUB.md`).
2. La primera vez que entres como administrador se te pide crear una contraseña y se te entrega un **código de recuperación**. Guárdalo fuera del equipo.
3. Reemplaza los datos de ejemplo: empresa y NIT, tarifas, productos y precios (Cotizaciones → Datos y tarifas, y Entregas y ventas → Catálogo).

## Limitaciones importantes

- **Sin la nube activada, los datos se guardan en el navegador de cada equipo.** Para compartir información entre administrador y técnicos se activa Supabase (ver `docs/NUBE_SUPABASE.md`, es gratuito).
- **Haz copias de seguridad con frecuencia** (pestaña Respaldo y seguridad). Si se borran los datos del navegador, se pierden.
- La contraseña es una **barrera básica**, no seguridad real (ver `docs/SEGURIDAD_Y_RESPALDOS.md`).
- Los recordatorios de cobro **no se envían solos**: abren el correo o WhatsApp con el mensaje redactado.
- La **lectura del RUT en PDF** funciona en cualquier lugar. La lectura de **fotos del RUT** y la **generación de cotizaciones con IA** dependen de Claude y solo funcionan publicadas en claude.ai.
- El **envío de correos** abre Gmail o tu aplicación de correo con el mensaje listo; no se envía solo.
- Los valores de ejemplo (precios, NIT, productos) son provisionales.

## Estructura del repositorio

```
index.html                  Aplicativo completo
config.js                   Conexión a la nube (desactivada por defecto)
manifest.webmanifest        Datos para instalarlo como app
sw.js                       Funcionamiento sin conexión y actualizaciones
icons/                      Íconos de la app
README.md                   Este archivo
CHANGELOG.md                Historial de funciones
.gitignore                  Evita subir respaldos y documentos con datos de clientes
docs/
  MANUAL_USUARIO.md         Guía de uso por portal
  SEGURIDAD_Y_RESPALDOS.md  Contraseña, recuperación y copias de seguridad
  ROADMAP.md                Pendientes y arquitectura recomendada
  SUBIR_A_GITHUB.md         Pasos para publicar el repositorio
  INSTALAR_COMO_APP.md      Instalar en PC, tablet y celular
  MIGRACION.md              Cómo traer la información de otra aplicación
  PASO_A_PASO_NUBE.md       Guía detallada para compartir datos entre dispositivos
  NUBE_SUPABASE.md          Datos compartidos entre administrador y técnicos
  supabase_operaciones.sql  Script de la base de datos en Supabase
```

## Tecnologías

HTML, CSS y JavaScript sin dependencias. Carga `pdf.js` desde cdnjs solo para leer RUT en PDF y la fuente Public Sans desde Google Fonts.
