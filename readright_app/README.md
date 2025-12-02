# readright_app

A mobile app that helps children practice reading words aloud, 
receive pronunciation feedback, and track progress.


### To run the app 
There is a .env file that has been turned 
into Milestone 3 and the Final Milestone, it needs to be
downloaded and placed in the project root folder(e.g where the yaml is, firebase, etc is)
It couldn't be placed in the github due to it containing sensitive azure keys and being apart
of gitignore.
After that run flutter pub get and then run it
When in the app first you need to create a teacher account with an email and password 
that has a 6 character minimum
then you can add students in the manage class screen, 
and then when you go to the student section you can choose the students you created and begin practicing

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
  - **Practice** — speech recording and local STT comparison  
  - **Feedback** — pronunciation feedback display  
  - **Progress** — chart-based visual progress tracking  
- `lib/screens/practice_screen.dart` — Implements mock practice flow (Word → Record → Compare → Feedback). Integrates with `speech_service.dart`.  
- `lib/screens/feedback_screen.dart` — Displays pronunciation feedback and accuracy placeholders.  
- `lib/screens/progress_screen.dart` — Shows mock charts and progress summaries using static placeholder data.

---

### Teacher Experience (Core Screens)
- `lib/screens/teacher_dashboard_screen.dart` — Teacher dashboard providing navigation to manage word lists and review student progress.  
- `lib/screens/student_progress_screen.dart` — Displays placeholder charts for student performance analytics (to be populated in later milestones).  
- `lib/screens/manage_word_list_screen.dart` — interface for teachers to view Dolch/Phonics word lists and the words in them. They can also upload csv word lists to the app.  
- `lib/screens/word_list_screen.dart` - screen to view the words and sentences in the word lists.
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
### UI Placeholders and style widgets for Front-End Development
- `lib/widgets/record_placeholder.dart` — Static microphone recording UI mock used in the Practice screen.  
- `lib/widgets/feedback_placeholder.dart` — Placeholder showing pronunciation feedback layout.  
- `lib/widgets/charts_placeholder.dart` — Mock chart visualizations used in the Progress and Student Progress screens.
- `lib/widgets/mascot_widget.dart` — Wrapper widget for displaying the animated reading-assistant mascot.
- `lib/widgets/mascot_tiger.dart` — The illustrated tiger mascot used in the student UI.
- `lib/widgets/animated_mascot.dart` — Animation controller for the mascot’s breathing/movement loop.
- `lib/widgets/accessibility_button.dart` — Floating accessibility toggle for high-contrast mode and large-text mode.

### Backend Services & Cloud Assessment Components
These files power the cloud-based pronunciation scoring, fallback logic, and feedback generation.
Cloud Scoring
- `lib/services/azure_assessor.dart` — Integrates Azure’s Pronunciation Assessment API:
Encodes audio
Sends scoring requests
Parses accuracy, fluency, completeness, and per-word accuracy
Uses .env keys for authentication
lib/services/cloud_fallback_assessor.dart — Local fallback when Azure is unavailable, offline, or errors out.

Assessment Routing
- `lib/services/cloud_assessment_service.dart` — Determines whether to use Azure or fallback.
Handles:
  Connectivity detection
  Exception handling
  Unified output via AssessmentResult

Assessment Model
- `lib/models/assessment_result.dart` — Defines pronunciation scoring results:
  accuracy, fluency, completeness
  perWordAccurac
  overallScore (weighted composite)
  provider (azure / fallback)

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

## Milestone 2 – Cloud Scoring, Feedback Grades, Teacher Tools & Accessibility

**Theme**: Cloud Pronunciation Assessment + Feedback Integration + Teacher Utilities + Offline Support

**Objectives Implemented**:
Cloud Pronunciation Assessment (Azure) : Implemented the full cloud scoring pipeline using Azure’s Pronunciation Assessment API.
Created the PronunciationAssessor abstraction and the concrete AzurePronunciationAssessor for sending:
  Base64-encoded audio
  Reference text
  Assessment configuration (accuracy, fluency, completeness)
