# EXTINPLAGAS Y FUMIGACIONES CALI — Aplicativo interno

Aplicativo web de uso interno para la gestión de una empresa de control de plagas, vectores y extintores. Funciona en un solo archivo (`index.html`), sin instalación ni servidor.

## Portales

**Administración** (con contraseña)
- Resumen de órdenes y servicios
- Órdenes de servicio y **calendario** (día, semana, mes) con horas, técnico y tiempos libres
- **Cotizaciones** estandarizadas, editables, con IVA por cotización, fotos de productos y lectura de RUT
- **Entregas y ventas** de extintores e insumos, con catálogo, inventario y descuento de stock
- **Finanzas**: ingresos, gastos, facturas, anticipos, retenciones, estado de resultados y cartera
- **Recordatorios de cobro** por correo y WhatsApp (con un clic), activables por cliente
- **Fumigación y extintores**: vencimientos, encargado, celular, precio habitual y descripción
- **Clientes** con historial completo y **Técnicos**
- **Respaldo y seguridad**: copia de seguridad, restauración y cambio de contraseña

**Técnicos**
- Servicios asignados con hora y dirección
- Check-in con hora y ubicación
- **Informe de servicio**: actividad, plagas, nivel de infestación, producto, dosis, método, área, fotos, firma del cliente, observaciones, recomendaciones y próxima visita
- Informe imprimible o en PDF

## Cómo usarlo

1. Abre `index.html` en un navegador, o publícalo con GitHub Pages (ver `docs/SUBIR_A_GITHUB.md`).
2. La primera vez que entres como administrador se te pide crear una contraseña y se te entrega un **código de recuperación**. Guárdalo fuera del equipo.
3. Reemplaza los datos de ejemplo: empresa y NIT, tarifas, productos y precios (Cotizaciones → Datos y tarifas, y Entregas y ventas → Catálogo).

## Limitaciones importantes

- **Los datos se guardan en el navegador de cada equipo** (almacenamiento local). El administrador no ve lo que registra un técnico desde su celular. Hacen falta una base de datos compartida y usuarios (ver `docs/ROADMAP.md`).
- **Haz copias de seguridad con frecuencia** (pestaña Respaldo y seguridad). Si se borran los datos del navegador, se pierden.
- La contraseña es una **barrera básica**, no seguridad real (ver `docs/SEGURIDAD_Y_RESPALDOS.md`).
- Los recordatorios de cobro **no se envían solos**: abren el correo o WhatsApp con el mensaje redactado.
- La **lectura de RUT** y la **generación de cotizaciones con IA** dependen de Claude y solo funcionan cuando la página está publicada en claude.ai. Fuera de ahí, la página avisa que no están disponibles y se llenan los datos a mano. Todo lo demás funciona igual.
- Los valores de ejemplo (precios, NIT, productos) son provisionales.

## Estructura del repositorio

```
index.html                  Aplicativo completo
README.md                   Este archivo
CHANGELOG.md                Historial de funciones
.gitignore                  Evita subir respaldos y documentos con datos de clientes
docs/
  MANUAL_USUARIO.md         Guía de uso por portal
  SEGURIDAD_Y_RESPALDOS.md  Contraseña, recuperación y copias de seguridad
  ROADMAP.md                Pendientes y arquitectura recomendada
  SUBIR_A_GITHUB.md         Pasos para publicar el repositorio
```

## Tecnologías

HTML, CSS y JavaScript sin dependencias. Carga `pdf.js` desde cdnjs solo para leer RUT en PDF y la fuente Public Sans desde Google Fonts.
