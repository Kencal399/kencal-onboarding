-- Adds a separate "work state" field, distinct from the candidate's home
-- address state. This is what actually determines the correct state
-- withholding form — residence and work state are usually the same, but
-- not always (e.g. lives in NJ, works in CT). Defaults to match residence
-- at application time, and can be corrected later once the real work
-- site is known, without touching the address itself.
alter table candidates add column if not exists work_state text;
