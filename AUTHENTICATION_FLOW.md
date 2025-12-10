# Authentication Flow Diagram

## Visual Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      APP LAUNCH                              │
│                          ↓                                   │
│                   LoginScreen                                │
│         ┌────────────────────────────────┐                  │
│         │  [Login] or [Sign Up] Toggle   │                  │
│         └────────────────────────────────┘                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
        ┌─────────────────┴─────────────────┐
        ↓                                     ↓
┌───────────────┐                    ┌───────────────┐
│   SIGN UP     │                    │     LOGIN     │
└───────────────┘                    └───────────────┘
        ↓                                     ↓
┌───────────────────────────┐        ┌───────────────────────────┐
│ 1. Enter username (3+)    │        │ 1. Enter username         │
│ 2. Enter password (6+)    │        │ 2. Enter password         │
│ 3. Click "Sign Up"        │        │ 3. Click "Login"          │
└───────────────────────────┘        └───────────────────────────┘
        ↓                                     ↓
┌───────────────────────────┐        ┌───────────────────────────┐
│ AuthManager.signUp()      │        │ AuthManager.login()       │
└───────────────────────────┘        └───────────────────────────┘
        ↓                                     ↓
┌───────────────────────────┐        ┌───────────────────────────┐
│ AuthService.signUp()      │        │ AuthService.login()       │
│ - Check username exists   │        │ - Validate credentials    │
│ - Create UserAccount      │        │ - Load user data          │
│ - Save to JSON            │        │ - Set session             │
│ - Create user data file   │        └───────────────────────────┘
└───────────────────────────┘                  ↓
        ↓                                      │
        └──────────────────┬───────────────────┘
                          ↓
                ┌──────────────────┐
                │  SUCCESS?        │
                └──────────────────┘
                    ↓         ↓
                  YES        NO
                    ↓         ↓
        ┌───────────────┐   ┌──────────────┐
        │ Navigate to   │   │ Show Error   │
        │ MainTabNav    │   │ Message      │
        └───────────────┘   └──────────────┘
                ↓
┌─────────────────────────────────────────────────────────────┐
│                   MAIN APPLICATION                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Dashboard │  │ Training │  │  Music   │  │ Profile  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│                                                   ↓          │
│                                          [Logout Button]     │
└─────────────────────────────────────────────────────────────┘
                                                   ↓
                                          ┌──────────────┐
                                          │ Confirmation │
                                          │   Dialog     │
                                          └──────────────┘
                                                   ↓
                                          ┌──────────────┐
                                          │   Logout     │
                                          └──────────────┘
                                                   ↓
                                          ┌──────────────┐
                                          │ Back to      │
                                          │ LoginScreen  │
                                          └──────────────┘
```

## Data Storage Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    FILE SYSTEM                               │
│                                                              │
│  App Documents Directory                                     │
│  ├── users_accounts.json  ← All user credentials           │
│  │   [                                                      │
│  │     {                                                    │
│  │       "username": "john",                                │
│  │       "password": "pass123",                             │
│  │       "userDataFile": "user_john.json",                  │
│  │       "createdAt": "2025-11-20T10:00:00.000Z"           │
│  │     },                                                   │
│  │     { ... more users ... }                               │
│  │   ]                                                      │
│  │                                                          │
│  ├── user_john.json  ← John's personal data                │
│  │   {                                                      │
│  │     "username": "john",                                  │
│  │     "profile": { name, age, weight, height, gender },   │
│  │     "exerciseHistory": [ ... sessions ... ],            │
│  │     "musicPlaylist": [ ... tracks ... ]                 │
│  │   }                                                      │
│  │                                                          │
│  ├── user_jane.json  ← Jane's personal data                │
│  └── user_mike.json  ← Mike's personal data                │
└─────────────────────────────────────────────────────────────┘
```

