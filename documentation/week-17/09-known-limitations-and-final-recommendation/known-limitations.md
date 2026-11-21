# Known Limitations and Evidence Boundaries

This document records implementation observations, verified Week 17 results, outstanding UAT scenarios, and operational limitations. It distinguishes source-code inspection, automated testing, and actual browser observations.

## 1. Current implementation observations

The following implementation details were inspected during project development:

- The Flutter client API base URL currently targets `http://127.0.0.1:8000/api`.
- The Flutter application includes student, staff, and reviewer role dashboards. The staff dashboard lists applications and supports reviewer assignment; the reviewer dashboard is restricted to assigned work, displays uploaded document metadata, supports authorized downloads, and offers the existing review status transitions.
- Login routes student, staff, and reviewer roles to their respective dashboards. Unknown roles are logged out.
- Backend routes include reviewer assignment, application status updates, document download, missing-document checks, deadline automation, and student application retrieval.
- Uploaded files use Laravel local storage in the inspected implementation.
- Browser UAT was completed for student, staff, and reviewer sessions, including staff assignment, reviewer document access and status workflow, student draft creation, a backend outage/recovery, and responsive layout at the recorded desktop and narrow window sizes. Smaller widths, physical mobile devices, and some browser-specific adverse cases were not tested. The isolated MariaDB test instance is used only for controlled local UAT. The formal UAT approval artifact was not supplied, but the project owner confirms instructor approval.
- The OpenAPI specification matches the 18 registered route operations and passes Redocly lint with one non-fatal missing-license warning. All 16 protected route operations returned the documented unauthenticated JSON response; empty login and registration requests returned 422 validation responses. Authenticated response comparison and some detailed schemas remain outstanding.

## 2. Week 17 verified technical results

### Backend

The final full Week 17 backend regression run, after the UAT-17 storage-exception fix, completed with:

- 70 tests passed
- 179 assertions
- 0 failures

The final result is recorded in `08-repository-and-maintenance/verification-20261121-role-dashboards/backend-verification-after-storage-fix-20261122.txt`. It uses PHPUnit SQLite in-memory, not the running MariaDB instance. The suite includes authentication, authorization, document-download, notification, reviewer-assignment, application, and storage-failure tests, plus three role work-queue tests. It does not establish that every workflow has been accepted through browser UAT.

### Flutter

The baseline Week 17 frontend checks completed with:

- `flutter test` — passed
- `flutter analyze` — no issues found
- `flutter build web --release` — completed successfully

After the staff/reviewer UI changes, direct Dart analysis again reported no issues, the Flutter widget suite passed, and the release web build completed. See `08-repository-and-maintenance/verification-20261121-role-dashboards/frontend-verification.txt`.

### Browser UAT

Sixteen scenarios have browser execution evidence across student, staff, and reviewer roles. Recorded scenarios cover login and dashboards, application details and notifications, required-document replacement and correction resubmission, reviewer assignment, assigned document download, allowed status transitions, draft creation, backend outage recovery, and responsive layout at a desktop window and a 502 × 814 narrow window. UAT-17 storage failure and twelve additional scenarios were exercised through authenticated API checks.

The dashboard displayed three applications, twelve submitted documents, and zero missing documents. Each displayed application had four required documents and 100% completion.

The notification bell initially did not open a panel because its callback was empty. The callback was connected to the notification-loading method, and the panel was subsequently tested successfully with three notification records.

All 28 scenarios passed (16 browser and 12 API-only; UAT-04 and UAT-13 also have supplementary API evidence). Passing the planned scenarios does not establish production readiness or actual-device compatibility.

## 3. Coverage boundaries and remaining checks

The Week 17 scenario catalogue contains 28 scenarios: all 28 passed and none remain Not run. UAT-02 passed through a local API request that returned a generic 401 without a token. UAT-09 passed because 16 protected operations returned 401 without credentials. UAT-03, UAT-11, UAT-13, UAT-15, and UAT-24–26 have browser results for role login, assignment, document access/download, and allowed status transitions. UAT-04–10, UAT-12–14, UAT-16–18 also passed authenticated API checks for permitted upload, draft submission and missing-document rejection, cross-user denial/isolation, role denials, document downloads, invalid transition handling, and reminder deduplication. UAT-23 passed after user-assisted file selection; the corrected filename, successful submission, private file, and status history were verified. UAT-28 passed in the browser. UAT-27 passed after a synthetic open program enabled safe browser draft creation.

