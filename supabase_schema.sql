-- ============================================================
-- SM GT TRACKER — Supabase Schema + Seed + RLS
-- Project: https://ndsrnrwppoxtfgxalqhc.supabase.co
-- Run this once in the Supabase SQL Editor
-- ============================================================

-- ===== 1. TABLES =====

CREATE TABLE states (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  state text NOT NULL,
  zone text,
  status text DEFAULT 'active',
  note text,
  super_dist_target int DEFAULT 0,
  value_target numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE super_dists (
  id text PRIMARY KEY,
  state_id uuid REFERENCES states(id) ON DELETE CASCADE,
  company text,
  location text,
  contact text,
  appointed_date date,
  status text DEFAULT 'partial',
  value_allocation numeric DEFAULT 0,
  micro_dist_target int DEFAULT 0
);

CREATE TABLE micro_dists (
  id text PRIMARY KEY,
  super_dist_id text REFERENCES super_dists(id) ON DELETE CASCADE,
  district text,
  value_allocation numeric DEFAULT 0,
  retailer_target int DEFAULT 0,
  active_retailers int DEFAULT 0,
  cat_a_retailers int DEFAULT 0,
  value_achievement numeric DEFAULT 0
);

CREATE TABLE action_items (
  id text PRIMARY KEY,
  state_id uuid REFERENCES states(id) ON DELETE CASCADE,
  text text,
  added_date date,
  status text DEFAULT 'open',
  resolved_date date,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE reviews (
  id text PRIMARY KEY,
  state_id uuid REFERENCES states(id) ON DELETE CASCADE,
  date date,
  reviewer text,
  sd_count int,
  state_value numeric DEFAULT 0,
  wins text,
  issues text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE review_md_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id text REFERENCES reviews(id) ON DELETE CASCADE,
  micro_dist_id text REFERENCES micro_dists(id),
  value_achievement numeric DEFAULT 0,
  active_retailers int DEFAULT 0,
  cat_a_retailers int DEFAULT 0
);

CREATE TABLE review_action_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id text REFERENCES reviews(id) ON DELETE CASCADE,
  action_item_id text REFERENCES action_items(id),
  link_type text
);

-- ===== 2. SEED: 13 ACTIVE STATES =====

INSERT INTO states (state, zone, status, super_dist_target, value_target) VALUES
  ('Uttar Pradesh',    'North', 'active', 2, 0),
  ('Delhi',            'North', 'active', 1, 0),
  ('Rajasthan',        'North', 'active', 1, 0),
  ('Haryana',          'North', 'active', 1, 0),
  ('Jammu & Kashmir',  'North', 'active', 1, 0),
  ('West Bengal',      'East',  'active', 1, 0),
  ('Maharashtra',      'West',  'active', 2, 0),
  ('Gujarat',          'West',  'active', 1, 0),
  ('Karnataka',        'South', 'active', 1, 0),
  ('Kerala',           'South', 'active', 1, 0),
  ('Andhra Pradesh',   'South', 'active', 1, 0),
  ('Telangana',        'South', 'active', 1, 0),
  ('Tamil Nadu',       'South', 'active', 1, 0);

-- ===== 3. SEED: SUPER DISTRIBUTORS =====

INSERT INTO super_dists (id, state_id, company, location, status, value_allocation, micro_dist_target)
SELECT 'sd-up1',  id, '[To be added]', 'Lucknow / West UP', 'partial', 0, 4 FROM states WHERE state='Uttar Pradesh'
UNION ALL
SELECT 'sd-del1', id, '[To be added]', 'Delhi',             'partial', 0, 3 FROM states WHERE state='Delhi'
UNION ALL
SELECT 'sd-raj1', id, '[To be added]', 'Jaipur',            'partial', 0, 2 FROM states WHERE state='Rajasthan'
UNION ALL
SELECT 'sd-har1', id, '[To be added]', 'Gurugram',          'partial', 0, 2 FROM states WHERE state='Haryana'
UNION ALL
SELECT 'sd-jk1',  id, '[To be added]', 'Srinagar',          'partial', 0, 1 FROM states WHERE state='Jammu & Kashmir'
UNION ALL
SELECT 'sd-wb1',  id, '[To be added]', 'Kolkata',           'partial', 0, 2 FROM states WHERE state='West Bengal'
UNION ALL
SELECT 'sd-mh1',  id, '[To be added]', 'Mumbai',            'partial', 0, 3 FROM states WHERE state='Maharashtra'
UNION ALL
SELECT 'sd-mh2',  id, '[To be added]', 'Nagpur',            'partial', 0, 2 FROM states WHERE state='Maharashtra'
UNION ALL
SELECT 'sd-guj1', id, '[To be added]', 'Ahmedabad',         'partial', 0, 2 FROM states WHERE state='Gujarat'
UNION ALL
SELECT 'sd-kar1', id, '[To be added]', 'Bengaluru',         'partial', 0, 2 FROM states WHERE state='Karnataka'
UNION ALL
SELECT 'sd-ker1', id, '[To be added]', 'Kochi',             'partial', 0, 2 FROM states WHERE state='Kerala'
UNION ALL
SELECT 'sd-ap1',  id, '[To be added]', 'Visakhapatnam',     'partial', 0, 2 FROM states WHERE state='Andhra Pradesh'
UNION ALL
SELECT 'sd-tel1', id, '[To be added]', 'Hyderabad',         'partial', 0, 2 FROM states WHERE state='Telangana'
UNION ALL
SELECT 'sd-tn1',  id, '[To be added]', 'Chennai',           'partial', 0, 3 FROM states WHERE state='Tamil Nadu';

-- ===== 4. SEED: MICRO DISTRIBUTORS =====

INSERT INTO micro_dists (id, super_dist_id, district, value_allocation, retailer_target, active_retailers, cat_a_retailers, value_achievement)
VALUES
  -- UP
  ('md-up1',  'sd-up1',  'Lucknow',              0,0,0,0,0),
  ('md-up2',  'sd-up1',  'Kanpur',               0,0,0,0,0),
  ('md-up3',  'sd-up1',  'Varanasi',             0,0,0,0,0),
  ('md-up4',  'sd-up1',  'Agra',                 0,0,0,0,0),
  -- Delhi
  ('md-del1', 'sd-del1', 'North Delhi',          0,0,0,0,0),
  ('md-del2', 'sd-del1', 'South Delhi',          0,0,0,0,0),
  ('md-del3', 'sd-del1', 'East Delhi',           0,0,0,0,0),
  -- Rajasthan
  ('md-raj1', 'sd-raj1', 'Jaipur',               0,0,0,0,0),
  ('md-raj2', 'sd-raj1', 'Kota',                 0,0,0,0,0),
  -- Haryana
  ('md-har1', 'sd-har1', 'Gurugram',             0,0,0,0,0),
  ('md-har2', 'sd-har1', 'Faridabad',            0,0,0,0,0),
  -- J&K
  ('md-jk1',  'sd-jk1',  'Srinagar',             0,0,0,0,0),
  -- West Bengal
  ('md-wb1',  'sd-wb1',  'Kolkata',              0,0,0,0,0),
  ('md-wb2',  'sd-wb1',  'Howrah',               0,0,0,0,0),
  -- Maharashtra
  ('md-mh1',  'sd-mh1',  'Mumbai',               0,0,0,0,0),
  ('md-mh2',  'sd-mh1',  'Thane',                0,0,0,0,0),
  ('md-mh3',  'sd-mh1',  'Pune',                 0,0,0,0,0),
  ('md-mh4',  'sd-mh2',  'Nagpur',               0,0,0,0,0),
  ('md-mh5',  'sd-mh2',  'Nashik',               0,0,0,0,0),
  -- Gujarat
  ('md-guj1', 'sd-guj1', 'Ahmedabad',            0,0,0,0,0),
  ('md-guj2', 'sd-guj1', 'Surat',                0,0,0,0,0),
  -- Karnataka
  ('md-kar1', 'sd-kar1', 'Bengaluru Urban',      0,0,0,0,0),
  ('md-kar2', 'sd-kar1', 'Bengaluru Rural',      0,0,0,0,0),
  -- Kerala
  ('md-ker1', 'sd-ker1', 'Kochi',                0,0,0,0,0),
  ('md-ker2', 'sd-ker1', 'Thiruvananthapuram',   0,0,0,0,0),
  -- Andhra Pradesh
  ('md-ap1',  'sd-ap1',  'Visakhapatnam',        0,0,0,0,0),
  ('md-ap2',  'sd-ap1',  'Vijayawada',           0,0,0,0,0),
  -- Telangana
  ('md-tel1', 'sd-tel1', 'Hyderabad',            0,0,0,0,0),
  ('md-tel2', 'sd-tel1', 'Secunderabad',         0,0,0,0,0),
  -- Tamil Nadu
  ('md-tn1',  'sd-tn1',  'Chennai',              0,0,0,0,0),
  ('md-tn2',  'sd-tn1',  'Coimbatore',           0,0,0,0,0),
  ('md-tn3',  'sd-tn1',  'Madurai',              0,0,0,0,0);

-- ===== 5. ROW LEVEL SECURITY =====

ALTER TABLE states            ENABLE ROW LEVEL SECURITY;
ALTER TABLE super_dists       ENABLE ROW LEVEL SECURITY;
ALTER TABLE micro_dists       ENABLE ROW LEVEL SECURITY;
ALTER TABLE action_items      ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews           ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_md_data    ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_action_links ENABLE ROW LEVEL SECURITY;

-- Permissive policies for anon role (URL-controlled access, same pattern as existing dashboards)
CREATE POLICY "anon_all" ON states            FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON super_dists       FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON micro_dists       FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON action_items      FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON reviews           FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON review_md_data    FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all" ON review_action_links FOR ALL TO anon USING (true) WITH CHECK (true);
