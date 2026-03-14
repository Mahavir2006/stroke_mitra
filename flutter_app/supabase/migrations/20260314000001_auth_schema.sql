-- Stroke Mitra — Authentication Schema
-- Creates profiles table, enables RLS, and adds triggers for new users.

-- ═══════════════════════════════════════════
-- 1. PROFILES TABLE
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT,
  risk_history_reference JSONB,
  last_login TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- ═══════════════════════════════════════════
-- 2. ROW LEVEL SECURITY
-- ═══════════════════════════════════════════
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile."
  ON public.profiles FOR SELECT
  USING ( auth.uid() = id );

CREATE POLICY "Users can update own profile."
  ON public.profiles FOR UPDATE
  USING ( auth.uid() = id )
  WITH CHECK ( auth.uid() = id );

-- ═══════════════════════════════════════════
-- 3. TRIGGERS FOR NEW USERS
-- ═══════════════════════════════════════════
-- Function to automatically create a profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, user_id, email, full_name, created_at)
  VALUES (
    new.id,
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    now()
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function on insert into auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
