-- HIYU 員工店務系統 V1
-- 請在 Supabase SQL Editor 執行
alter table employees add column if not exists employee_no text;
alter table employees add column if not exists hire_date date;
alter table employees add column if not exists phone text;
alter table employees add column if not exists monthly_salary numeric;
alter table employees add column if not exists notes text;
alter table daily_closings add column if not exists other_payment numeric default 0;
alter table daily_closings add column if not exists cash_difference numeric default 0;

create table if not exists leave_requests(
 id uuid primary key default gen_random_uuid(), employee_id uuid references employees(id), leave_date date not null,
 reason text, status text default 'pending', approved_by uuid, approved_at timestamptz, created_at timestamptz default now());

create table if not exists attendance_corrections(
 id uuid primary key default gen_random_uuid(), employee_id uuid references employees(id), work_date date not null,
 reason text, requested_clock_in timestamptz, requested_clock_out timestamptz, status text default 'pending',
 approved_by uuid, approved_at timestamptz, created_at timestamptz default now());

create table if not exists announcements(
 id uuid primary key default gen_random_uuid(), title text not null, content text not null,
 priority text default '一般', is_published boolean default false, publish_at timestamptz default now(), created_at timestamptz default now());

create table if not exists announcement_reads(
 id uuid primary key default gen_random_uuid(), announcement_id uuid references announcements(id) on delete cascade,
 employee_id uuid references employees(id) on delete cascade, read_at timestamptz default now(),
 unique(announcement_id,employee_id));

create table if not exists work_tasks(
 id uuid primary key default gen_random_uuid(), task_date date not null, title text not null,
 description text, sort_order int default 0, created_at timestamptz default now());

create table if not exists daily_handover(
 id uuid primary key default gen_random_uuid(), work_date date not null, employee_id uuid references employees(id),
 cash numeric default 0, line_pay numeric default 0, other_payment numeric default 0,
 expenses numeric default 0, cash_difference numeric default 0, notes text, created_at timestamptz default now());

create table if not exists audit_logs(
 id uuid primary key default gen_random_uuid(), actor_user_id uuid, action text not null,
 table_name text, record_id uuid, before_data jsonb, after_data jsonb, created_at timestamptz default now());

create index if not exists idx_leave_date on leave_requests(leave_date);
create index if not exists idx_correction_date on attendance_corrections(work_date);
create index if not exists idx_announcement_publish on announcements(publish_at,is_published);
create index if not exists idx_task_date on work_tasks(task_date);
create index if not exists idx_handover_date on daily_handover(work_date);

alter table leave_requests enable row level security;
alter table attendance_corrections enable row level security;
alter table announcements enable row level security;
alter table announcement_reads enable row level security;
alter table work_tasks enable row level security;
alter table daily_handover enable row level security;
alter table audit_logs enable row level security;

-- 先以 authenticated 店務帳號使用；正式上線前可再依 employee_id 做更細的 RLS
create policy "auth read leave" on leave_requests for select to authenticated using (true);
create policy "auth insert leave" on leave_requests for insert to authenticated with check (true);
create policy "auth update leave" on leave_requests for update to authenticated using (true);

create policy "auth read correction" on attendance_corrections for select to authenticated using (true);
create policy "auth insert correction" on attendance_corrections for insert to authenticated with check (true);
create policy "auth update correction" on attendance_corrections for update to authenticated using (true);

create policy "auth read announcements" on announcements for select to authenticated using (true);
create policy "auth manage announcements" on announcements for all to authenticated using (true) with check (true);

create policy "auth read announcement reads" on announcement_reads for select to authenticated using (true);
create policy "auth write announcement reads" on announcement_reads for insert to authenticated with check (true);
create policy "auth update announcement reads" on announcement_reads for update to authenticated using (true);

create policy "auth read tasks" on work_tasks for select to authenticated using (true);
create policy "auth manage tasks" on work_tasks for all to authenticated using (true) with check (true);

create policy "auth read handover" on daily_handover for select to authenticated using (true);
create policy "auth insert handover" on daily_handover for insert to authenticated with check (true);

create policy "auth read audit" on audit_logs for select to authenticated using (true);
