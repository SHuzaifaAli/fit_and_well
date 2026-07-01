# FitAI Coach — Phase 1 Completion Document

---

## 1. Complete Folder Structure

```
fit_and_well/
├── lib/
│   ├── main.dart                            ✅ NEW
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart           ✅ EXISTS
│   │   ├── di/
│   │   │   └── injection.dart               ✅ EXISTS
│   │   ├── errors/
│   │   │   ├── app_exceptions.dart          ✅ EXISTS
│   │   │   └── failures.dart                ✅ EXISTS
│   │   ├── network/
│   │   │   ├── connectivity_service.dart    ✅ EXISTS
│   │   │   └── network_client.dart          ✅ EXISTS
│   │   ├── services/
│   │   │   ├── storage_service.dart         ✅ EXISTS
│   │   │   └── supabase_service.dart        ✅ EXISTS
│   │   ├── themes/
│   │   │   ├── app_colors.dart              ✅ EXISTS
│   │   │   ├── app_theme.dart               ✅ EXISTS
│   │   │   └── app_typography.dart          ✅ EXISTS
│   │   └── utils/
│   │       ├── date_utils.dart              ✅ EXISTS
│   │       ├── fitness_calculator.dart      ✅ EXISTS
│   │       └── validators.dart              ✅ EXISTS
│   │
│   ├── data/
│   │   ├── datasources/
│   │   │   └── auth_remote_datasource.dart  ✅ EXISTS
│   │   ├── models/
│   │   │   ├── user_model.dart              ✅ EXISTS
│   │   │   ├── workout_model.dart           ✅ EXISTS
│   │   │   ├── nutrition_model.dart         ✅ EXISTS
│   │   │   ├── progress_model.dart          ✅ EXISTS
│   │   │   └── subscription_model.dart      ✅ EXISTS
│   │   └── repositories/
│   │       ├── auth_repository.dart         ✅ EXISTS
│   │       └── user_repository.dart         ✅ EXISTS
│   │
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── bindings/auth_binding.dart   ✅ EXISTS
│   │   │   ├── controllers/
│   │   │   │   └── auth_controller.dart     ✅ EXISTS
│   │   │   └── views/
│   │   │       ├── splash_screen.dart       ✅ EXISTS
│   │   │       ├── login_screen.dart        ✅ EXISTS
│   │   │       ├── register_screen.dart     ✅ EXISTS
│   │   │       └── forgot_password_screen.dart ✅ EXISTS
│   │   │
│   │   ├── onboarding/
│   │   │   ├── bindings/onboarding_binding.dart ✅ EXISTS
│   │   │   ├── controllers/
│   │   │   │   └── onboarding_controller.dart ✅ EXISTS
│   │   │   └── views/
│   │   │       ├── onboarding_screen.dart   ✅ NEW
│   │   │       ├── profile_setup_screen.dart ✅ NEW (redirect stub)
│   │   │       └── goal_setup_screen.dart   ✅ NEW (redirect stub)
│   │   │
│   │   ├── dashboard/
│   │   │   ├── bindings/dashboard_binding.dart ✅ NEW
│   │   │   ├── controllers/
│   │   │   │   └── dashboard_controller.dart   ✅ NEW
│   │   │   └── views/
│   │   │       └── dashboard_screen.dart    ✅ NEW
│   │   │
│   │   ├── workouts/     (Phase 3 — stubs only) ✅ NEW
│   │   ├── nutrition/    (Phase 4 — stubs only) ✅ NEW
│   │   ├── ai_coach/     (Phase 5 — stubs only) ✅ NEW
│   │   ├── progress/     (Phase 6 — stubs only) ✅ NEW
│   │   ├── profile/      (Phase 2 — stubs only) ✅ NEW
│   │   └── subscription/ (Phase 8 — stubs only) ✅ NEW
│   │
│   ├── routes/
│   │   ├── app_pages.dart                   ✅ EXISTS
│   │   └── app_routes.dart                  ✅ EXISTS
│   │
│   └── widgets/
│       ├── app_button.dart                  ✅ EXISTS
│       ├── app_card.dart                    ✅ EXISTS
│       ├── app_text_field.dart              ✅ EXISTS
│       ├── shimmer_widget.dart              ✅ EXISTS
│       └── state_widgets.dart              ✅ EXISTS
│
├── test/
│   ├── core/
│   │   ├── utils/
│   │   │   ├── validators_test.dart         ✅ NEW
│   │   │   └── fitness_calculator_test.dart ✅ NEW
│   │   └── errors/
│   │       └── exceptions_test.dart         ✅ NEW
│   ├── data/
│   │   └── models/
│   │       └── user_model_test.dart         ✅ NEW
│   └── phase1_test.dart                     ✅ NEW (combined)
│
├── assets/
│   ├── fonts/        (Inter: Regular, Medium, SemiBold, Bold, ExtraBold)
│   ├── icons/        (google.png, apple.png)
│   ├── images/       (placeholder images)
│   └── animations/   (Lottie JSON files)
│
└── pubspec.yaml                             ✅ EXISTS
```

