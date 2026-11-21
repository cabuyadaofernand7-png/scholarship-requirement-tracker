# Week 17 Final Recommendation

## 1. Build and environment

| Item | Recorded value |
|---|---|
| Project | Scholarship Requirement Tracker |
| Baseline commit | `3fb56db6f33889f1cb530cf71282dc6768224d50` |
| Tested build | Local Week 17 working tree based on the baseline commit |
| Week 17 commit status | Changes uncommitted at the time of recorded UAT |
| Release tag | No Week 17 tag created |
| Backend | Laravel 13.39.0, PHP 8.4.27 |
| Frontend | Flutter 3.47.8, Dart 3.13.7 |
| Database | MariaDB 10.4.32, isolated test instance |
| Browser | Microsoft Edge 157.0.4341.60, 64-bit |
| Recorded viewport | 400 × 662 px, Edge device emulation, student login screen |
| Browser observation date | 21 November 2026 |
| Exact observation times | Not recorded |
| Instructor approval | Confirmed by project owner; formal artifact not attached |

The baseline commit identifies the starting point, not a committed snapshot of all Week 17 changes. The tested working tree included uncommitted changes.

## 2. UAT outcome

The Week 17 scenario catalogue contains 28 scenarios.

| Result | Count | Explanation |
|---|---:|---|
| Planned | 28 | UAT-01 through UAT-28 |
| Executed with recorded results | 28 | Sixteen browser scenarios and twelve API-only scenarios; UAT-04 and UAT-13 also have supplementary API evidence |
| Passed | 28 | All executed scenarios passed in their final recorded state |
| Outstanding failed scenarios | 0 | No unresolved failure is recorded among the 28 executed scenarios |
| Blocked | 0 | No scenario remains blocked after the UAT-23 assisted retest |
| Not run | 0 | UAT-17 passed after a controlled storage failure fix and retest; UAT-19, UAT-20, and UAT-27 passed in browser sessions |
| Findings opened | 3 | UAT-FND-001 and UAT-FND-003 fixed and retested; UAT-FND-002 closed after user-assisted UAT-23 retest |
| Findings resolved and retested | 3 | Notification panel correction, storage-failure response fix, and user-assisted correction resubmission retest completed |
| Findings accepted/deferred | 0 | No formal accepted/deferred finding recorded |

UAT-22 initially failed because the notification button had an empty callback. The implementation was corrected and the panel was retested successfully. The final recorded result is Pass, while the original defect remains documented in the fix-and-retest register.

Sixteen scenarios have browser evidence across student, staff, and reviewer workflows; twelve others were validated through API-only checks. A passing scenario does not establish production readiness or physical-device compatibility.

## 3. Technical verification

| Verification | Recorded result |
|---|---|
| Backend regression | 70 tests passed, 179 assertions, 0 failures, SQLite in-memory |
| Flutter tests | Passed |
| Flutter analysis | No issues found |
| Flutter Web release build | Completed successfully |
| Student login browser workflow | Pass |
| Dashboard and application details | Pass |
| Dashboard refresh | Pass |
| Populated notification panel | Pass after correction and retest |
| Required-document replacement upload | Pass during UAT-23; metadata and private local-storage file confirmed in read-only state evidence |
| Missing-document submission browser feedback | Not separately demonstrated; API UAT-07 returned 422 and preserved the draft |
| Staff/reviewer login, reviewer assignment, authorized document access, allowed status workflow | Passed in controlled browser sessions; non-staff assignment and unassigned-reviewer denial also passed API checks |
| Desktop and narrow-window responsive layout | Pass at tested widths (UAT-19) |
| Backend outage safe failure and recovery | Pass (UAT-20) |
| Storage unavailable upload failure | Pass through controlled API outage and retest (UAT-17); no browser upload during the outage |
| OpenAPI parser validation | Passed with one non-fatal missing-license warning |
| Live API response comparison | All 16 protected unauthenticated operations returned JSON 401; public empty-body login and registration returned 422. Authenticated checks covered upload validation, complete/missing submission, notification isolation, authorization denials, invalid transition, reminder deduplication, and assigned/unassigned downloads; remaining authenticated schemas are pending |
| Git and secret review | Pending final repository review |

The recorded automated and browser results support continued controlled academic demonstration. They do not establish production readiness or physical-device compatibility.

