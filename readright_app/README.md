# readright_app

A mobile app that helps children practice reading words aloud, 
receive pronunciation feedback, and track progress.

## Project status: Team implementation and design notes

This repository contains the team's implementation of a reading-practice application.

This is what the team implemented so far:

### Authentication Flow and Role Selection
- `lib/main.dart` — Initializes Firebase, sets up the Provider for global state management, and restores saved sessions on startup.  
- `lib/models/enums.dart` — Defines the `UserRole` enum (Student / Teacher) used throughout the app.  
- `lib/services/auth_service.dart` — Manages login, logout, and session persistence with **SharedPreferences**.  
- `lib/screens/login_screen.dart` — Enables users to choose between Student or Teacher roles, authenticates via Firebase Email/Password, and routes them to the correct dashboard automatically on restart.  
- Authentication state persists across restarts, restoring user sessions seamlessly.

---

### Student Experience (Core Screens)
- `lib/screens/student_home.dart` — Main navigation hub for students, featuring tabs for:
  - **Words** — word list view  
  - **Practice** — speech recording and local STT comparison  
  - **Feedback** — pronunciation feedback display  
  - **Progress** — chart-based visual progress tracking  
- `lib/screens/word_list_screen.dart` — Loads Dolch and Phonics seed words from `seed_words.csv` and displays them in list form.  
- `lib/screens/practice_screen.dart` — Implements mock practice flow (Word → Record → Compare → Feedback). Integrates with `speech_service.dart`.  
- `lib/screens/feedback_screen.dart` — Displays pronunciation feedback and accuracy placeholders.  
- `lib/screens/progress_screen.dart` — Shows mock charts and progress summaries using static placeholder data.

---

### Teacher Experience (Core Screens)
- `lib/screens/teacher_dashboard_screen.dart` — Teacher dashboard providing navigation to manage word lists and review student progress.  
- `lib/screens/student_progress_screen.dart` — Displays placeholder charts for student performance analytics (to be populated in later milestones).  
- `lib/screens/manage_word_list_screen.dart` — Mock interface for teachers to edit and manage Dolch/Phonics word lists.  
- Logout functionality is available from the teacher dashboard, clearing the stored session.

---

### Data & Models (Foundational Files)
- `lib/data/seed_words.csv` — Contains Dolch + Phonics word lists with 2–3 example sentences per word (used for mock practice and progress screens).  
- `lib/models/` — Houses foundational data structures such as `WordItem`, role enums, and model placeholders for future Firestore/JSON extensions.  
- `lib/services/speech_service.dart` — Handles local speech-to-text comparison for mock pronunciation feedback (using `speech_to_text`).  
- `lib/services/storage_service.dart` — Placeholder for saving and retrieving practice attempts (to sync with Firebase in later milestones).

---

### Architecture Notes
- Follows **Flutter + Provider architecture**, with clear separation of screens, services, and data models.  
- Uses **Firebase Core** for backend initialization and **SharedPreferences** for local persistence.  
- Screen transitions rely on `Navigator` and route-based navigation for role-specific flows.  
- UI currently emphasizes static mocks for layout and design iteration before adding backend scoring and analytics.

---

### UI Placeholders for Front-End Development
- `lib/widgets/record_placeholder.dart` — Static microphone recording UI mock used in the Practice screen.  
- `lib/widgets/feedback_placeholder.dart` — Placeholder showing pronunciation feedback layout.  
- `lib/widgets/charts_placeholder.dart` — Mock chart visualizations used in the Progress and Student Progress screens.  

---

Progress:
## Milestone 0 – Prototype: Structure & Screens

**Theme:** App Skeleton and Navigation Framework

**Objectives:**
- Completed **full app skeleton** with all main screens and navigation functional:
  - Login
  - Word List
  - Practice
  - Feedback
  - Progress
  - Teacher Dashboard
- Established clean folder and file layout:
  - `lib/models/` — data models and enums  
  - `lib/services/` — authentication and placeholder backend logic  
  - `lib/screens/` — student and teacher screen flows  
  - `lib/widgets/` — reusable UI elements (record, charts, feedback mockups)  
  - `assets/data/` — includes initial seed data (`seed_words.csv`)
- Added `seed_words.csv` with ≈20 sample entries across Dolch, Phonics, and Minimal Pair word sets.
- Built **static UI placeholders** for record button, feedback output, and progress charts (no audio or scoring yet).
- Implemented **bottom navigation** and mock transitions to demonstrate complete app flow.

**Outcome:**  
Delivered a functional prototype demonstrating app structure, user flow, and navigation between all planned screens.  
This milestone focused on UI architecture and project organization, setting the stage for functional implementation in later phases.

---

## Milestone 1 – Foundation & Vertical Slice (MVP)

**Theme:** User Authentication, Practice Flow Prototype, and Persistent Sessions

**Objectives Implemented:**
-  **User Authentication**
  - Added Firebase Email/Password sign-in for Students and Teachers.
  - Implemented session persistence using SharedPreferences.
  - Restores user role (student/teacher) automatically on restart.

- **Seed Word Lists**
  - Integrated Dolch and Phonics word sets from `seed_words.csv`.
  - Each word includes 2–3 example sentences.
  - Designed scalable data model for future JSON/Firestore support.

- **Practice Flow**
  - Implemented end-to-end mock of:
    - **Word display** → **Record (≤7s)** → **Local STT comparison** → **Feedback** → **Save attempt**.
  - Speech recognition handled by a stub in `speech_service.dart` using `speech_to_text`.
  - Attempts stored temporarily using a mock `storage_service.dart` (to sync in Milestone 2).

- **Provider Interface**
  - Defined provider pattern for global state management.
  - Implemented mock provider to simulate practice attempts, score tracking, and session persistence.

- **Progress Screen**
  - Added `progress_screen.dart` showing:
    - Total attempts per category.
    - Average score placeholder.
    - Mock visual charts using `charts_placeholder.dart`.

**Outcome:**  
Milestone 1 delivered a **functional vertical slice** — from login through a simulated reading practice and progress tracking loop.  
Students can sign in, practice with Dolch/Phonics words, see mock feedback, and view placeholder progress data.  
The project now forms the foundation for Milestone 2 features like **cloud pronunciation scoring, CSV exports, and teacher analytics.**
