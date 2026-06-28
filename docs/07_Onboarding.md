# 07_Onboarding.md

# Onboarding Module

## Objective

Collect user information required to generate personalized workouts,
nutrition plans, and progress tracking.

------------------------------------------------------------------------

# User Flow

``` text
Welcome
   ↓
Personal Information
   ↓
Gender
   ↓
Age
   ↓
Height
   ↓
Weight
   ↓
Fitness Goal
   ↓
Activity Level
   ↓
Diet Preference
   ↓
Review
   ↓
Dashboard
```

------------------------------------------------------------------------

# Folder Structure

``` text
modules/onboarding/
├── bindings/
├── controllers/
├── datasource/
├── repositories/
├── models/
├── views/
└── widgets/
```

------------------------------------------------------------------------

# Screens

## Welcome

Purpose: Introduce the app.

Buttons: - Get Started - Skip (Optional)

------------------------------------------------------------------------

## Personal Information

Fields

-   Full Name
-   Date of Birth (Optional)

Validation

-   Name required

------------------------------------------------------------------------

## Gender

Options

-   Male
-   Female
-   Other
-   Prefer not to say

------------------------------------------------------------------------

## Age

Input

-   Number Picker

Validation

-   13--100

------------------------------------------------------------------------

## Height

Units

-   cm
-   ft/in

Validation

-   Positive values only

------------------------------------------------------------------------

## Weight

Units

-   kg
-   lbs

Validation

-   Positive values only

------------------------------------------------------------------------

## Fitness Goal

Options

-   Weight Loss
-   Muscle Gain
-   Maintenance
-   General Fitness

------------------------------------------------------------------------

## Activity Level

Options

-   Sedentary
-   Light
-   Moderate
-   Active
-   Athlete

------------------------------------------------------------------------

## Diet Preference

Options

-   None
-   Vegetarian
-   Vegan
-   Keto
-   Paleo
-   High Protein

------------------------------------------------------------------------

## Review Screen

Display

-   Profile Summary
-   Edit option
-   Finish button

------------------------------------------------------------------------

# Database Mapping

Table

profiles

Fields

-   full_name
-   age
-   gender
-   height
-   weight
-   goal
-   activity_level
-   diet_preference

------------------------------------------------------------------------

# Architecture

``` text
OnboardingView
      ↓
OnboardingController
      ↓
OnboardingRepository
      ↓
OnboardingDatasource
      ↓
Supabase
```

------------------------------------------------------------------------

# Controller Responsibilities

-   Form validation
-   Multi-step navigation
-   Progress tracking
-   Save profile

------------------------------------------------------------------------

# Repository Responsibilities

-   Save profile
-   Fetch profile
-   Update profile

------------------------------------------------------------------------

# Datasource Responsibilities

-   Insert profile
-   Update profile
-   Read profile

------------------------------------------------------------------------

# UI Components

-   Step Indicator
-   Progress Bar
-   Primary Button
-   Secondary Button
-   Number Picker
-   Selection Card
-   Summary Card

------------------------------------------------------------------------

# Validation

-   Required fields
-   Age range
-   Weight \> 0
-   Height \> 0

------------------------------------------------------------------------

# Error Handling

-   Network error
-   Validation error
-   Save failure
-   Session expired

------------------------------------------------------------------------

# Acceptance Criteria

-   User completes onboarding
-   Profile saved
-   User cannot access dashboard until onboarding is complete
-   Existing users skip onboarding

------------------------------------------------------------------------

# Testing Checklist

-   First launch
-   Skip onboarding
-   Complete onboarding
-   Edit profile
-   Offline state
-   Validation
-   Database save

------------------------------------------------------------------------

# Definition of Done

-   All onboarding screens completed
-   Profile saved in Supabase
-   Navigation works
-   Validation complete
-   Responsive UI
-   Tested on Android, iOS, and Web