## Component Interaction

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│                                                              │
│  ┌──────────────┐                    ┌──────────────┐      │
│  │ LoginScreen  │                    │ProfileScreen │      │
│  │              │                    │  [Logout]    │      │
│  └──────────────┘                    └──────────────┘      │
│         ↓                                     ↓             │
└─────────┼─────────────────────────────────────┼─────────────┘
          ↓                                     ↓
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                       │
│                                                              │
│  ┌──────────────────────────────────────────────────┐      │
│  │            AuthManager (ChangeNotifier)          │      │
│  │  - currentUsername                               │      │
│  │  - currentUserData                               │      │
│  │  - isLoading                                     │      │
│  │  - isLoggedIn                                    │      │
│  │  + signUp(username, password)                    │      │
│  │  + login(username, password)                     │      │
│  │  + logout()                                      │      │
│  └──────────────────────────────────────────────────┘      │
│         ↓                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Profile    │  │    Train     │  │    Music     │     │
│  │   Manager    │  │   Manager    │  │   Manager    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────┼──────────────────┼──────────────────┼────────────┘
          ↓                  ↓                  ↓
┌─────────────────────────────────────────────────────────────┐
│                      SERVICE LAYER                           │
│                                                              │
│  ┌──────────────────────────────────────────────────┐      │
│  │              AuthService (Static)                │      │
│  │  + signUp(username, password)                    │      │
│  │  + login(username, password)                     │      │
│  │  + logout()                                      │      │
│  │  + loadUserData(username)                        │      │
│  │  + saveUserData(username, data)                  │      │
│  │  + getCurrentUserData()                          │      │
│  │  + saveCurrentUserData(data)                     │      │
│  │  + isLoggedIn()                                  │      │
│  │  + usernameExists(username)                      │      │
│  └──────────────────────────────────────────────────┘      │
└─────────┼───────────────────────────────────────────────────┘
          ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ UserAccount  │  │   UserData   │  │ UserProfile  │     │
│  │    Model     │  │    Model     │  │    Model     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         ↓                  ↓                  ↓             │
│  ┌──────────────────────────────────────────────────┐      │
│  │              JSON Files (File System)            │      │
│  │  - users_accounts.json                           │      │
│  │  - user_[username].json (per user)               │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    USER ACTIONS                              │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                  AuthManager Methods                         │
│  signUp() / login() / logout() / updateUserData()           │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                  AuthService Operations                      │
│  File I/O, JSON parsing, validation                         │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                  notifyListeners()                           │
│  Triggers UI rebuild in all Consumer widgets                │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    UI UPDATES                                │
│  All screens listening to AuthManager rebuild               │
└─────────────────────────────────────────────────────────────┘
```

## Error Handling Flow

```
User Action
    ↓
Validation
    ↓
┌───────────┐
│  Valid?   │
└───────────┘
    ↓     ↓
   YES    NO
    ↓     ↓
    │   Show Error
    │   Message
    ↓
Process Request
    ↓
┌───────────┐
│ Success?  │
└───────────┘
    ↓     ↓
   YES    NO
    ↓     ↓
Navigate  Show Error
to App    Message
```

## Session Management

```
App Launch
    ↓
Check AuthService.isLoggedIn()
    ↓
┌─────────────┐
│ Logged In?  │
└─────────────┘
    ↓       ↓
   YES      NO
    ↓       ↓
    │   LoginScreen
    ↓
Load User Data
    ↓
MainTabNavigator
    ↓
User Interacts
    ↓
Data Changes
    ↓
Auto-save to JSON
    ↓
Logout?
    ↓
Clear Session
    ↓
Back to LoginScreen
```

## Multi-User Scenario

```
User A Signs Up
    ↓
Create user_A.json
    ↓
User A Logs Out
    ↓
User B Signs Up
    ↓
Create user_B.json
    ↓
User B Logs Out
    ↓
User A Logs In
    ↓
Load user_A.json
    ↓
User A's Data Displayed
    ↓
User A Logs Out
    ↓
User B Logs In
    ↓
Load user_B.json
    ↓
User B's Data Displayed

✅ Complete Data Isolation
```

---

**Key Points:**
- Each user has isolated data storage
- Authentication state managed by AuthManager
- File operations handled by AuthService
- UI automatically updates via Provider
- Session persists until logout
