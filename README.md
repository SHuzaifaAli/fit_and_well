# Health & Fitness Coach App MVP Architecture (Flutter)

Since you're a Flutter developer, I'd recommend building an MVP that can be launched in **8–12 weeks** and then expanded with AI features later.

## Tech Stack

### Frontend

* Flutter
* GetX (State Management)
* Go Router (Optional)
* Syncfusion Charts / FL Chart

### Backend

* [Supabase](https://supabase.com?utm_source=chatgpt.com)

  * Authentication
  * PostgreSQL Database
  * Edge Functions
  * Storage

### Notifications

* [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging?utm_source=chatgpt.com)

### AI Layer

* [OpenAI Platform](https://platform.openai.com?utm_source=chatgpt.com)
* Optional local models via Ollama later

### Payment

* Android: [Google Play Billing](https://developer.android.com/google/play/billing?utm_source=chatgpt.com)
* iOS: [Apple In‑App Purchases](https://developer.apple.com/in-app-purchase/?utm_source=chatgpt.com)
* Web: [Stripe](https://stripe.com?utm_source=chatgpt.com)

---

# MVP Features

## Authentication

* Email Login
* Google Login
* Apple Login (iOS)

---

## User Profile

### Fields

```text
Name
Age
Gender
Height
Weight
Goal
Activity Level
Diet Preference
```

Goals:

* Weight Loss
* Muscle Gain
* Maintenance
* General Fitness

---

## Workout Module

### Features

* Workout Categories

  * Beginner
  * Intermediate
  * Advanced

* Exercise Library

```text
Exercise Name
Instructions
Muscle Group
Calories Burned
Duration
```

### Daily Workout Plan

```text
Day 1
Chest + Triceps

Day 2
Back + Biceps

Day 3
Legs

Day 4
Rest
```

---

## Nutrition Module

### Daily Calories

Formula:

```text
BMR
+
Activity Multiplier
=
Daily Calories
```

### Track

```text
Breakfast
Lunch
Dinner
Snacks
Water Intake
```

---

## AI Nutrition Advisor

Prompt Example:

```text
Age: 28
Weight: 85kg
Goal: Weight Loss

Today's Intake:
1800 Calories

Suggest meal plan for tomorrow.
```

Returns:

```text
Breakfast
Lunch
Dinner
Macros
Calories
```

---

## Progress Tracking

Track:

```text
Weight
Body Fat
BMI
Workout Streak
Calories Consumed
Calories Burned
```

Charts:

* Weekly
* Monthly
* Yearly

---

# Database Design

## users

```sql
id
name
email
age
gender
height
weight
goal
activity_level
created_at
```

---

## workouts

```sql
id
title
difficulty
duration
calories
image
```

---

## exercises

```sql
id
workout_id
name
sets
reps
rest_time
video_url
```

---

## user_workouts

```sql
id
user_id
workout_id
status
completed_at
```

---

## nutrition_logs

```sql
id
user_id
meal_type
food_name
calories
protein
carbs
fat
date
```

---

## weight_logs

```sql
id
user_id
weight
date
```

---

## subscriptions

```sql
id
user_id
plan
status
expiry_date
```

---

# Flutter Folder Structure

```text
lib/

core/
 ├── constants/
 ├── themes/
 ├── services/
 ├── utils/

data/
 ├── models/
 ├── repositories/
 ├── datasource/

modules/

 ├── auth/
 ├── onboarding/
 ├── dashboard/
 ├── workouts/
 ├── nutrition/
 ├── ai_coach/
 ├── progress/
 ├── subscription/
 ├── profile/

routes/
bindings/
```

---

# GetX Architecture

```text
View
 ↓
Controller
 ↓
Repository
 ↓
Datasource
 ↓
Supabase
```

Example:

```text
WorkoutScreen
   ↓
WorkoutController
   ↓
WorkoutRepository
   ↓
WorkoutRemoteDatasource
   ↓
Supabase
```

---

# Monetization Model

## Free Plan

* Basic Workouts
* Weight Tracking
* Water Tracking
* Limited AI Requests

Price:

```text
$0
```

---

## Premium Plan

Features:

* Unlimited AI Coach
* Personalized Meal Plans
* Advanced Analytics
* Progress Predictions
* Wearable Sync

Price:

```text
$4.99/month
```

or

```text
$39.99/year
```

---

## One-Time Purchase

```text
Lifetime Premium
$79–99
```

Good for early adopters.

---

## B2B Monetization

Sell to:

* Gyms
* Fitness Coaches
* Nutritionists

Admin Panel Features:

```text
Create Clients
Assign Workout Plans
Assign Meal Plans
Track Progress
```

Pricing:

```text
Coach Plan
$19/month

Gym Plan
$99/month
```

---

# Wearable Integration (Phase 2)

### Android

* Samsung Health
* Fitbit

### iOS

* Apple Health

Track:

```text
Steps
Heart Rate
Calories Burned
Sleep
```

---

# Revenue Strategy

A realistic target:

```text
1,000 users
↓

5% paid conversion
↓

50 subscribers

$4.99/month
↓

~$250/month
```

At 10,000 users:

```text
500 subscribers

≈ $2,500/month
```

The strongest MVP is: **Workout Tracking + AI Meal Plans + Progress Analytics + Premium Subscription**, because it is feasible for a solo Flutter developer and creates recurring revenue from day one.

static const String supabaseUrl = 'https://kukgvzfdnvpovanxpapv.supabase.co';
static const String supabaseAnonKey = 'YOUR_ANON_KEY'; // Dashboard → Settings → API
