-- ============================================================
-- SM GT TRACKER — Migration v2
-- Run this in Supabase SQL Editor (safe to run on existing DB)
-- ============================================================

-- Fix 1: Add Date of Birth to super_dists
ALTER TABLE super_dists ADD COLUMN IF NOT EXISTS dob date;

-- Fix 3: Add collection target + current achievement to super_dists
ALTER TABLE super_dists ADD COLUMN IF NOT EXISTS collection_target    numeric DEFAULT 0;
ALTER TABLE super_dists ADD COLUMN IF NOT EXISTS collection_achievement numeric DEFAULT 0;

-- Fix 3: New table to store SD-level collection per review (for history)
CREATE TABLE IF NOT EXISTS review_sd_data (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id       text REFERENCES reviews(id) ON DELETE CASCADE,
  super_dist_id   text REFERENCES super_dists(id),
  collection_achievement numeric DEFAULT 0
);

ALTER TABLE review_sd_data ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON review_sd_data;
CREATE POLICY "anon_all" ON review_sd_data FOR ALL TO anon USING (true) WITH CHECK (true);
GRANT ALL ON review_sd_data TO anon;
