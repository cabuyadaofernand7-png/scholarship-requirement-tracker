# Week 17 â€” UAT Documentation and Evaluation Package

**Project:** Scholarship Requirement Tracker
**Week:** 17 â€” UAT Documentation and Evaluation (SA9 and AS3)
**Course outcomes:** CLO5 and CLO6
**Guide dates:** November 23â€“27, 2026
**Package basis:** Inspection of the uploaded project ZIP, including Laravel API routes/controllers, Flutter source, Week 15 test evidence, and Week 16 evaluation documents.

## Purpose

This package provides the Week 17 folder structure, working documentation drafts, scenario sheets, evidence templates, a source-aligned OpenAPI draft, and safe verification helpers.

It is tailored to the current repository and includes UAT evidence recorded on November 21–22, 2026. All 28 scenarios passed (16 browser and 12 API-only; UAT-04 and UAT-13 also have supplementary API evidence). UAT-28 verified the already-applied program state and that the student's application count remained three. UAT-27 passed after a synthetic open program with four requirements was added to the isolated database; the controlled student created a draft. Staff/reviewer sessions verified role dashboards, reviewer assignment and notification, authorized document download, and the submitted→under_review→for_correction workflow. UAT-23 passed after the user assisted with native file selection; the corrected filename, SUBMITTED dashboard status, and status-history record were verified. Invalid login returned generic JSON 401 without a token; unauthenticated requests to 16 protected API operations returned JSON 401. All three findings have been resolved and retested. The owner confirms instructor approval; the formal approval artifact has not been attached. The original password hashes for the controlled student, staff, and reviewer accounts were restored after role testing. The planned UAT period is November 23–27, 2026.

## Install into the repository

1. Extract this ZIP.
2. Copy the `week-17` folder into the repository's `documentation` folder.
3. If `documentation/week-17` already exists, merge the folders. Review any same-name file before replacing it.
4. Keep all real screenshots, terminal outputs, and exported test results inside the matching evidence folders.
5. Do not copy `.env`, database dumps, tokens, private student records, or real scholarship documents into this package.

Expected destination:

`scholarship-requirement-tracker/documentation/week-17/`

## Package map

- `01-uat-plan-and-approval/` â€” UAT plan and approval record
- `02-uat-scenarios-and-acceptance/` â€” controlled test scenarios and acceptance criteria
- `03-uat-observations-and-findings/` â€” actual observation and finding records
- `04-fixes-and-retest-evidence/` â€” defect/fix/retest records
- `05-flutter-web-workflow/` â€” UI workflow and responsive checks
- `06-architecture-comparison/` â€” architecture alternatives and recommendation
- `07-openapi-documentation/` â€” OpenAPI 3.1 draft based on inspected API routes/controllers
- `08-repository-and-maintenance/` â€” project README and maintenance plan drafts
- `09-known-limitations-and-final-recommendation/` â€” limitations and conditional recommendation
- `10-evidence-index/` â€” evidence inventory
- `11-weekly-summary/` â€” weekly summary template
- `scripts/` â€” safe local verification helpers

## Important source-alignment notes

The inspected Laravel API routes include:
- `POST /api/register`
- `POST /api/login`
- `POST /api/logout` (Sanctum protected)
- `GET /api/user` (Sanctum protected)
- `GET /api/notifications` (Sanctum protected)
- `POST /api/applications/{application}/submit`
- `POST /api/applications/{application}/documents`
- `GET /api/documents/{document}/download`
- `POST /api/applications/{application}/assign-reviewer`
- `PATCH /api/applications/{application}/status`
- `POST /api/applications/{application}/check-missing-documents`
- `POST /api/automation/check-deadlines`

The Flutter source inspected in the archive currently implements student login, notifications, document upload, and application submission calls. Do not describe staff/reviewer workflows as available in the Flutter interface unless a current browser run verifies them; those operations are currently represented in backend API routes/controllers.

## Safe execution rules

- Use synthetic test accounts and test files only.
- Confirm the active Laravel `.env` points to the isolated test database before running tests that modify data.
- Preserve the original MariaDB data directory and pristine recovery snapshot.
- Do not run `migrate:fresh`, `migrate:refresh`, `migrate:reset`, or destructive database commands for UAT.
- Run verification commands from the correct `backend` and `frontend` folders.
- Do not expose credentials, bearer tokens, `.env` contents, or private document contents in screenshots.
- A local UAT result is not proof of production readiness.

## Suggested order

1. Obtain instructor approval of the UAT plan.
2. Prepare synthetic student, staff, and reviewer accounts and application records.
3. Run backend regression and Flutter checks.
4. Execute each UAT scenario, recording actual result, evidence filename, and disposition.
5. Fix reproducible defects, then rerun the relevant scenario and regression checks.
6. Complete architecture comparison, OpenAPI review, README, and maintenance plan.
7. Complete evidence index and weekly summary.
8. Perform final Git and secret checks, commit, and push the verified Week 17 package.
