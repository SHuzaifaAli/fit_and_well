# 00_Project_Overview.md

# Health & Fitness Coach SaaS

## Vision

Build a cross-platform AI-powered fitness application using Flutter that
helps users achieve fitness goals through workouts, nutrition, progress
tracking, and AI coaching.

## Objectives

-   Launch an MVP in 8--12 weeks.
-   Support Android, iOS, and Web.
-   Use Flutter + GetX + Supabase.
-   Monetize through subscriptions.

## Core Features

-   Authentication
-   User onboarding
-   Workout plans
-   Nutrition logging
-   Water tracking
-   Progress analytics
-   AI meal planner
-   Push notifications
-   Premium subscription

## Technology Stack

  Layer              Technology
  ------------------ --------------------------------
  Frontend           Flutter
  State Management   GetX
  Backend            Supabase
  Database           PostgreSQL
  Notifications      Firebase Cloud Messaging
  AI                 OpenAI
  Charts             fl_chart
  Payments           Google Play, Apple IAP, Stripe

## Development Phases

1.  Project Setup
2.  Authentication
3.  Onboarding
4.  Dashboard
5.  Workout Module
6.  Nutrition Module
7.  Water Tracker
8.  Progress Tracking
9.  AI Coach
10. Notifications
11. Subscription
12. Testing & Deployment

## Folder Structure

``` text
lib/
 core/
 data/
 modules/
 routes/
 bindings/
```

## Architecture

``` text
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

## Success Metrics

-   1,000 users
-   5% premium conversion
-   Crash-free rate \>99%
-   App startup \<2 seconds

## MVP Scope

### Included

-   Email/Google login
-   Workout tracking
-   Nutrition logging
-   Water tracking
-   Progress charts
-   AI meal plans
-   Premium subscription

### Excluded (Phase 2)

-   Wearables
-   Coach Portal
-   Gym Dashboard
-   Offline Sync
-   Social Features

## Milestones

  Week   Deliverable
  ------ ------------------------
  1      Setup + Auth
  2      Onboarding + Dashboard
  3      Workout
  4      Nutrition
  5      Progress
  6      AI
  7      Notifications
  8      Subscriptions
  9      Testing
  10     Release

## Documentation Index

-   01_Roadmap.md
-   02_Architecture.md
-   03_Folder_Structure.md
-   04_Database_Design.md
-   05_UI_UX_Guidelines.md
-   06_Authentication.md
-   07_Onboarding.md
-   08_Dashboard.md
-   09_Workout_Module.md
-   10_Nutrition_Module.md

## Definition of Done

-   Feature implemented
-   Tested
-   Responsive
-   Connected to Supabase
-   Error handling completed
-   Documentation updated
