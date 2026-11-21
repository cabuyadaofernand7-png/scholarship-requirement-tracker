## Executed UAT Observations â€” 21 November 2026

### UAT-OBS-001 â€” Student Dashboard

- **Observation ID:** UAT-OBS-001
- **Scenario ID:** Student dashboard and application overview
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8)
- **Build commit/tag:** Not recorded; local working build
- **Environment:** Windows desktop, Microsoft Edge, Flutter Web, Laravel local API, isolated MariaDB test database
- **Tester role (synthetic):** Student
- **Preconditions:** Student authenticated successfully.
- **Steps performed:** Opened the dashboard and reviewed application records and summary cards.
- **Expected result:** Dashboard displays the student's applications, statuses, document counts, and notifications.
- **Actual result:** Three applications displayed. The dashboard showed 12 submitted documents and 0 missing documents. All three applications displayed SUBMITTED status.
- **Pass/fail/blocked:** Pass
- **Evidence filename(s):** `documentation/week-17/10-evidence-index/evidence/screenshots/W17-E03-01-dashboard.png`
- **Personal data/secrets check:** Review screenshot before committing.
- **Notes:** All displayed application records reflected the existing test data.

### UAT-OBS-002 â€” Application Details and Document Checklist

- **Observation ID:** UAT-OBS-002
- **Scenario ID:** Application details and document checklist
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8)
- **Build commit/tag:** Not recorded; local working build
- **Environment:** Windows desktop, Microsoft Edge, Flutter Web
- **Tester role (synthetic):** Student
- **Preconditions:** Student authenticated; three submitted applications available.
- **Steps performed:** Opened all three application cards and reviewed their program information, application numbers, statuses, required documents, uploaded filenames, and progress.
- **Expected result:** Each application displays its correct details and document checklist.
- **Actual result:** All three applications displayed their details and four completed required documents. Each showed 100% progress. Uploaded filenames were visible. Upload controls were unavailable for submitted applications.
- **Pass/fail/blocked:** Pass
- **Evidence filename(s):** `documentation/week-17/10-evidence-index/evidence/screenshots/W17-E03-02-application-details.png`
- **Personal data/secrets check:** Review screenshots before committing.
- **Notes:** TEST-W13-MISSING-001 also had all four required documents uploaded. Its name did not represent its current database state.

### UAT-OBS-003 â€” Dashboard Refresh

- **Observation ID:** UAT-OBS-003
- **Scenario ID:** Dashboard refresh
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8)
- **Build commit/tag:** Not recorded; local working build
- **Environment:** Windows desktop, Microsoft Edge, Flutter Web
- **Tester role (synthetic):** Student
- **Preconditions:** Student dashboard loaded successfully.
- **Steps performed:** Refreshed the dashboard and reviewed the application and document summary counts.
- **Expected result:** Dashboard reloads without an error and displays consistent data.
- **Actual result:** Three applications, 12 submitted documents, and 0 missing documents remained displayed.
- **Pass/fail/blocked:** Pass
- **Evidence filename(s):** `documentation/week-17/10-evidence-index/evidence/screenshots/W17-E03-03-dashboard-refresh.png`
- **Personal data/secrets check:** Review screenshot before committing.
- **Notes:** No visible loading error was observed.

### UAT-OBS-004 â€” Notification Panel

- **Observation ID:** UAT-OBS-004
- **Scenario ID:** Notification viewing
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8)
- **Build commit/tag:** Initial observation and corrected local working build; commit not recorded.
- **Environment:** Windows desktop, Microsoft Edge, Flutter Web
- **Tester role (synthetic):** Student
- **Preconditions:** Student dashboard loaded successfully.
- **Steps performed:** Initially clicked the notification bell; after correction, clicked it again and reviewed the notification panel.
- **Expected result:** Clicking the bell opens a panel showing available notifications.
- **Actual result:** Initial click produced no response. After correction, the panel opened and displayed three notifications with their titles and messages.
- **Pass/fail/blocked:** Initial attempt failed; corrected retest passed.
- **Evidence filename(s):** Initial failure: `documentation/week-17/10-evidence-index/evidence/screenshots/W17-E04-01-notification-panel.png`; corrected retest: `documentation/week-17/10-evidence-index/evidence/screenshots/W17-E04-02-notification-retest.png`
- **Personal data/secrets check:** Review screenshots before committing.
- **Notes:** The initial defect and its correction are recorded separately in the fix and retest register.

