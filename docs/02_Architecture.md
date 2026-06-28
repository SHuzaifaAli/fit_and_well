# 02_Architecture.md

# System Architecture

## Overview

The application follows a Feature-First Clean Architecture using
Flutter, GetX, and Supabase.

## High-Level Stack

  Layer           Technology
  --------------- ---------------------------
  UI              Flutter
  State           GetX
  Backend         Supabase
  Database        PostgreSQL
  Auth            Supabase Auth
  Storage         Supabase Storage
  Notifications   Firebase Cloud Messaging
  AI              OpenAI via Edge Functions

## Layered Architecture

``` text
Presentation
 ├── Views
 ├── Widgets
 └── Controllers

Domain
 ├── Repositories
 └── Business Logic

Data
 ├── Datasources
 ├── Models
 └── Services

Infrastructure
 ├── Supabase
 ├── Firebase
 ├── OpenAI
 └── Local Storage
```

## Request Flow

``` text
User
 ↓
View
 ↓
GetX Controller
 ↓
Repository
 ↓
Datasource
 ↓
Supabase / Edge Function
 ↓
Repository
 ↓
Controller
 ↓
Reactive UI
```

## Feature Structure

``` text
modules/
 auth/
  bindings/
  controllers/
  datasource/
  models/
  repositories/
  views/
  widgets/
```

## Dependency Injection

-   Register services in initial bindings.
-   Lazy load feature controllers.
-   Keep repositories singleton where appropriate.

## State Management

-   `.obs` for reactive state.
-   Workers (`ever`, `debounce`, `interval`) for form/search.
-   Separate loading, empty, error, and success states.

## Repository Pattern

Responsibilities: - Abstract data source. - Map DTOs to models. - Hide
backend implementation.

## Datasource Pattern

-   RemoteDatasource: Supabase APIs
-   LocalDatasource: cache/preferences

## Services

-   AuthService
-   DatabaseService
-   StorageService
-   NotificationService
-   AIService
-   ConnectivityService

## Error Handling

-   Custom Failure model
-   Global exception mapper
-   User-friendly messages
-   Retry transient network failures

## Security

-   Enable RLS on all user tables.
-   Never expose service role keys.
-   Route AI calls through Edge Functions.
-   Store secrets in environment variables.

## Offline Strategy

-   Cache profile/settings.
-   Queue writes when offline (Phase 2).
-   Sync on reconnect.

## Navigation

``` text
Splash
 ├── Login
 └── Home
      ├── Dashboard
      ├── Workout
      ├── Nutrition
      ├── Progress
      └── Profile
```

## Coding Standards

-   Feature-first organization.
-   One responsibility per class.
-   Repository interfaces.
-   Immutable models.
-   Consistent naming.
-   Unit test business logic.

## Definition of Done

-   Architecture documented.
-   Layers isolated.
-   No direct UI→Supabase calls.
-   Dependency injection configured.
-   Error handling implemented.
-   Security review completed.
