# readright_app

A mobile app that helps children practice reading words aloud, 
receive pronunciation feedback, and track progress.

## Project status: Team implementation and design notes

This repository contains the team's implementation of a reading-practice application.

This is what the team implemented so far:

- Authentication flow and role selection:
  - `lib/main.dart` — Initializes the app, sets up Provider for global state, and restores saved sessions at startup.
  - `lib/models/enums.dart` — Defines the UserRole enum (student / teacher) used throughout the app. 
  - `lib/services/auth_service.dart` — Implements the AuthService class for managing login, logout, and session persistence using SharedPreferences. 
  - `lib/screens/login_screen.dart` — Enables users to choose between Student or Teacher roles. The choice is saved locally, and the app automatically routes the user to the correct dashboard on restart.

- Student experience (core screens):
  - `lib/screens/student_home.dart` — Bottom navigation for the student including: Words, Practice, Feedback, Progress.
  - `lib/screens/word_list_screen.dart` — Placeholder for the student word list view.
  - `lib/screens/practice_screen.dart` — Placeholder for practice (microphone/recording UI to be integrated later).
  - `lib/screens/feedback_screen.dart` — Placeholder for pronunciation feedback and suggestions.
  - `lib/screens/progress_screen.dart` — Placeholder for student progress (charts/badges).

- Teacher experience (core screens):
  - `lib/screens/teacher_dashboard_screen.dart` — Teacher dashboard with navigation to student progress and word list management.
  - `lib/screens/student_progress_screen.dart` — Placeholder where teachers can view progress charts for individual students.
  - `lib/screens/manage_word_list_screen.dart` — Placeholder for teacher word-list editing and management.

- Data & models (foundational files):
  - `lib/data/seed_words.csv` — A small, included CSV containing sample seed words and levels for testing the word list UI.
  - `lib/models/` — Folder intended for domain models (e.g., word items). Some model files are currently skeletons/placeholders for future development.

- Architecture notes:
  - The codebase uses a simple route-based navigation through `MaterialApp` routes and `Navigator` pushes for teacher workflows.
  - Screens are currently largely stateless UI placeholders to allow the team to iterate on layout and flow before adding backend services (audio recording, speech-to-text, scoring, or persistence).
  - The app uses the Provider package for state management and SharedPreferences for persistence.
UI placeholders added by the team for front-end development
- `lib/widgets/record_placeholder.dart` — Static record UI mock used to design the practice screen layout.
- `lib/widgets/feedback_placeholder.dart` — Static feedback UI mock used to design feedback display and suggestions.
- `lib/widgets/charts_placeholder.dart` — Mock progress visualizations for chart layout testing.