### UAT-OBS-005 â€” Flutter Automated Verification After Notification Fix

- **Observation ID:** UAT-OBS-005
- **Scenario ID:** Frontend regression verification
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8)
- **Build commit/tag:** Not recorded; local working build
- **Environment:** Flutter development environment on Windows
- **Tester role (synthetic):** Developer/tester
- **Preconditions:** Notification panel implementation and widget test updated.
- **Steps performed:** Executed Flutter widget tests, static analysis, and production web release build.
- **Expected result:** Tests pass, static analysis reports no issues, and release build completes.
- **Actual result:** `flutter test` passed. `flutter analyze` reported no issues. `flutter build web --release` completed successfully and generated `build\web`.
- **Pass/fail/blocked:** Pass
- **Evidence filename(s):** `documentation/week-17/10-evidence-index/evidence/test-outputs/W17-E04-03-flutter-test.png`, `documentation/week-17/10-evidence-index/evidence/test-outputs/W17-E04-04-flutter-analyze.png`, and `documentation/week-17/10-evidence-index/evidence/test-outputs/W17-E04-05-flutter-release-build.png`
- **Personal data/secrets check:** Review terminal captures before committing.
- **Notes:** The WASM dry-run message was informational and did not prevent the release build.

### UAT-OBS-006 â€” Correction-Resubmission Backend Regression

- **Test type:** Automated backend regression; not browser UAT.
- **Implementation:** Student applications in `for_correction` status may be resubmitted when required documents have valid submitted records.
- **Validation:** The backend records the previous application status and a correction-resubmission reason in status history.
- **Automated results:** The focused application-submission tests passed, including successful correction resubmission and rejection when required documents are missing. The complete backend suite passed with 62 tests and 145 assertions.
- **Browser UAT status:** UAT-23 passed after user-assisted native file selection. The replacement document was uploaded and the correction resubmission was confirmed in the UI and isolated database; see UAT-OBS-009.

### UAT-ENV-001 â€” Initial Authenticated UAT Readiness Check

- **Record type:** Environment readiness observation; not a UAT scenario result.
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8).
- **Build:** Current uncommitted Week 17 Flutter Web release build and local Laravel API.
- **Environment:** Local browser; API at `http://127.0.0.1:8000/api`; isolated MariaDB test data directory configured through `C:\MariaDB_Recovery\restore_test.ini` on port 3308.
- **Observed:** The Flutter Web build loaded and displayed the Scholarship Requirement Tracker sign-in screen. No credentials were entered and no authenticated UAT scenario was run.
- **Initial diagnostic:** A second MariaDB startup attempt returned an `ibdata1 must be writable` error. Follow-up process inspection found that the approved isolated instance was already running on port 3308 under `restore_test.ini` and held the data file. The duplicate startup attempt was aborted; no ACL changes or database writes were made.
- **Disposition:** The isolated instance is available. Laravel connected successfully, and all 15 migrations report `Ran`. This initial readiness check itself did not execute an authenticated UAT scenario.
- **Evidence boundary:** The local sign-in screen was visually observed during the initial check. No screenshot file was saved for this record.

### UAT-ENV-002 â€” Isolated Database and Browser UAT Readiness

- **Record type:** Environment readiness observation; not a UAT scenario result.
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8).
- **Build/environment:** Current uncommitted Week 17 Flutter Web release build served at `http://127.0.0.1:5001/`; Laravel API at `http://127.0.0.1:8000/api`; MariaDB test instance on port 3308 launched with `C:\MariaDB_Recovery\restore_test.ini`.
- **Database verification:** `php artisan migrate:status` connected successfully; all 15 migrations were `Ran`. Read-only aggregate counts showed one account for each role (student, staff, reviewer), three submitted applications, one active scholarship program, and zero reviewer assignments. No names, email addresses, or credentials were queried or recorded.
- **Application verification:** The Flutter Web release build loaded in Microsoft Edge and displayed the sign-in screen. The user must enter the existing controlled student credentials locally before student UAT can proceed; credentials must not be posted in chat.
- **Changes:** No database records were changed by this readiness check; no migrations were applied; the pristine backup was not touched.
- **Evidence file:** `documentation/week-17/08-repository-and-maintenance/verification-20261121-role-dashboards/database-readiness-20261121.txt`.
- **Status:** Environment ready. The project owner subsequently entered the controlled student credentials locally; UAT-OBS-007 records student browser UAT. UAT-OBS-008 records the later staff/reviewer sessions.

