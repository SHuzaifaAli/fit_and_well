# 04_Database_Design.md

# Database Design (Supabase PostgreSQL)

## Objective

Design a scalable database for the Health & Fitness Coach MVP with
support for future AI, subscriptions, and wearable integrations.

------------------------------------------------------------------------

# Database Overview

Core tables:

-   profiles
-   goals
-   workout_categories
-   workouts
-   exercises
-   user_workouts
-   foods
-   nutrition_logs
-   water_logs
-   weight_logs
-   body_measurements
-   ai_history
-   subscriptions
-   notifications
-   user_settings

------------------------------------------------------------------------

# Entity Relationships

``` text
auth.users
    │
    ▼
profiles
    │
    ├── user_workouts
    ├── nutrition_logs
    ├── water_logs
    ├── weight_logs
    ├── body_measurements
    ├── ai_history
    ├── subscriptions
    └── user_settings
```

------------------------------------------------------------------------

# profiles

Purpose: Stores user profile and fitness preferences.

Columns

  Column            Type
  ----------------- -----------
  id                UUID PK
  full_name         text
  age               int
  gender            text
  height            decimal
  weight            decimal
  goal              text
  activity_level    text
  diet_preference   text
  avatar            text
  created_at        timestamp
  updated_at        timestamp

------------------------------------------------------------------------

# workout_categories

-   id
-   name
-   description
-   image

------------------------------------------------------------------------

# workouts

-   id
-   category_id
-   title
-   description
-   difficulty
-   duration
-   calories
-   image_url

Relationship

Workout Category

↓

Many Workouts

------------------------------------------------------------------------

# exercises

-   id
-   workout_id
-   name
-   instructions
-   muscle_group
-   sets
-   reps
-   rest_time
-   video_url

------------------------------------------------------------------------

# user_workouts

Tracks workout history.

Columns

-   id
-   user_id
-   workout_id
-   completed
-   calories_burned
-   duration
-   completed_at

------------------------------------------------------------------------

# foods

Master food database.

Columns

-   id
-   name
-   calories
-   protein
-   carbs
-   fat
-   serving_size

------------------------------------------------------------------------

# nutrition_logs

Tracks meals.

Columns

-   id
-   user_id
-   food_id
-   meal_type
-   quantity
-   calories
-   protein
-   carbs
-   fat
-   date

------------------------------------------------------------------------

# water_logs

-   id
-   user_id
-   amount_ml
-   date

------------------------------------------------------------------------

# weight_logs

-   id
-   user_id
-   weight
-   bmi
-   date

------------------------------------------------------------------------

# body_measurements

-   chest
-   waist
-   hips
-   arms
-   thighs

------------------------------------------------------------------------

# ai_history

Stores AI requests.

-   prompt
-   response
-   tokens_used
-   created_at

------------------------------------------------------------------------

# subscriptions

-   plan
-   platform
-   status
-   expiry_date

------------------------------------------------------------------------

# notifications

-   title
-   body
-   schedule_time
-   sent

------------------------------------------------------------------------

# user_settings

-   theme
-   units
-   language
-   notification_enabled

------------------------------------------------------------------------

# Storage Buckets

avatars/

exercise_images/

exercise_videos/

meal_images/

progress_photos/

------------------------------------------------------------------------

# Indexes

Create indexes on

-   user_id
-   workout_id
-   food_id
-   created_at
-   date

------------------------------------------------------------------------

# Row Level Security

Enable RLS on every user table.

Policy

Users can only:

-   SELECT own data
-   INSERT own data
-   UPDATE own data
-   DELETE own data

------------------------------------------------------------------------

# Seed Data

Populate

-   workout categories
-   workouts
-   exercises
-   food database

------------------------------------------------------------------------

# Migration Order

1.  Profiles
2.  Categories
3.  Workouts
4.  Exercises
5.  Foods
6.  Logs
7.  AI
8.  Subscription

------------------------------------------------------------------------

# Future Tables

-   wearable_devices
-   sleep_logs
-   heart_rate_logs
-   coach_clients
-   gyms
-   achievements
-   badges

------------------------------------------------------------------------

# Definition of Done

-   Database migrated
-   RLS enabled
-   Indexes created
-   Seed data imported
-   Relationships verified