---

## 2. Supabase Database Schema

```sql
-- ============================================================
-- PHASE 1 SCHEMA — Run this in Supabase SQL Editor
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── users ──────────────────────────────────────────────────
create table if not exists public.users (
  id              uuid primary key references auth.users(id) on delete cascade,
  email           text not null unique,
  name            text not null default '',
  age             int check (age >= 13 and age <= 120),
  gender          text check (gender in ('male', 'female', 'other')),
  height          numeric(5,2) check (height >= 50 and height <= 300), -- cm
  weight          numeric(6,2) check (weight >= 20 and weight <= 500), -- kg
  goal            text check (goal in ('weight_loss','muscle_gain','maintenance','general_fitness')),
  activity_level  text check (activity_level in (
                    'sedentary','lightly_active','moderately_active',
                    'very_active','extra_active')),
  diet_preference text check (diet_preference in (
                    'none','vegetarian','vegan','keto','paleo','mediterranean')),
  avatar_url      text,
  subscription_plan text not null default 'free'
                    check (subscription_plan in ('free','premium_monthly','premium_yearly','lifetime')),
  fcm_token       text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- Auto-update updated_at
create or replace function update_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

create trigger users_updated_at
  before update on public.users
  for each row execute function update_updated_at();

-- ─── subscriptions ───────────────────────────────────────────
create table if not exists public.subscriptions (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references public.users(id) on delete cascade,
  plan            text not null,
  status          text not null check (status in ('active','cancelled','expired','trial')),
  expiry_date     timestamptz,
  start_date      timestamptz default now(),
  transaction_id  text,
  platform        text check (platform in ('android','ios','web')),
  created_at      timestamptz not null default now()
);

create index on public.subscriptions(user_id);

-- ─── ai_requests ─────────────────────────────────────────────
-- Tracks daily AI usage for quota enforcement
create table if not exists public.ai_requests (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.users(id) on delete cascade,
  prompt     text,
  response   text,
  tokens     int,
  created_at timestamptz not null default now()
);

create index on public.ai_requests(user_id, created_at);

-- ─── Row Level Security ───────────────────────────────────────
alter table public.users enable row level security;
alter table public.subscriptions enable row level security;
alter table public.ai_requests enable row level security;

-- users: can only read/write own row
create policy "users_select_own" on public.users
  for select using (auth.uid() = id);

create policy "users_insert_own" on public.users
  for insert with check (auth.uid() = id);

create policy "users_update_own" on public.users
  for update using (auth.uid() = id);

-- subscriptions: own records only
create policy "subs_select_own" on public.subscriptions
  for select using (auth.uid() = user_id);

create policy "subs_insert_own" on public.subscriptions
  for insert with check (auth.uid() = user_id);

-- ai_requests: own records only
create policy "ai_req_select_own" on public.ai_requests
  for select using (auth.uid() = user_id);

create policy "ai_req_insert_own" on public.ai_requests
  for insert with check (auth.uid() = user_id);

-- ─── Storage Buckets ─────────────────────────────────────────
-- Run in Supabase dashboard → Storage → New Bucket
-- bucket: profile_images  (public: false, max file size: 5MB)
-- bucket: workout_images  (public: true,  max file size: 10MB)
-- bucket: exercise_videos (public: true,  max file size: 100MB)
```

---

## 3. Assets Required

Place these files before running the app:

