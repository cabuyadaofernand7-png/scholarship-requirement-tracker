# Week 17 UAT Documentation and Evaluation Ã¢â‚¬â€ Weekly Summary

**Project:** Scholarship Requirement Tracker
**Week:** 17 Ã¢â‚¬â€ UAT Documentation and Evaluation (SA9 and AS3)
**CLO alignment:** CLO5 and CLO6
**Guide dates:** November 23Ã¢â‚¬â€œ27, 2026
**Recorded preparation and UAT observation date:** November 21–22, 2026
**Baseline commit:** `3fb56db6f33889f1cb530cf71282dc6768224d50`
**Tested build:** Local Week 17 working tree based on the baseline commit; Week 17 changes uncommitted
**Release tag:** No Week 17 tag created
**Overall status:** UAT execution complete; instructor approval reported by project owner; 28 scenarios passed (16 browser and 12 API-only; UAT-04 and UAT-13 also have supplementary API evidence), no scenarios are blocked or Not run. Final Git and secret review completed on 22 Nov 2026; no commit or push made. Laravel Boost is pinned to `^2.10` and its generated developer guidance/config retained intentionally

> The browser observations and verification evidence recorded in this summary are dated November 21–22, 2026, before the scheduled Week 17 guide dates. They are reported using their actual dates and are not represented as activities performed during November 23Ã¢â‚¬â€œ27.

## 1. Objectives

The Week 17 objectives are to:

- Prepare a controlled UAT plan and scenario catalogue.
- Execute available UAT scenarios and record actual observations.
- Record defects, corrections, and retest evidence.
- Review the Flutter Web workflow and responsive-testing boundaries.
- Compare architecture alternatives and document the selected approach.
- Prepare an OpenAPI specification and review it against Laravel routes.
- Complete repository guidance, maintenance planning, known limitations, and a final recommendation.
- Organize evidence so that the project can be reviewed by the instructor or other stakeholders.

## 2. Work completed

The following work has been completed or prepared and documented:

1. Prepared the UAT plan, including scope, roles, entry and exit criteria, and test environment. The project owner confirmed instructor approval; the formal approval artifact is not attached.
2. Prepared a 28-scenario UAT catalogue covering student, staff, reviewer, security, document, notification, and recovery workflows.
3. Recorded 16 passing browser scenarios across student, staff, and reviewer roles, including permitted document upload, correction resubmission, reviewer assignment/download, and allowed status transitions. UAT-17 passed after its storage exception fix; UAT-19 passed at tested widths; UAT-20 passed after backend recovery; UAT-27 passed after the controlled student created a draft program application.
4. Ran UAT-02 against the local login API with invalid test-only values. It returned JSON 401 and no token; the sanitized response is recorded without the dummy password.
5. Recorded UAT-09 API evidence: all 16 protected endpoints returned JSON 401 without a bearer token.
6. Completed UAT-23 after user-assisted native file selection. The corrected document uploaded, the student resubmitted successfully, and the isolated database confirmed the submitted status and status-history transition.
7. Updated the controlled staff and reviewer account passwords only in the isolated UAT database for login, restored all three original password hashes from a temporary protected backup, and removed that backup after verification.
8. Corrected the notification button by connecting it to the notification-loading method and adding a notification panel with loading, error, and empty-state handling.
9. Updated the Flutter widget test to cover opening the notification panel.
10. Prepared a Flutter Web workflow checklist and recorded the tested login viewport and untested browser workflows.
11. Compared architecture alternatives and documented a provisional recommendation to retain Flutter Web, Laravel API, and MariaDB for the academic prototype.
12. Expanded the OpenAPI 3.1.0 specification for the current 18-operation source. Redocly lint passed with one non-fatal missing-license warning; all operations have IDs. The 16 protected-route responses match the documented 401 JSON response, and empty JSON requests to login and registration returned the documented 422 validation status. Authenticated API checks now include selected protected operations, including UAT-17 storage failure; full response-schema comparison remains pending.
13. Updated repository guidance and the maintenance plan with recorded technology versions, setup guidance, test results, data-protection requirements, recovery safeguards, and operational limitations.
14. Updated the known-limitations document and final recommendation.
15. Organized the available screenshots and UAT state evidence under the Week 17 evidence directory.
16. UAT-17 exposed and closed UAT-FND-003; a focused regression test passed (1 test, 4 assertions), and the live controlled storage outage retest returned HTTP 503 without a document row. The OpenAPI upload operation now documents that JSON error response.
17. A prior complete Laravel backend regression run passed with 62 tests and 145 assertions. After implementing the staff/reviewer queues, the focused role feature tests passed with 3 tests and 14 assertions, and the full suite passed with 69 tests and 175 assertions using PHPUnit's SQLite in-memory configuration before UAT-FND-003. After the UAT-17 fix, the focused exception regression passed with 1 test and 4 assertions; the final full suite then passed with 70 tests and 179 assertions (run on 22 Nov; evidence saved in `08-repository-and-maintenance/verification-20261121-role-dashboards/backend-verification-after-storage-fix-20261122.txt`). Current outputs are recorded under `08-repository-and-maintenance/verification-20261121-role-dashboards/`.
18. Implemented staff/reviewer work queues and dashboards, plus the student New Application program browser and draft creation flow. Dart analysis reported no issues, both Flutter widget tests passed, and the current Flutter Web release build completed successfully. The current Laravel route list reports 18 routes. These checks are technical verification, not browser UAT.

