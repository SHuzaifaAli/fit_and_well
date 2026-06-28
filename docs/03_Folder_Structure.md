# 03_Folder_Structure.md

# Flutter Project Folder Structure

## Objective

Maintain a scalable, feature-first architecture suitable for long-term
development.

## Root Structure

``` text
lib/
├── app/
├── core/
├── data/
├── modules/
├── routes/
├── bindings/
├── shared/
└── main.dart
```

## app/

``` text
app/
├── app.dart
├── app_binding.dart
└── app_routes.dart
```

Responsibilities: - App initialization - Global bindings - Route
registration

## core/

``` text
core/
├── constants/
├── config/
├── themes/
├── network/
├── services/
├── storage/
├── helpers/
├── utils/
├── extensions/
├── errors/
└── widgets/
```

## data/

``` text
data/
├── models/
├── repositories/
├── datasource/
└── providers/
```

## Feature Module Template

``` text
modules/
└── workout/
    ├── bindings/
    ├── controllers/
    ├── datasource/
    ├── repositories/
    ├── models/
    ├── views/
    ├── widgets/
    └── services/
```

## Planned Modules

-   auth
-   onboarding
-   dashboard
-   workout
-   nutrition
-   water_tracker
-   progress
-   ai_coach
-   subscription
-   profile
-   settings

## shared/

Reusable UI components.

``` text
shared/
├── buttons/
├── cards/
├── dialogs/
├── inputs/
├── loaders/
├── charts/
└── appbar/
```

## assets/

``` text
assets/
├── images/
├── icons/
├── animations/
├── lottie/
├── fonts/
└── json/
```

## Routing

``` text
routes/
├── app_pages.dart
├── app_routes.dart
└── middleware.dart
```

## Bindings

``` text
bindings/
├── initial_binding.dart
└── global_binding.dart
```

## Naming Convention

-   snake_case files
-   PascalCase classes
-   camelCase variables
-   Feature-first folders

## Module Checklist

Every module should contain:

-   Binding
-   Controller
-   Repository
-   Datasource
-   Model
-   View
-   Widgets

## File Responsibilities

Controller: - UI logic

Repository: - Business logic

Datasource: - API & Supabase

Model: - Serialization

View: - UI

Widgets: - Reusable components

## Best Practices

-   Keep modules isolated.
-   Avoid cross-module dependencies.
-   Never call Supabase directly from Views.
-   Reuse widgets.
-   Keep controllers lightweight.

## Example Flow

``` text
WorkoutView
   ↓
WorkoutController
   ↓
WorkoutRepository
   ↓
WorkoutDatasource
   ↓
Supabase
```

## Definition of Done

-   Folder structure created.
-   Module template available.
-   Shared widgets separated.
-   Naming conventions followed.
-   Ready for feature development.
