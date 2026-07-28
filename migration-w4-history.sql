-- Preserves the prior W-4 whenever a genuine new signing event happens
-- (a real life change, not a typo correction) — so updating someone's
-- W-4 after marriage/a new dependent doesn't silently erase the version
-- that was actually in effect before.
create table if not exists w4_federal_history (
  id                       uuid primary key default gen_random_uuid(),
  candidate_id             uuid references candidates(id) on delete cascade,
  filing_status            text,
  multiple_jobs_checkbox   boolean,
  qualifying_children_count int,
  other_dependents_count   int,
  dependents_amount        numeric,
  other_income             numeric,
  deductions               numeric,
  extra_withholding        numeric,
  exempt                   boolean,
  signature_data           text,
  signed_at                timestamptz,
  form_date                date,
  archived_at              timestamptz default now(),
  reason                   text
);
alter table w4_federal_history enable row level security;
drop policy if exists "admin_full_access_w4_history" on w4_federal_history;
create policy "admin_full_access_w4_history" on w4_federal_history for all using (is_admin());
drop policy if exists "intake_full_access_w4_history" on w4_federal_history;
create policy "intake_full_access_w4_history" on w4_federal_history for all using (is_intake());
drop policy if exists "hr_read_w4_history" on w4_federal_history;
create policy "hr_read_w4_history" on w4_federal_history for select using (is_hr());