## 3. UAT results

The scenario catalogue contains 28 scenarios. All 28 have recorded passing outcomes (16 browser, 12 API-only).

| Metric | Actual |
|---|---:|
| Scenarios planned | 28 |
| Scenarios with recorded results | 28 |
| Passed in final recorded state | 28 (16 browser, twelve API) |
| Failed in final recorded state | 0 |
| Blocked | 0 |
| Not run | 0 |
| Findings opened | 3 |
| Findings resolved and retested | 3 |
| Unresolved findings from the recorded execution | 0 |

### Executed scenarios

| Scenario | Result | Observation |
|---|---|---|
| UAT-01 Ã¢â‚¬â€ Valid student login | Pass | Student dashboard displayed and authenticated application data loaded |
| UAT-21 Ã¢â‚¬â€ Dashboard and application details | Pass | Three applications, twelve submitted documents, zero missing documents; refresh retained the displayed records |
| UAT-22 Ã¢â‚¬â€ Notification panel | Pass after correction | Notification panel opened and displayed three notification records after the button callback was corrected |
| UAT-02 Ã¢â‚¬â€ Invalid login API | Pass (API) | Invalid test-only values returned generic JSON 401 and no token |
| UAT-05–08, UAT-10, UAT-12–14, UAT-16–18 | Pass (API) | Upload validation, complete/missing submission, access controls, notification isolation, reminder deduplication, and invalid transition had verified responses/state |
| UAT-09 Ã¢â‚¬â€ Unauthenticated protected API | Pass (API) | Sixteen protected operations returned JSON 401 and matched the documented contract |
| UAT-03, UAT-11, UAT-24 Ã¢â‚¬â€ Staff login and assignment | Pass | Staff dashboard displayed the queue; reviewer assignment and its notification were confirmed in isolated database state |
| UAT-03, UAT-13, UAT-25 Ã¢â‚¬â€ Reviewer login and assigned document access | Pass | Reviewer saw its assigned application and documents; authorized document download succeeded |
| UAT-15, UAT-26 Ã¢â‚¬â€ Review status workflow | Pass | Reviewer moved the application through under_review to for_correction; status history matched |
| UAT-28 Ã¢â‚¬â€ Existing program application | Pass | Program was marked already applied; no duplicate was created |
| UAT-04, UAT-23 — Required-document replacement and correction resubmission | Pass | User-assisted file selection, private-storage file, and submitted status verified |
| UAT-17 — Storage unavailable | Pass after fix and retest | Initial 500 path leak was corrected; repeated outage returned generic 503 and no document row |
| UAT-19, UAT-20, UAT-27 — Responsive layout, outage recovery, draft creation | Pass | Narrow 502 px layout remained usable; Retry recovered program list; controlled draft appeared on refreshed dashboard |

The three submitted student application records shown in the earlier dashboard session each displayed four required documents and 100% completion; the later draft-creation UAT added a fourth application. Separate controlled API scenarios verified complete draft submission (UAT-06) and missing-document rejection (UAT-07); the browser workflow for those cases remains unobserved.

