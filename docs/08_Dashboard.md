# 08_Dashboard.md

# Dashboard Module

## Objective

Provide users with a personalized overview of daily fitness activity,
nutrition, hydration, and progress.

------------------------------------------------------------------------

# User Flow

``` text
Login
  ↓
Dashboard
 ├── Workout
 ├── Nutrition
 ├── Progress
 ├── Profile
 └── Settings
```

------------------------------------------------------------------------

# Dashboard Layout

1.  Greeting Header
2.  Daily Goal Summary
3.  Quick Actions
4.  Workout Progress
5.  Nutrition Summary
6.  Water Intake
7.  Weight & BMI
8.  Weekly Charts
9.  Today's Workout
10. Recent Activity

------------------------------------------------------------------------

# Folder Structure

``` text
modules/dashboard/
├── bindings/
├── controllers/
├── datasource/
├── repositories/
├── models/
├── views/
└── widgets/
```

------------------------------------------------------------------------

# Widgets

## Greeting Card

-   User name
-   Current goal
-   Date

## Daily Summary

-   Calories Consumed
-   Calories Burned
-   Remaining Calories

## Water Card

-   Today's intake
-   Goal progress
-   Quick Add (+250ml, +500ml)

## Workout Card

-   Today's workout
-   Progress %
-   Start button

## Weight Card

-   Current weight
-   BMI
-   Weekly trend

## Streak Card

-   Workout streak
-   Best streak

## Quick Actions

-   Log Meal
-   Start Workout
-   Add Water
-   Update Weight

## Weekly Chart

-   Calories
-   Weight
-   Water
-   Workout completion

------------------------------------------------------------------------

# Navigation

Bottom Navigation: - Home - Workout - Nutrition - Progress - Profile

------------------------------------------------------------------------

# Data Sources

-   profiles
-   user_workouts
-   nutrition_logs
-   water_logs
-   weight_logs

------------------------------------------------------------------------

# Architecture

``` text
DashboardView
      ↓
DashboardController
      ↓
DashboardRepository
      ↓
DashboardDatasource
      ↓
Supabase
```

------------------------------------------------------------------------

# Controller Responsibilities

-   Load dashboard data
-   Refresh state
-   Aggregate daily metrics
-   Handle loading/error states

------------------------------------------------------------------------

# Repository Responsibilities

-   Fetch profile
-   Aggregate logs
-   Calculate daily summary

------------------------------------------------------------------------

# Datasource Responsibilities

-   Query Supabase
-   Map models
-   Cache responses (future)

------------------------------------------------------------------------

# Loading States

-   Skeleton cards
-   Pull-to-refresh
-   Retry on failure

------------------------------------------------------------------------

# Empty States

-   No workouts
-   No meals
-   No water logs
-   Encourage first action

------------------------------------------------------------------------

# Error Handling

-   Network unavailable
-   Session expired
-   Database timeout

------------------------------------------------------------------------

# Performance

-   Lazy loading
-   Pagination for history
-   Cached profile
-   Parallel data requests

------------------------------------------------------------------------

# UI Components

-   StatisticCard
-   CircularProgressCard
-   WorkoutCard
-   WaterCard
-   ChartCard
-   QuickActionButton
-   GreetingHeader

------------------------------------------------------------------------

# Acceptance Criteria

-   Dashboard loads within 2 seconds
-   Pull-to-refresh works
-   Cards update after logging data
-   Navigation works correctly

------------------------------------------------------------------------

# Testing Checklist

-   First login
-   Refresh
-   Empty data
-   Offline mode
-   Widget updates
-   Navigation
-   Performance

------------------------------------------------------------------------

# Definition of Done

-   Dashboard implemented
-   Widgets reusable
-   Responsive layout
-   Connected to Supabase
-   Tested on Android, iOS, Web