### UAT-OBS-008 — Staff Assignment and Reviewer Workflow

- **Scenario IDs:** UAT-03, UAT-11, UAT-13, UAT-24, UAT-25, and UAT-26; UAT-15 is also covered by the verified allowed status transition.
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8).
- **Build/environment:** Current uncommitted Flutter Web build in Microsoft Edge; Laravel API and isolated MariaDB test database on port 3308.
- **Accounts:** Existing controlled staff and reviewer accounts. As the original passwords were unknown, temporary passwords were set only in the isolated UAT database; original password hashes were restored from a temporary backup after testing. No password is recorded here.
- **Steps and actual results:** Staff logged in, reviewed submitted applications, and assigned the first controlled application to the existing reviewer. UI showed the assignment. A read-only database check confirmed one assignment and one `review_assignment` notification. Reviewer logged in and saw the assigned application and its submitted documents. Selecting a protected document download produced the PDF in Edge Downloads. The reviewer changed status from `submitted` to `under_review`, then to `for_correction`; the UI showed both successful outcomes and the database status history matched.
- **Scenario dispositions:** UAT-03, UAT-11, UAT-13, UAT-15, UAT-24, UAT-25, and UAT-26 Pass using the recorded browser workflow and state checks. At the time of this browser observation, separate API-response evidence had not yet been captured. UAT-14 unassigned-reviewer denial and UAT-16 invalid transition were subsequently executed and passed through authenticated API UAT-OBS-012.
- **Evidence:** `W17-UAT-24-staff-application-queue.png`, `W17-UAT-24-reviewer-assignment-confirmed.png`, `W17-UAT-25-reviewer-assigned-application.png`, `W17-UAT-26-submitted-to-under-review.png`, `W17-UAT-26-reviewer-for-correction-outcome.png`, and `verification-20261121-role-dashboards/uat-state-check-20261121.json`.
- **Data check:** Evidence contains synthetic test records. No passwords, tokens, or personal downloads were captured. The local test account hashes have been restored.

### UAT-OBS-009 — Correction Resubmission Retest