No scenarios remain Not run; no scenario is currently blocked. UAT-23 passed after user-assisted file selection, and the UI and isolated database confirmed the replacement upload and resubmission. UAT-02 and UAT-09 passed through local API evidence. The controlled database now contains one reviewer assignment and its notification, and the application now has `submitted` status. The original password hashes for the controlled accounts were restored after role testing. Storage failure returned a generic 503 after fix and retest; responsive checks passed at the tested window sizes, while actual mobile devices and smaller widths remain untested; backend outage recovery and browser draft creation passed. API checks passed for unsupported upload, complete/missing submission, and reminder deduplication.

## 4. Defects and improvements

### UAT-FND-001 Ã¢â‚¬â€ Notification button did not open the panel

- **Initial observation:** Clicking the notification button did not display a notification panel.
- **Root cause:** The button had an empty callback.
- **Correction:** Added a notification-loading method and connected the button to it. The method displays a panel with loading, error, and empty-state handling.
- **Retest:** The populated notification panel opened and displayed three notification records.
- **Automated regression:** Flutter widget tests passed after the update.
- **Evidence:**
  - `10-evidence-index/evidence/screenshots/W17-E04-01-notification-panel.png`
  - `10-evidence-index/evidence/screenshots/W17-E04-02-notification-retest.png`
  - `10-evidence-index/evidence/test-outputs/W17-E04-03-flutter-test.png`
  - `10-evidence-index/evidence/test-outputs/W17-E04-04-flutter-analyze.png`
  - `10-evidence-index/evidence/test-outputs/W17-E04-05-flutter-release-build.png`

See `04-fixes-and-retest-evidence/fix-and-retest-register.md` for the detailed record.

## 5. Technical verification

| Area | Command or method | Recorded result |
|---|---|---|
| Backend regression | `php artisan test --no-ansi` from `backend/` | 70 passed, 179 assertions, 0 failures; PHPUnit used SQLite in-memory (`DB_CONNECTION=sqlite`, `DB_DATABASE=:memory:`) |
| Flutter tests | Flutter test runner, `test --no-pub` from `frontend/` | Passed; all widget tests |
| Flutter static analysis | `dart analyze lib test` from `frontend/` | No issues found |
| Flutter release build | Flutter tool, `build web --release --no-pub` from `frontend/` | Completed successfully |
| Browser login | Microsoft Edge | Student login and dashboard observed |
| Dashboard/application details | Microsoft Edge | Three applications and their document checklists observed |
| Dashboard refresh | Microsoft Edge | Displayed counts retained after refresh |
| Notification panel | Microsoft Edge | Passed after correction and retest |
| API route inspection | `php artisan route:list --path=api -v` from `backend/` | 18 routes listed successfully |
| OpenAPI validation | Redocly CLI lint | Current specification passed; exit code 0; one warning because no project license is declared. |
| Live API comparison | All 16 protected operations without a bearer token; login and registration with empty JSON | Protected routes returned 401 JSON; public auth routes returned 422 JSON; authenticated checks covered UAT-04–10, UAT-12–14, and UAT-16–18 with state assertions; remaining authenticated schema comparison is pending |
| Git and secret review | Final staged/unstaged review | Completed 22 Nov 2026; no high-confidence secret/private-key patterns found; no commit or push made |

### Recorded environment

The environment inventory was recorded on November 21, 2026. Some details were verified after the initial browser observations on that date and are included as an environment inventory, not as retroactively captured observation metadata.

- Operating system: Microsoft Windows 11 Home Single Language, version 10.0.26300, build 26300, 64-bit
- PHP: 8.4.27, 64-bit
- Laravel: 13.39.0
- Flutter: 3.47.8 stable
- Dart: 3.13.7
- Node.js: 24.21.0
- npm: 11.19.0
- MariaDB: 10.4.32, isolated test instance
- Database port/name: `3308` / `scholarship_requirement_tracker_clean_test`
- Browser: Microsoft Edge 157.0.4341.60, 64-bit
- Laravel API: `http://127.0.0.1:8000/api`
- Flutter Web: `http://localhost:5000`
- Recorded Edge device-emulation viewport: 400 × 662 px, student login screen only
- Initial environment inventory did not capture the desktop viewport; later UAT-19 recorded 950 × 814 and 502 × 814 window sizes.
- Environment inventory date: November 21, 2026; UTC+8
- Exact browser observation times: Not recorded

The Laravel `.env` points to the isolated test database on port 3308. PHPUnit is configured to use SQLite in-memory testing. No database credentials are included in this summary.

