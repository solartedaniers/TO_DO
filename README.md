# ECOMMERCE

Ecommerce de ejemplo en Flutter utilizando **Clean Architecture** y **Supabase**.

## Configuración de variables de entorno

1. Copia el archivo `.env.example` y renómbralo a `.env` en la raíz del proyecto.
2. Rellena los valores:

   ```text
   SUPABASE_URL=https://qxnawrzaorzfyxfrjxlo.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4bmF3cnphb3J6Znl4ZnJqeGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NzAyOTgsImV4cCI6MjA4OTQ0NjI5OH0.oVAi1M4Xytkjbd4V5ZciJLKGJa2xXqpjg9Ljmd5UbY8

   ```

   - `SUPABASE_URL`: en Supabase Dashboard → Project Settings → API → Project URL.
   - `SUPABASE_ANON_KEY`: en Supabase Dashboard → Project Settings → API → Project API keys → `anon` (public).

3. Asegúrate de que el archivo `.env` **no** se sube al repositorio (ya está añadido a `.gitignore`).

## Arrancar la app

```bash
flutter pub get
flutter run
```

## Base de datos: tabla `products` en Supabase

### Script para crear la tabla

Ejecuta este script en el SQL Editor de Supabase (o contra tu base de datos Postgres del proyecto):

```sql
-- Crear extensión UUID si aún no existe (opcional, pero recomendado)
create extension if not exists "uuid-ossp";

-- Tabla products
create table public.products (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  price numeric(10, 2) not null,
  description text not null,
  image_url text not null,
  created_at timestamp with time zone default now() not null
);

-- Índice opcional por nombre (búsquedas por nombre más rápidas)
create index if not exists idx_products_name on public.products (name);
```

### Script de ejemplo para insertar productos

```sql
insert into public.products (name, price, description, image_url)
values
  (
    'Nike Air Max 270',
    150.00,
    'Men''s Shoes',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1000&auto=format&fit=crop'
  ),
  (
    'Nike Blazer Mid 77',
    100.00,
    'Vintage Shoes',
    'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'
  ),
  (
    'Nike Air Force 1',
    110.00,
    'Classic Shoes',
    'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?q=80&w=1000&auto=format&fit=crop'
  ),
  (
    'Nike React Infinity',
    160.00,
    'Running Shoes',
    'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?q=80&w=1000&auto=format&fit=crop'
  );
```

