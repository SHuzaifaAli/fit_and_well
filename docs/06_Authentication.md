# 06_Authentication.md

# Authentication Module

## Objective

Provide secure authentication using Supabase Auth with email/password
and social providers.

## Features

-   Splash Screen
-   Login
-   Register
-   Forgot Password
-   Email Verification
-   Session Restore
-   Logout
-   Google Sign-In
-   Apple Sign-In (iOS)

## User Flow

``` text
Splash
 ├── Logged In -> Dashboard
 └── Not Logged In -> Login
                     ├── Register
                     └── Forgot Password
```

## Folder Structure

``` text
modules/auth/
├── bindings/
├── controllers/
├── datasource/
├── models/
├── repositories/
├── views/
└── widgets/
```

## Screens

### Splash

-   Check session
-   Route user

### Login

Fields: - Email - Password

Actions: - Login - Google Login - Forgot Password - Register

Validation: - Valid email - Password \>= 8 chars

### Register

Fields: - Full Name - Email - Password - Confirm Password

Validation: - Required fields - Password match

### Forgot Password

-   Email input
-   Reset link

## Architecture

``` text
LoginView
 ↓
AuthController
 ↓
AuthRepository
 ↓
AuthDatasource
 ↓
Supabase Auth
```

## Controller Responsibilities

-   Form validation
-   Loading state
-   Auth session
-   Navigation
-   Error messages

## Repository Responsibilities

-   Login
-   Register
-   Logout
-   Reset password
-   Session management

## Datasource Responsibilities

-   Supabase auth calls
-   OAuth
-   Token refresh

## Database

profiles linked to auth.users by UUID.

## Security

-   Never store passwords
-   Store tokens securely
-   Validate email
-   Use HTTPS
-   Enable email confirmation

## Error Handling

-   Invalid credentials
-   Network failure
-   Email already exists
-   Weak password
-   User not verified

## UI Components

-   Email field
-   Password field
-   Social login button
-   Loading button
-   Validation messages

## Acceptance Criteria

-   User can register
-   User can login
-   Session persists
-   Logout works
-   Password reset works
-   Google login works

## Testing Checklist

-   Valid login
-   Invalid login
-   Registration
-   Email verification
-   Password reset
-   Logout
-   Session restore
-   Offline handling

## Definition of Done

-   Authentication complete
-   Secure session handling
-   Error handling complete
-   Tested on Android, iOS, Web
