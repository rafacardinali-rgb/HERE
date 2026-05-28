-- Tabla waitlist
CREATE TABLE IF NOT EXISTS waitlist (
  id         uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text        NOT NULL,
  email      text        NOT NULL UNIQUE,
  avatar_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;

-- Cualquier visitante puede inscribirse
CREATE POLICY "public insert" ON waitlist
  FOR INSERT TO anon WITH CHECK (true);

-- Solo usuarios autenticados (vos) pueden ver la lista
CREATE POLICY "auth select" ON waitlist
  FOR SELECT TO authenticated USING (true);

-- Función pública que devuelve el conteo (sin exponer los datos)
CREATE OR REPLACE FUNCTION get_waitlist_count()
RETURNS integer
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COUNT(*)::integer FROM waitlist;
$$;
