# Scholarship Requirement Tracker

A student-facing scholarship requirement tracking prototype built with Flutter Web, Laravel API, and MySQL/MariaDB.

## 1. Project purpose

The system supports a bounded scholarship application workflow:

- Student authentication and application access
- Required-document checklist and document submission
- Application validation and submission
- Reviewer assignment and review status updates through the backend API
- Student notifications and deadline reminders

The prototype is intended to demonstrate the normal application workflow and selected invalid, unauthorized, unavailable-service, and recovery scenarios. Features not implemented in the current build must not be represented as completed.

## 2. Technology and tested versions

| Layer / tool | Technology | Recorded version |
|---|---|---|
| Frontend | Flutter Web | Flutter 3.47.8 |
| Language | Dart | 3.13.7 |
| Backend | Laravel | 13.39.0 |
| Backend runtime | PHP CLI, 64-bit | 8.4.27 |
| Database | MariaDB | 10.4.32 |
| Browser | Microsoft Edge, 64-bit | 157.0.4341.60 |
| Authentication | Laravel Sanctum | Bearer-token authentication |

Versions above reflect the recorded Week 17 development and test environment. They are not a declaration of production compatibility.

## 3. Repository structure

- `frontend/` â€” Flutter Web application
- `backend/` â€” Laravel API application
- `database/` â€” database-related project materials and SQL files
- `documentation/` â€” weekly deliverables, technical notes, and evidence

Week 17 documentation is located in `documentation/week-17/`.

## 4. Local development setup

### 4.1 Backend

1. Install the required PHP version and Composer.
2. Install backend dependencies from the `backend/` directory:
   - `composer install`
3. Configure the local `.env` file using an approved isolated development database.
4. Never commit `.env`, passwords, API tokens, or other secrets.
5. For a new local environment only, generate an application key if one does not already exist:
   - `php artisan key:generate`
6. Clear cached configuration:
   - `php artisan config:clear`
7. Start the local Laravel server:
   - `php artisan serve`

Do not run destructive migration commands against the original database or a recovery snapshot. Use only an approved disposable database for migration and test work.

Laravel Boost is a development dependency constrained to `^2.10` and locked at v2.10.4. Its generated agent guidance/skills (`backend/AGENTS.md`, `backend/CLAUDE.md`, `backend/.agents/`, and `backend/.claude/`) and local MCP/Boost configuration (`backend/.mcp.json`, `backend/boost.json`) are retained intentionally as project developer tooling; they contain no credentials.

### 4.2 Frontend

From the `frontend/` directory:

1. Install Flutter dependencies:
   - `flutter pub get`
2. Check source and static analysis:
   - `flutter analyze`
3. Run widget and application tests:
   - `flutter test`
4. Start the web application:
   - `flutter run -d edge`

Confirm that the configured API base URL points to the intended local backend. The current Flutter API service uses a local API URL; this must be configured appropriately before deployment to another environment.

## 5. API documentation

The API contract draft is located at:

`documentation/week-17/07-openapi-documentation/openapi.yaml`

The baseline Laravel route inspection identified 13 API routes. Five role/application routes have since been added, bringing the current source to 18 routes. The updated OpenAPI specification passed Redocly lint with one non-fatal warning because no license is declared. All 16 protected route operations returned HTTP 401 with the documented JSON message when queried without bearer tokens; empty JSON requests to public login and registration returned HTTP 422 JSON. Invalid test-only login values returned generic JSON 401 without a token. Staff/reviewer browser sessions also demonstrated authorized document download. Authenticated API checks now include upload/storage failure, submissions, notification isolation, authorization denials, invalid transitions, reminder deduplication, and downloads. Full authenticated response-schema conformance and detailed validation-error body comparison remain incomplete.

Staff and reviewer API work queues and role dashboards are implemented in the current working tree. Browser UAT passed for role login, reviewer assignment, assigned-document access, and the allowed status workflow. Unassigned-reviewer download denial and invalid status transition were verified through authenticated API checks (UAT-14 and UAT-16).

## 6. Testing and verification

### 6.1 Backend

