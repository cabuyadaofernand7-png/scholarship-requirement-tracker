# Week 16 Evaluation Design and Test Conditions

**Project:** Scholarship Requirement Tracker\
**Reference build:** `week-15-hardened-build` (tag target: `534efa4`)
**Week 16 measurement commit:** `945e04c`\
**Preparation date:** November 21, 2026\
**Status:** Test design prepared; partially executed. The local health-endpoint baseline and Flutter login-screen observations are documented separately. Remaining workload and regression tests are not claimed as completed.

## 1. Evaluation objective
Evaluate the existing application under controlled local conditions. Observe API responsiveness, basic service availability, Flutter Web behavior, resource use, configuration differences, and recovery procedures.

## 2. Application areas
The API route inventory confirms these routes:

| Method | Route | Purpose |
|---|---|---|
| POST | `/api/login` | Authentication |
| POST | `/api/logout` | Logout |
| GET | `/api/user` | Authenticated user information |
| POST | `/api/register` | Registration |
| POST | `/api/applications/{application}/submit` | Application submission |
| POST | `/api/applications/{application}/documents` | Document upload |
| GET | `/api/documents/{document}/download` | Document download |
| POST | `/api/applications/{application}/assign-reviewer` | Reviewer assignment |
| PATCH | `/api/applications/{application}/status` | Status update |
| POST | `/api/applications/{application}/check-missing-documents` | Missing-document check |
| POST | `/api/automation/check-deadlines` | Deadline check |
| GET | `/api/notifications` | Notifications |

The route inventory is descriptive. Do not call mutating endpoints as part of a generic performance loop.

## 3. Test levels

### Level A — Safe service observation
- Confirm the backend responds to its documented health endpoint, if available.
- Use a small number of sequential requests.
- Record status code and elapsed time.
- Do not submit application changes or upload files.

### Level B — Existing automated regression
- Run the existing Laravel feature suite.
- Record test count, assertions, failures, and duration.
- Do not describe regression tests as load tests.

### Level C — Flutter Web observation
- Start the frontend using the documented project command.
- Observe initial load, navigation, and responsive layout.
- Capture actual screenshots at tested viewport sizes.

### Level D — Controlled resource observation
- Record machine and process resource observations before, during, and after the test.
- Record the observation interval and measurement tool.
- Avoid uncontrolled concurrency or stress.

## 4. Workload conditions

| Model | Planned users | Execution |
|---|---:|---|
| Ordinary | 1–3 | Controlled, sequential or low-concurrency observation |
| Simulated peak | 5–10 proposed | Only if a safe, non-mutating test method is verified |

The peak model is optional and must be reduced or skipped if the local environment cannot safely support it. Do not use real user accounts or confidential records.

## 5. Stop conditions
Stop immediately if:
- MariaDB or the web server becomes unstable.
- Unexpected database writes or errors appear.
- The machine becomes unresponsive.
- The test begins affecting unrelated applications or data.
- A test requires a real student record, secret, or unauthorized account.

## 6. Result recording
For each test record:
- Test ID and date/time.
- Commit or tag.
- Environment and browser.
- Workload and duration.
- Procedure and tool.
- Expected result.
- Actual result.
- Error count and observations.
- Screenshot or log filename.
- Limitations.

## 7. Restrictions
Do not use destructive migrations, database resets, bulk document uploads, public traffic generators, or production credentials. A local result is not a production-capacity guarantee.
