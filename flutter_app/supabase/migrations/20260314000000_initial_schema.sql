-- Stroke Mitra — Supabase Migration
-- Creates the sessions and session_data tables
-- with RLS policies for public access (matching original app behavior).

-- ═══════════════════════════════════════════
-- 1. SESSIONS TABLE
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  completed_at TIMESTAMPTZ,
  is_completed BOOLEAN DEFAULT false NOT NULL,
  device_info JSONB
);

-- ═══════════════════════════════════════════
-- 2. SESSION DATA TABLE (child of sessions)
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.session_data (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES public.sessions(id) ON DELETE CASCADE NOT NULL,
  data_type TEXT NOT NULL CHECK (data_type IN ('face', 'voice', 'motion')),
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- ═══════════════════════════════════════════
-- 3. INDEXES
-- ═══════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_session_data_session_id ON public.session_data(session_id);
CREATE INDEX IF NOT EXISTS idx_session_data_type ON public.session_data(data_type);

-- ═══════════════════════════════════════════
-- 4. ROW LEVEL SECURITY
-- ═══════════════════════════════════════════
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_data ENABLE ROW LEVEL SECURITY;

-- Public access policies (original app has no auth)
CREATE POLICY "Allow public read sessions"
  ON public.sessions FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert sessions"
  ON public.sessions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public update sessions"
  ON public.sessions FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public read session_data"
  ON public.session_data FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert session_data"
  ON public.session_data FOR INSERT
  WITH CHECK (true);