## 6. Deliverables

| Deliverable | Location | Status |
|---|---|---|
| UAT plan and approval record | `01-uat-plan-and-approval/` | Approval reported by project owner; formal approval artifact not attached |
| UAT scenarios and acceptance criteria | `02-uat-scenarios-and-acceptance/` | 28 passed, none blocked, none not run |
| UAT observations and findings | `03-uat-observations-and-findings/` | Recorded |
| Fix and retest register | `04-fixes-and-retest-evidence/` | One finding fixed and retested |
| Flutter Web workflow checklist | `05-flutter-web-workflow/` | Updated with browser and API outcomes; browser-only subcases identified |
| Architecture comparison | `06-architecture-comparison/` | Reviewed; provisional recommendation recorded |
| OpenAPI documentation | `07-openapi-documentation/` | 18 operations match current routes; lint passed with one license warning; all 16 protected responses and both public validation statuses match; selected authenticated response checks are complete; full field-level schema comparison remains pending |
| Repository README and maintenance plan | `08-repository-and-maintenance/` | Updated |
| Known limitations and final recommendation | `09-known-limitations-and-final-recommendation/` | Updated |
| Evidence index | `10-evidence-index/` | Updated |
| Weekly summary | `11-weekly-summary/` | Updated |

## 7. Limitations and risks

- All 28 UAT scenarios have final recorded results; 16 include browser evidence and 12 are API-only.
- The existing student browser account contains submitted applications; temporary drafts were created and removed for API UAT-05–07. A synthetic open program was prepared and UAT-27 browser draft creation passed; the draft remains in the isolated test database for inspection.
- Staff/reviewer dashboards have browser evidence for login, assignment, download, and allowed transitions. UAT-28 verified the New Application already-applied state; UAT-27 draft creation passed in the browser.
- UAT-20 backend outage safe failure and recovery passed in browser UAT; storage failure was tested through authenticated API UAT and retested after a fix.
- Responsive behavior passed at the recorded desktop and narrow window sizes; physical mobile devices and smaller widths remain untested.
- Notification loading, empty, and error states have not all been independently verified through browser UAT.
- OpenAPI lint passes with one warning because no project license is declared. All 16 protected route operations returned the documented unauthenticated 401 JSON response; empty login and registration bodies returned 422 JSON. Authenticated checks now cover selected upload and storage failure, submission, notification, authorization, download, transition, and reminder responses; full authenticated schemas remain pending.
- The project owner reports instructor approval; the formal approval artifact is not attached to the evidence package.
- The isolated MariaDB instance was already running; an attempted duplicate startup collided with its open data file. No permission changes or writes were made by that attempt, and the pristine backup was not touched.
- The tested Week 17 working tree was not committed or tagged at the time of the recorded observations.
- Production backup, monitoring, support, and deployment arrangements have not been established.

## 8. Final recommendation

**Suitable for continued controlled academic demonstration.**

The recommendation is supported by the recorded backend regression result, successful Flutter tests and analysis, successful release build, and all 28 UAT scenarios that passed in their final recorded state. UAT-23 passed, no scenarios remain Not run, and all UAT scenarios have recorded results; additional mobile-device and storage-provider configurations remain outside the tested environment.

The evidence does not support production deployment or unrestricted institutional use. Final Git/secret review is deferred by the owner; full authenticated field-level OpenAPI comparison and operational readiness work remain.

## 9. Integrity statement

This summary reports the activities and results actually recorded for the identified local working build and environment. The browser observations are dated November 21–22, 2026, and are distinguished from the scheduled Week 17 guide dates of November 23Ã¢â‚¬â€œ27, 2026.

Earlier-week results are not represented as Week 17 results. No catalogue scenario remains without a recorded result; specific browser-only subcases and smaller physical-device widths remain unverified. Instructor approval is recorded as the project owner's confirmation; the formal artifact and original decision date are unavailable. No unrecorded screenshot, test result, or production capability is claimed.

### Correction-resubmission workflow update

The submission workflow was extended to support resubmission from `for_correction`. The backend validates required submitted documents, changes the application status to `submitted`, and records the previous status and correction-resubmission reason in status history. Automated backend tests passed for successful correction resubmission and rejection when required documents are missing. Browser UAT-23 passed after user-assisted file selection; replacement upload and resubmission were verified in the UI and database.