## 4. Architecture recommendation

**Recommendation: retain the current Flutter Web + Laravel API + MariaDB architecture for the academic prototype.**

The existing architecture already supports the current student-facing Flutter application and Laravel API workflow. It also provides a clear separation between frontend, backend, database, and documentation responsibilities.

Replacing the architecture at this stage would introduce additional implementation and testing work without evidence that an alternative is necessary for the current prototype objectives.

This is a provisional academic-project recommendation based on the documented qualitative architecture comparison. It is not a production architecture approval.

## 5. Readiness recommendation

**Selected recommendation: Suitable for continued controlled academic demonstration.**

Reasons:

- The final full backend suite passed after the UAT-17 fix with 70 tests and 179 assertions using SQLite in-memory; the focused exception regression also passed with 1 test and 4 assertions.
- Flutter tests, analysis, and release web build completed successfully.
- Student login, dashboard data, application details, dashboard refresh, and the populated notification panel were observed working in the browser.
- The notification defect was corrected and successfully retested.
- The current implementation and its limitations are documented. UAT-17 passed after its storage exception fix and retest; UAT-19 passed at the tested window sizes; and UAT-20 passed after a controlled backend outage and recovery.

Conditions and qualifications:

- Sixteen of 28 scenarios have browser execution evidence; twelve additional scenarios passed through API-only UAT.
- The storage-failure scenario passed through a controlled API outage and retest; UAT-05–07 passed through API checks without separate browser demonstrations.
- Responsive layout passed at the tested 950 × 814 and 502 × 814 window sizes; smaller widths and physical mobile devices were not tested.
- Authenticated API responses and successful document downloads were verified for selected routes; full authenticated OpenAPI response-schema conformance remains incomplete.
- The project owner confirms instructor approval; the formal approval artifact and original decision date were not supplied.
- Student, staff, and reviewer browser UAT used existing controlled accounts. UAT-27 passed after a synthetic open program was added to the isolated test database. The isolated MariaDB test instance is running and readiness evidence is recorded. The pristine backup was not touched.
- Final Git and secret review was completed on 22 Nov 2026; no commit or push was made.

The prototype is not recommended for production deployment or unrestricted institutional use based on the current evidence.

## 6. Conditions and remaining work

| Action | Responsible person/team | Target |
|---|---|---|
| Complete field-level comparison of authenticated OpenAPI response schemas against live responses | Backend/API reviewer | Before API contract sign-off |
| Retain generated Laravel Boost agent guidance and developer configuration with no credentials; pin the dev dependency to `^2.10` (lockfile v2.10.4) | Completed in commit preparation | Before commit |
| Attach the formal instructor approval artifact if it becomes available | Project team | For the final portfolio record |
| Test additional physical mobile devices and narrower viewport sizes if required by the instructor | Project team | If required for final acceptance |
| Define production security, backup, monitoring, and support arrangements if deployment is proposed | Assigned institutional team | Before any production deployment |

Dates and named owners must be added when they are actually agreed. Approval is reported only where identified in the approval record above; the formal instructor artifact was not supplied.

## 7. Sign-off

| Role | Name / decision | Date |
|---|---|---|
| Prepared by | Project team | To be completed |
| Technical reviewer | To be assigned | Pending |
| Instructor approval | Confirmed by project owner on 21 Nov 2026; formal artifact not attached | Recorded |
| Final acceptance | Not yet recorded | Pending |

## Additional implementation and coverage boundaries

The correction-resubmission workflow was implemented and covered by automated backend tests. The backend accepts resubmission from `for_correction` when required documents have valid submitted records, records the previous status in status history, and rejects resubmission when required documents are missing. UAT-23 passed in the browser after user-assisted native file selection; the corrected filename, successful resubmission, and `for_correction` → `submitted` history were verified. UAT-07 browser rejection was not separately exercised; its API rejection scenario passed.

Staff and reviewer dashboards and their supporting endpoints have been implemented in the current working tree. The final full backend suite passed after the UAT-17 fix (70 tests, 179 assertions). Flutter analysis reported no issues, two widget tests passed, and the release web build succeeded. Browser UAT passed for staff/reviewer login, reviewer assignment, assigned-document viewing/download, and the allowed review status workflow. Unassigned-reviewer download denial passed through API UAT (UAT-14). Automated verification must not be treated as browser acceptance.
