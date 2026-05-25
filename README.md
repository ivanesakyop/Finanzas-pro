# Finanzas Pro

App web de control financiero personal. Registra ingresos y gastos, visualiza por categoría y cliente, y sincroniza datos entre dispositivos vía Supabase.

## Stack

- **Frontend:** React 18 (CDN) + Babel standalone — sin paso de build
- **Auth:** Supabase magic link (OTP por correo)
- **Base de datos:** Supabase (PostgreSQL) con Row Level Security
- **Almacenamiento offline:** `localStorage` como fallback
- **Deploy:** Vercel — `https://finanzas-pro-zeta.vercel.app`

## Estructura

```
public/
  index.html          # App completa (React + JSX en un solo archivo)
  app-config.js       # Credenciales locales (no commitear — ver .gitignore)
  app-config.example.js  # Plantilla de configuración
supabase/
  schema.sql          # Tablas: ingresos, gastos, profiles, user_settings
  policies.sql        # RLS: cada usuario accede solo a sus datos
vercel.json           # Configuración de deploy
```

## Configuración local

1. Copia el archivo de ejemplo:
   ```bash
   cp public/app-config.example.js public/app-config.js
   ```
2. Llena tus credenciales de Supabase en `app-config.js`:
   ```js
   window.FINANZAS_CONFIG = {
     storageMode: "supabase",
     supabaseUrl: "https://TU_PROYECTO.supabase.co",
     supabaseAnonKey: "TU_CLAVE_ANON",
   };
   ```
3. Abre `public/index.html` en el navegador o sirve la carpeta `public/` con cualquier servidor estático.

## Funcionalidades

- **Dashboard** — resumen del mes, gráfica de flujo, donut por categoría, top clientes
- **Comparativo** — comparación entre meses con gráfica de barras y tendencia
- **Ingresos / Gastos** — listado con filtros por período y categoría, búsqueda, eliminación
- **Por Categoría** — concentración de gasto por categoría
- **Por Cliente** — ranking de clientes por ingreso
- **Modo claro / oscuro**
- **Sincronización en la nube** — los datos se guardan en Supabase y están disponibles en cualquier dispositivo al iniciar sesión

## Seguridad

- RLS habilitado en todas las tablas (`auth.uid() = user_id`)
- Auth sin contraseñas — solo magic link por correo
- `app-config.js` excluido de git para evitar exponer credenciales
- Redirect URLs de Supabase restringidas al dominio de producción y localhost