```
assets/icons/google.png      # Google logo (48×48 PNG)
assets/icons/apple.png       # Apple logo  (48×48 PNG)

assets/fonts/Inter-Regular.ttf
assets/fonts/Inter-Medium.ttf
assets/fonts/Inter-SemiBold.ttf
assets/fonts/Inter-Bold.ttf
assets/fonts/Inter-ExtraBold.ttf
# Download from: https://fonts.google.com/specimen/Inter
```

---

## 4. Environment Setup

Create `.env` (never commit) and pass via `--dart-define`:

```sh
# Development
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --dart-define=OPENAI_API_KEY=sk-...

# Production build
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --dart-define=OPENAI_API_KEY=sk-...
```

---

## 5. Phase 1 Manual Testing Checklist

### Splash / Auth Flow
- [ ] App opens → splash screen shows logo + spinner
- [ ] No session → redirects to Login
- [ ] Active session → redirects to Dashboard (or Onboarding if incomplete)
- [ ] Login with valid credentials → Dashboard
- [ ] Login with invalid credentials → error banner
- [ ] Login with no internet → "No internet connection" error
- [ ] Register with valid data → Onboarding step 1
- [ ] Register with existing email → "Email already in use" error
- [ ] Register with weak password → inline validation error
- [ ] Forgot Password → email sent snackbar
- [ ] Google Sign-In → Dashboard or Onboarding
- [ ] Sign Out → Login screen + all local state cleared

### Onboarding
- [ ] Step 1: name field validates on Continue
- [ ] Step 2: gender chips + age validates
- [ ] Step 3: weight + height validates
- [ ] Step 4: goal selection required
- [ ] Step 5: activity level required + Complete Setup saves profile
- [ ] Back button navigates between steps
- [ ] Progress bar advances correctly
- [ ] Skip → Dashboard directly
- [ ] Completing onboarding sets `onboarding_complete = true` in SharedPreferences

### Dashboard
- [ ] Greeting uses correct time-of-day + user's first name
- [ ] Bottom navigation switches tabs
- [ ] Quick action taps navigate to correct screens (stubs OK)
- [ ] AI Coach card navigates to AI Coach stub
- [ ] Subscription badge shows "Free"

### Theme
- [ ] System dark/light theme respected on launch
- [ ] All screens render without overflow in both modes

---

## 6. Security Review — Phase 1

| Concern | Implementation |
|---|---|
| Token storage | `FlutterSecureStorage` with Android EncryptedSharedPreferences + iOS Keychain |
| Sensitive keys | `--dart-define` at build time, never in source |
| SQL injection | Supabase SDK uses parameterised queries exclusively |
| Input validation | All form fields validated client-side before any network call |
| RLS | Supabase Row Level Security enforced server-side per user |
| Session expiry | `AuthException.sessionExpired()` catches 401 and redirects to Login |
| Password rules | Min 8 chars, 1 uppercase, 1 number enforced in `Validators.password` |

---

## 7. Scalability Notes — Phase 1

- **Offline-first ready**: `StorageService` caches user profile in `SharedPreferences`; RLS-safe Supabase queries are isolated per table reference.
- **Dependency injection**: All services registered as permanent singletons via `GetX.put(..., permanent: true)` — safe for long sessions.
- **Feature-first modules**: Each phase is a self-contained `modules/<name>/` folder with its own binding, controller, and views — zero cross-module coupling at this stage.
- **Pagination constants**: `defaultPageSize`, `workoutPageSize`, `nutritionPageSize` defined in `AppConstants` — ready to wire into infinite scroll in Phase 3+.

---

## 8. Phase 2 Preview — User Profile & Goal Management

**Phase 2 will implement:**
1. Full `ProfileScreen` — avatar upload, edit name/age/weight/height
2. `EditProfileScreen` — update all physical stats with live BMR/TDEE preview
3. `SettingsScreen` — theme toggle, notifications, units (kg/lbs, cm/in)
4. `GoalSetupScreen` — change goal post-onboarding
5. `UserRepository` — full CRUD for user profile + avatar upload to Supabase Storage
6. Profile photo picker + image cropper integration
7. Unit preference system (metric / imperial)
8. BMR/TDEE/macro summary card on Profile screen