Added automatic local fallback (cloud_fallback_assessor.dart) for offline or failed cloud requests.
Introduced CloudAssessmentService to route all scoring through Azure or fallback seamlessly.

**Feedback Screen with Real Cloud-Generated Grades**
The Feedback screen now displays actual Azure-generated pronunciation scores, including:
  Accuracy
  Fluency
  Completeness
  Overall weighted score
If cloud scoring fails, fallback appear automatically to preserve the user experience and make sure it doesn't fail.

**Offline Queue & Sync Mechanism**
Added a local queue for storing practice attempts when the device is offline.
Attempts include:
Word practiced
Timestamp
Raw audio
Score results
Cloud/fallback indicator
Queue automatically syncs when network is restored, retrying in order and without duplicates.

**Teacher Dashboard v1** (Structure & Filters)
Updated the UI of the teacher dashboard to be more visually appealing
Implemented placeholder data and structures for analytics (to be populated in the next milestone).
Added ability to export students attempts with date range in a pdf format
Added screens and ability to view the individual words and sentences in word lists and upload new word lists.


**Accessibility Improvements**:
Added accessibility_service.dart and a global accessibility toggle button.
Introduced:
  Large-button / large-text mode
  High-contrast mode
  Clear visual states for recording, idle, and disabled modes
  Integrated animated mascot widgets to improve engagement and guide younger readers.

**System Stability Enhancements**:
Improved async safety and exception handling around audio recording and cloud APIs.
Refactored speech_service.dart for cleaner recording → scoring → feedback sequencing.

**Outcome**:
Milestone 2 delivered major functional upgrades: real cloud-powered pronunciation scoring, feedback based on Azure results, reliable offline operation, foundational teacher dashboard structures, and comprehensive accessibility enhancements.
Two items remain incomplete — CSV export for date ranges and the implemented teacher dashboard, which will be finished before our meeting and before we start Milestone 3.

## Milestone 3: Audio Retention + Analytics + Robust Error Handling + Testing
**Theme**: Audio Retention + Analytics + Robust Error Handling + Testing

Enhancements:
**Audio Retention & Teacher Playback**
  Implement secure upload of recorded audio clips to cloud storage (e.g., Firebase Storage).
  Enable teachers to review and playback student attempts inside the Teacher Dashboard.

**Enhanced Progress Analytics**(Not done yet will be done by final milestone)
  Replace placeholder charts with real, data-driven analytics pulled from synced practice attempts.
  Add improvement trendlines over time for accuracy, fluency, and completeness.
  Generate “Most Missed Words” lists to help teachers understand common student difficulties.
  Integrate analytics with date-range filtering for personalized progress reporting.

**CSV / JSON Export Tools**
  Implement export of class or individual student performance data over a chosen date window.
  Support CSV or JSON formats for compatibility with school reporting systems.
  Add download buttons and backend formatting utilities.

**Teacher Dashboard Completion**
Replace mock data with real synced attempts.
Add student and class overview with filters (student/list/date).

**Error Handling & Reliability Upgrades**
  Strengthen network failure detection:
  Background retry logic

**Testing & Quality Assurance**
Added 5 unit tests for local progress service, word_list service, attempt_record, and cloud_assessment
Added at least 3 widget tests covering:
  Practice screen recording + feedback flow
  Feedback screen score rendering
  Student Home navigation

## Future Milestone
For the Final Milestone, we will implement:
  Enhanced Progress Analytics for the teachers
  Performance: feedback ≤ 3 s on Wi-Fi.
  finalized Teacher controls.
  Documentation pack – Teacher Quick-Start, setup guide, API key handling, data model diagram.
  Minimum of 10 students and 1 teacher in data store
  All Doche lists loaded with associated audio files for words and sample sentences
  Refine the practicing/assessment function so that it is as accurate as possible