No UAT scenario remains unrun. Some acceptance subcases remain unverified: UAT-05–07 passed through API scenarios but did not receive separate browser demonstrations; storage failure was tested by a controlled API outage; and responsive checks passed at the 950 × 814 and 502 × 814 window sizes, while actual mobile devices and smaller widths remain untested.

The existing student browser account contains submitted applications with all four required documents uploaded. Temporary API drafts were used for UAT-05–07 and removed after state verification. A synthetic open program was prepared, and UAT-27 browser draft creation passed; the resulting draft remains in the isolated test database for inspection. Correction-document replacement and resubmission passed through UAT-23.

A 502 × 814 narrow Edge window at 100% zoom and a 150% zoom stress view were recorded. The application cards and requirements wrapped without visible clipping at those sizes; narrower devices and actual mobile browsers were not tested.

The populated notification panel was manually tested. Its loading, empty, and error states have not all been independently verified through browser UAT.

## 4. Prior-week evidence boundaries

Week 15 documentation reports 54 backend tests and 114 assertions passing, together with Flutter analysis, widget-test, and web-build checks. These are Week 15 results and must not be represented as Week 17 results.

Week 16 documentation reports a local sequential baseline of 30 successful `GET /up` requests. This does not establish concurrent-user capacity, production performance, or service availability under load.

Week 17 backend and Flutter results are recorded separately in the Week 17 evidence and test documentation.

## 5. API and architecture limitations

- The API client currently uses a localhost base URL and needs environment-specific configuration before deployment.
- The current OpenAPI document passes Redocly lint with exit code 0 and one warning: no project license is declared. All 18 operations have operation IDs.
- Live unauthenticated response checks covered all 16 protected operations; each returned HTTP 401 JSON. Empty JSON login and registration requests returned HTTP 422 JSON. Authenticated live checks covered UAT-04–08, UAT-10–14, UAT-16, and UAT-18, including upload and submission statuses, notification isolation, authorization denials, file downloads, invalid transition, and reminder deduplication. Detailed response schemas for the remaining authenticated operations still need comparison against the OpenAPI contract.
- The current architecture comparison is qualitative and supports retaining the existing Flutter Web and Laravel API approach for the academic prototype.
- The architecture recommendation is not evidence of production suitability.

## 6. Operational and deployment limitations

- Local file storage is not a demonstrated highly available document-storage service.
- The Laravel `/up` endpoint is a basic application health signal, not comprehensive dependency monitoring.
- No production environment or production load capacity has been established.
- No production backup schedule, retention policy, or tested production recovery process has been established.
- No production maintenance team, escalation process, RPO, or RTO has been assigned.
- Production HTTPS, secret management, storage permissions, monitoring, and deployment configuration require further implementation and review.
- Local automated tests and limited browser UAT do not authorize production deployment.

## 7. Evidence and approval boundaries

- The recorded browser observations are dated 21 November 2026.
- The tested working tree was based on baseline commit `3fb56db6f33889f1cb530cf71282dc6768224d50`.
- Week 17 changes were uncommitted at the time of the recorded observations.
- No Week 17 release tag was created.
- The project owner confirms that the instructor approved the UAT plan. The formal approval artifact, instructor identity, and original decision date were not supplied.
- Evidence screenshots and test-output screenshots are listed in the Week 17 evidence index.

These limitations must remain visible in the final recommendation and must not be described as completed work without additional evidence.

## Correction resubmission browser-testing limitation

The correction-resubmission workflow has automated backend test coverage for success and missing-document rejection. UAT-23 also passed in the browser after user-assisted native file selection: the replacement filename, successful resubmission, and `for_correction` → `submitted` history were verified. UAT-07 passed through API UAT; a separate browser missing-document rejection demonstration was not performed.