Run from `backend/`:

`php artisan test`

Recorded full Week 17 backend result before the UAT-17 storage-exception fix:

- 70 tests passed
- 179 assertions
- 0 failures

After the UAT-17 fix, the focused storage-exception regression passed with 1 test and 4 assertions; the full suite was not rerun after that change.

### 6.2 Flutter

Run from `frontend/`:

- `flutter test` â€” passed
- `flutter analyze` â€” no issues found
- `flutter build web --release` â€” completed successfully

These results describe the recorded local test run. Repeat the checks after relevant source changes.

### 6.3 Browser UAT observations

The recorded student, staff, and reviewer browser observations include:

- Successful student login and dashboard display
- Three application records displayed
- Twelve submitted documents displayed
- Zero missing documents in the available test records
- Application details and uploaded filenames displayed
- Dashboard refresh completed
- Notification panel displayed three notification records after a defect was corrected
- Staff queue displayed submitted applications; reviewer assignment and its notification were confirmed
- Reviewer saw its assigned application and documents; an authorized document download succeeded
- Assigned reviewer moved the application to `under_review` and then `for_correction`; status history matched

All 28 scenarios passed (16 browser and 12 API-only); none remain Not run. UAT-23 passed after user-assisted file selection; the corrected filename, successful submission, and status history were verified. API UAT verified unsupported upload rejection, complete draft submission, missing-document rejection, and reminder deduplication. UAT-17 storage failure, UAT-19 responsive layout at the recorded widths, and UAT-20 outage/recovery passed.

See the Week 17 UAT scenario catalogue, observation log, and evidence index for scenario-level results.

## 7. Security and privacy

- Do not commit `.env`, API tokens, passwords, database dumps, private keys, or real student documents.
- Use synthetic test data for development and UAT.
- Keep uploaded application documents in private storage.
- Restrict document downloads to authorized users and assigned reviewers.
- Review role authorization and ownership checks whenever API endpoints change.
- Avoid placing confidential decisions or sensitive application details in notification content.
- Use HTTPS, protected configuration, appropriate storage permissions, and production-grade secret management in any future deployment.
- Review logs to ensure they do not expose credentials, tokens, or confidential student information.

## 8. Known implementation boundaries

- The current Flutter API service targets a local API URL.
- The Flutter application includes student login, dashboard/application data, a New Application program browser, notifications, document upload, and submission-related API calls.
- Staff and reviewer dashboards have browser evidence for login, assignment, document access, and allowed status transitions; selected authorization denials were verified in API UAT; other route schemas remain subject to contract review.
- Browser UAT has not verified every scenario in the UAT catalogue.
- The recorded local build and tests do not establish production readiness.
- The OpenAPI specification passed the recorded Redocly validation with one non-fatal warning because no project license is declared; selected authenticated responses were compared with live API results; complete response-schema conformance remains unverified.

## 9. Contribution and change workflow

1. Agree on the task and identify the files affected.
2. Make focused, reviewable changes.
3. Run the relevant backend and frontend tests.
4. Run `flutter analyze` and a release web build when frontend changes warrant them.
5. Inspect both `git diff` and `git diff --cached`.
6. Check for secrets, local backups, generated files, and unrelated changes.
7. Review and approve the final change set before committing.
8. Commit with a descriptive message.
9. Push and verify the remote branch and commit.

Do not include temporary backups, local database files, generated build output, or environment-specific secrets in the repository.

## 10. Support and maintenance

See `maintenance-plan.md` for proposed maintenance, data protection, recovery, and operational responsibilities.

## Correction resubmission workflow

The student submission workflow supports applications in both `draft` and `for_correction` status. When a student resubmits an application after corrections, the backend checks that the required documents have valid submitted records, changes the application status to `submitted`, and records the previous status and correction-resubmission reason in status history.

The workflow is covered by automated backend tests, including successful correction resubmission and rejection when required documents are missing. UAT-23 also passed in the browser after user-assisted native file selection. The corrected filename, SUBMITTED dashboard state, and database transition from `for_correction` to `submitted` are recorded in the Week 17 evidence package.