- **Scenario IDs:** UAT-04 and UAT-23 (same permitted required-document upload; the correction-resubmission flow adds UAT-23's status/history acceptance criteria).
- **Date/time/timezone:** 21 November 2026; exact time not recorded; Philippine Time (UTC+8).
- **Environment:** Windows desktop, Microsoft Edge, Flutter Web at `http://127.0.0.1:5001/`, Laravel local API, isolated MariaDB test database.
- **Preconditions and observation:** Student opened an application in `for_correction`. Application details showed four of four required documents with uploaded files and the correction instruction.
- **Steps attempted:** Selected Change for a requested document, which opened the native Windows file picker. The computer-control interface exposed the dialog in the accessibility tree but its input target resolved to a different Edge window, so no file could be selected.
- **Actual result:** After the student session was re-established, the controlled PDF was selected and uploaded. The application details displayed `week13_dummy_document (1).pdf` for Certificate of Registration and 4/4 required documents. The student submitted the application; the dashboard displayed SUBMITTED and a success toast. A read-only database check confirmed the new filename, `submitted` status, and status history entry from `for_correction` to `submitted` with reason `Corrected application resubmitted.`
- **Disposition:** Pass after user-assisted native file selection. UAT-FND-002 is closed by workaround and verified retest; no code change was required.
- **Evidence:** `W17-UAT-23-correction-required-student-view.png`, `W17-UAT-23-corrected-document-selected.png`, `W17-UAT-23-correction-documents-ready-to-resubmit.png`, `W17-UAT-23-correction-resubmission-success.png`, and `verification-20261121-role-dashboards/uat-state-check-20261122-correction-resubmission.json`.
- **Data and account handling:** Only the controlled test PDF was uploaded to the local isolated application. Original controlled account password hashes were restored after the role sessions.

### UAT-OBS-010 — Invalid Login Rejected by API

- **Scenario ID:** UAT-02
- **Date:** 22 November 2026 (Philippine Time, UTC+8).
- **Environment:** Local Laravel API at `http://127.0.0.1:8000/api`; controlled test environment.
- **Steps:** Sent one `POST /api/login` request with a reserved `.test` email address and a dummy invalid password. No existing account credential was used.
- **Expected:** Invalid credentials are rejected without an authenticated token.
- **Actual:** API returned HTTP 401 JSON with the generic message `Invalid email or password.` and no token field.
- **Disposition:** Pass (API scenario; not browser UAT).
- **Evidence:** `documentation/week-17/10-evidence-index/evidence/test-outputs/W17-UAT-02-invalid-login-response.json`.
- **Data check:** The evidence omits the submitted dummy password and records no personal data.

### UAT-OBS-011 — Unauthenticated Protected API Access Denied

- **Scenario ID:** UAT-09
- **Date:** 21 November 2026 (Philippine Time, UTC+8), as recorded in the OpenAPI live-response evidence.
- **Environment:** Local Laravel API at `http://127.0.0.1:8000/api`.
- **Steps:** Issued requests without a bearer token to the 16 protected API operations; `/api/applications` was among the checked routes.
- **Expected:** Protected endpoints reject unauthenticated requests with HTTP 401 JSON.
- **Actual:** All 16 operations returned HTTP 401 JSON and matched the documented contract.
- **Disposition:** Pass (API scenario; not browser UAT).
- **Evidence:** `documentation/week-17/08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-all-protected-routes.json`.
- **Data check:** Requests used no credentials or personal data.


### UAT-OBS-012 — Authenticated API Authorization and Contract Checks

- **Scenario IDs:** UAT-05–08, UAT-10, UAT-12–14, UAT-16, and UAT-18.
- **Date/time/timezone:** 22 November 2026, approximately 00:38 Philippine Time (UTC+8).
- **Environment:** Local Laravel API at `http://127.0.0.1:8000/api` and isolated MariaDB test database on port 3308.
- **Steps:** Used short-lived Sanctum tokens and temporary synthetic student/reviewer records to make the listed requests. Verified response codes and relevant application, assignment, notification, or download state. For UAT-05–07 and UAT-18, created controlled draft/program data and uploaded synthetic PDFs where needed. Removed temporary accounts, programs, applications, document rows/files, and tokens; follow-up database queries found zero temporary records.
- **Actual results:** UAT-05 unsupported `.exe` upload returned 422 and created no document record. UAT-06 created a draft, uploaded four permitted PDFs (201 each, all present in private storage), submitted successfully (200), and recorded `draft` → `submitted`. UAT-07 submission with four missing requirements returned 422 and left the application draft. UAT-08 cross-student submission returned 403 and left the target submitted application unchanged. UAT-10 returned 200 with zero records to the temporary student while the target student had five notifications. UAT-12 returned 403 to student reviewer-assignment attempt and assignment count stayed at one. UAT-13 assigned-reviewer download returned 200 `application/pdf` (26,672 bytes). UAT-14 unassigned-reviewer download returned 403. UAT-16 invalid `submitted` → `approved` transition returned 409 and left application status submitted. UAT-18 reminder checks returned 200 twice; the first created a reminder, the second did not, and one active reminder remained after both checks.
- **Disposition:** Pass for all six API checks. UAT-13 also has the previously recorded browser download result under UAT-25. These checks expand the live API comparison; they do not establish complete authenticated schema conformance for all routes.
- **Evidence:** `documentation/week-17/08-repository-and-maintenance/verification-20261121-role-dashboards/openapi-live-authenticated-uat-20261122.json`.
- **Data and account handling:** The evidence omits access tokens, temporary credentials, user IDs, application IDs, and downloaded file contents. Temporary synthetic users, programs, and tokens were removed; read-only checks found no temporary records remaining.


### UAT-OBS-013 — Student Browse and Draft Creation; Narrow-Window Observation

- **Scenario IDs:** UAT-27 (Pass); UAT-19 (Pass at the tested window widths).
- **Date/time/timezone:** 22 November 2026, Philippine Time (UTC+8).
- **Environment:** Windows, Microsoft Edge, Flutter Web at `http://127.0.0.1:5001/`, local Laravel API, isolated MariaDB test database.
- **Preconditions:** Added a synthetic active program, `W17 UAT Controlled Open Program`, with four required document types and a future deadline to the isolated test database. The controlled student had no application for this program.
- **Steps and actual result (UAT-27):** Student opened New Application, reviewed the program and four requirements, created a draft, and saw the new application in the refreshed dashboard. Read-only database verification confirmed the controlled student owns the draft, it references the synthetic program, status is `draft`, and no documents have been uploaded.
- **Disposition (UAT-27):** Pass. No finding observed.
- **Responsive result (UAT-19):** Compared existing 950 × 814 desktop-window evidence with a 502 × 814 narrow Edge window at 100% zoom. Dashboard cards stacked vertically; New Application stayed visible; requirement details wrapped inside the card; and scrolling reached the “Already applied · draft” control without visible horizontal overflow or clipped controls. Smaller widths and actual mobile devices were not tested.
- **Evidence:** `W17-UAT-27-open-program-and-requirements.png`, `W17-UAT-27-draft-created.png`, `uat27-program-readiness-20261122.json`, and `W17-UAT-19-narrow-viewport-zoom.png`, `W17-UAT-19-program-list-502px-100percent.png`, and `W17-UAT-19-dashboard-502px-100percent.png`.
- **Data handling:** The synthetic program and resulting draft remain in the isolated local UAT database for inspection. No credentials or personal data were included in the evidence.


### UAT-OBS-014 — Backend Outage Safe Failure and Recovery

- **Scenario ID:** UAT-20.
- **Date/time/timezone:** 22 November 2026, Philippine Time (UTC+8).
- **Environment:** Windows, Microsoft Edge, Flutter Web at `http://127.0.0.1:5001/`, project-local Laravel API at `http://127.0.0.1:8000/`.
- **Steps:** With the student dashboard open, stopped the project-local Laravel server and opened New Application. Restarted the Laravel server using `php artisan serve --host=127.0.0.1 --port=8000`, then selected Retry.
- **Expected:** The program request fails safely while the API is unavailable and succeeds after service recovery.
- **Actual:** The page displayed “Unable to load open scholarship programs” and a Retry control during the outage. After the Laravel server restarted, Retry loaded the synthetic open program and requirements. The API listener was confirmed responding at recovery; no application or document state was altered by this scenario.
- **Disposition:** Pass. Recovery was retested in the browser.
- **Evidence:** `W17-UAT-20-program-load-backend-unavailable.png` and `W17-UAT-20-program-load-recovered.png`.


### UAT-OBS-015 — Storage Failure Safe Response and Retest

- **Scenario ID:** UAT-17.
- **Date/time/timezone:** 22 November 2026, Philippine Time (UTC+8).
- **Environment:** Local Laravel API, isolated MariaDB test database, controlled student draft and synthetic PDF.
- **Failure injection:** Preserved the private storage directory under a temporary sibling name and placed a temporary file at the original storage-root path, causing a real directory-creation failure. The original directory was restored in a `finally` cleanup path.
- **Initial actual result:** HTTP 500 exposed an absolute local storage path. The controlled required-document slot remained empty. Opened UAT-FND-003.
- **Fix and retest:** Added handling for Flysystem filesystem exceptions in the upload controller, reporting the exception server-side while returning a generic HTTP 503 response. Repeated the same controlled outage. The API returned `Document storage is temporarily unavailable. Please try again later.` with HTTP 503; the before and after document counts were both zero; the local path was not exposed. The original storage directory was restored. Temporary token and upload file were removed.
- **Disposition:** Pass after fix and retest. UAT-FND-003 closed.
- **Evidence:** `uat17-storage-failure-20261122.json`, `uat17-storage-failure-retest-20261122.json`, and `fix-and-retest-register.md`.
- **Automated regression:** Focused feature test passed (1 test, 4 assertions).
