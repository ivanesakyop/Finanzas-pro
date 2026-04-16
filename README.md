# Finanzas Pro Web

Esta carpeta es la base de la version web de tu app de finanzas.

## Que contiene

- `public/index.html`
  Version web inicial basada en tu app actual.
- `public/app-config.example.js`
  Plantilla para las variables publicas del frontend.
- `supabase/schema.sql`
  Tablas principales para guardar ingresos, gastos y configuracion.
- `supabase/policies.sql`
  Politicas de seguridad para que cada usuario vea solo sus datos.
- `vercel.json`
  Configuracion simple para publicar esta app en Vercel.

## Estado actual

La app sigue funcionando en modo local dentro del navegador, pero ya esta separada en un proyecto web para que el siguiente paso sea conectar datos en la nube.

## Siguiente fase recomendada

1. Crear un proyecto en Supabase.
2. Ejecutar `schema.sql`.
3. Ejecutar `policies.sql`.
4. Copiar tus credenciales en `public/app-config.js` a partir del archivo de ejemplo.
5. Adaptar el frontend para leer y guardar datos desde Supabase en lugar de `localStorage`.
6. Publicar en Vercel o Netlify.

## Nota importante

Todavia no active login ni persistencia en nube porque para eso necesitamos:

- la URL del proyecto de Supabase
- la clave publica anon
- decidir si quieres acceso solo para ti o para varios usuarios

Cuando quieras, el siguiente paso que hago es conectar esta base a Supabase.
