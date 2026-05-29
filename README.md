# Finanzas Pro

App web de control financiero para empresas. Registra ingresos y gastos, visualiza por categoría y cliente, importa plantillas desde Excel y sincroniza datos entre dispositivos vía Supabase. Instalable como PWA en escritorio y móvil.

## Stack

- **Frontend:** React 18 (CDN) + Babel standalone — sin paso de build
- **Auth:** Supabase magic link (OTP por correo)
- **Base de datos:** Supabase (PostgreSQL) con Row Level Security
- **Almacenamiento offline:** `localStorage` como fallback y caché local
- **Excel:** SheetJS (xlsx 0.20.3) vía CDN para importar plantillas
- **PWA:** Service worker + manifest.json — instalable en Chrome, Edge, Safari (iOS) y Android
- **Deploy:** Vercel — `https://finanzas-pro-zeta.vercel.app`

## Estructura

```
public/
  index.html            # App completa (React + JSX en un solo archivo)
  app-config.js         # Credenciales locales (no commitear — ver .gitignore)
  app-config.example.js # Plantilla de configuración
  manifest.json         # Metadatos PWA (nombre, colores, íconos)
  sw.js                 # Service worker — caché offline
  icon-192.png          # Ícono PWA 192×192
  icon-512.png          # Ícono PWA 512×512
supabase/
  schema.sql            # Tablas: ingresos, gastos, profiles, user_settings, montos_fijos
  policies.sql          # RLS: cada usuario accede solo a sus datos
vercel.json             # Configuración de deploy
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

- **Dashboard** — resumen del mes, gráfica de flujo, donut por categoría, top clientes, banner de carga rápida con plantilla fija
- **Comparativo** — comparación entre meses con gráfica de barras y tendencia de balance
- **Ingresos** — listado con filtros por período, búsqueda, edición inline y autocompletado de clientes conocidos
- **Gastos** — listado con filtros por período y categoría, búsqueda y edición inline
- **Por Categoría** — concentración de gasto por categoría con gráfica de dona
- **Por Cliente** — ranking de clientes por ingreso con detalle mensual
- **Montos Fijos** — plantilla reutilizable de ingresos y gastos mensuales con edición inline; se carga en un clic al inicio de cada mes
- **Importar desde Excel** — sube un `.xlsx` con columnas `Tipo / Nombre / Monto` y los datos se importan automáticamente como plantilla fija
- **Categorías personalizadas** — agrega categorías de gasto propias desde el modal de registro; se guardan en el navegador y aparecen en todas las vistas
- **Modo claro / oscuro**
- **Sincronización en la nube** — los datos se guardan en Supabase y están disponibles en cualquier dispositivo al iniciar sesión
- **Instalable como app (PWA)** — en Chrome/Edge aparece el botón de instalación; en iOS usa "Agregar a pantalla de inicio" desde Safari

## Formato Excel para importar plantilla

El archivo debe tener una hoja con los encabezados en la primera fila:

| Tipo    | Nombre            | Monto |
|---------|-------------------|-------|
| ingreso | Cliente A         | 15000 |
| ingreso | Cliente B         | 8000  |
| gasto   | Nómina quincena   | 12000 |
| gasto   | Combustible       | 0     |

- `Tipo`: `ingreso` o `gasto` (en minúsculas)
- `Nombre`: texto libre
- `Monto`: número; usar `0` para gastos que se editarán después
- Los gastos se asignan a una categoría automáticamente según el nombre; los que no coincidan quedan en "Otros"

## Seguridad

- RLS habilitado en todas las tablas (`auth.uid() = user_id`)
- Auth sin contraseñas — solo magic link por correo
- `app-config.js` excluido de git para evitar exponer credenciales
- Redirect URLs de Supabase restringidas al dominio de producción y localhost
