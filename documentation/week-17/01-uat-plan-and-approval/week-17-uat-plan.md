# Week 17 UAT Plan

**Project:** Scholarship Requirement Tracker
**Week:** 17 â€” UAT Documentation and Evaluation
**Alignment:** SA9, AS3, CLO5, CLO6
**Planned dates:** November 23â€“27, 2026
**Build under test:** Week 17 local working build based on baseline commit `3fb56db6f33889f1cb530cf71282dc6768224d50`; Week 17 changes are uncommitted. No Week 17 build tag has been created.
**Environment:** Local controlled environment unless an authorized alternative is approved

## 1. Purpose

Evaluate whether the existing Scholarship Requirement Tracker supports the bounded student scholarship workflow and its relevant staff/reviewer API operations under controlled conditions. Record observed behavior, defects, decisions, fixes, and retest evidence.

## 2. UAT objectives

1. Verify student authentication and access to the student workflow.
2. Verify required-document upload and application submission behavior.
3. Verify invalid input and missing-document handling.
4. Verify protected API endpoints reject unauthenticated or unauthorized requests.
5. Verify staff/reviewer authorization rules for assignment, document download, and status updates.
6. Verify safe handling of a controlled service/storage failure where it can be reproduced safely.
7. Verify the Flutter Web login, document, and submission flow in the supported browser and responsive viewport sizes.
8. Record limitations and make a conditional recommendation based on evidence.

## 3. Scope

Included:
- Student login and logout.
- Student access to own application operations.
- Required document upload and validation.
- Application submission and missing-document rejection.
- Notifications access limited to the authenticated user.
- Staff reviewer assignment.
- Reviewer assignment-based document download and status update.
- Invalid, unauthorized, conflict, unavailable-storage, and recovery behavior where safely testable.
- Flutter Web behavior actually present in the current source.

Not included unless separately authorized:
- Production deployment or production capacity claims.
- Real student records or confidential scholarship documents.
- Live external email delivery.
- Uncontrolled load or penetration testing.
- Registrar or third-party integration not present in the current implementation.

## 4. Participants and responsibilities

| Role | Responsibility | Name / signature |
|---|---|---|
| UAT facilitator | Prepare build, data, test environment, and evidence | To be completed |
| Student tester | Execute student workflow using synthetic account | To be completed |
| Staff tester | Execute staff-only API scenarios using synthetic account | To be completed |
| Reviewer tester | Execute assigned/unassigned reviewer scenarios | To be completed |
| Instructor / approver | Review and approve plan before formal UAT | To be completed |

If one person performs multiple simulated roles, record that the session is a developer-led simulated UAT rather than independent stakeholder acceptance.

## 5. Entry criteria

- [x] Instructor approval confirmed by the project owner before UAT execution; formal artifact not attached.
- [ ] Exact build commit/tag recorded.
- [ ] Laravel and Flutter dependencies installed.
- [ ] Backend and frontend launch successfully.
- [ ] Active database configuration verified as the isolated test database.
- [ ] Synthetic accounts for required roles prepared.
- [ ] Synthetic scholarship application and required-document definitions prepared.
- [ ] Test files are non-confidential and within configured file limits.
- [ ] Evidence folders are ready.

## 6. Exit criteria

- Every planned scenario has an actual result recorded.
- Each failed or blocked scenario has a finding and disposition.
- Fixes are retested with evidence.
- Relevant regression tests pass, or remaining failures are explicitly explained.
- Flutter checks and supported browser observations are recorded.
- OpenAPI, repository guidance, architecture comparison, limitations, and maintenance plan are reviewed.
- Final recommendation identifies the tested build, environment, coverage, and limitations.

## 7. Test data and privacy

Use fabricated names, emails, scholarship applications, and sample documents. Do not use actual student identifiers, grades, addresses, financial information, or confidential scholarship files. Use unique synthetic records per scenario where practical.

## 8. Environment record

The environment inventory below was recorded on November 21, 2026. Some details were verified after the initial browser observations on that date; they should not be interpreted as values captured in every original observation.

| Item | Actual value |
|---|---|
| Baseline Git commit | `3fb56db6f33889f1cb530cf71282dc6768224d50` |
| Week 17 working-tree changes | Uncommitted at time of UAT evidence capture |
| Git tag | None |
| Operating system | Microsoft Windows 11 Home Single Language, version 10.0.26300, build 26300, 64-bit |
| PHP version | PHP 8.4.27, 64-bit |
| Laravel version | Laravel Framework 13.39.0 |
| Flutter / Dart | Flutter 3.47.8 stable; Dart 3.13.7 |
| Browser and version | Microsoft Edge 157.0.4341.60, 64-bit |
| Database engine/version | MariaDB 10.4.32, isolated test instance |
| Database port/name (sanitized) | Port `3308`; database `scholarship_requirement_tracker_clean_test`; no credentials recorded |
| API base URL | `http://127.0.0.1:8000/api` |
| Flutter Web URL | `http://localhost:5000` |
| Recorded Flutter viewport | 400 × 662 px; Edge device emulation; student login screen only |
| Desktop/narrow window sizes | UAT-19 later recorded 950 × 814 and 502 × 814; see observation log and evidence index |
| Environment inventory date | November 21, 2026; UTC+8 |
| Exact browser observation times | Not recorded |

The Laravel `.env` uses the isolated test database on port 3308. The PHPUnit configuration uses SQLite in-memory testing. No database credentials are included in this document.

## 9. Approval record

**Plan version:** 1.0
**Prepared by:** To be completed
**Submitted for review on:** To be completed
**Approval status:** Approved per project owner confirmation in this session.
**Approver:** Instructor approval reported by project owner; name not recorded here.
**Decision/date:** Approval confirmed by owner on November 21, 2026; exact instructor decision date not supplied.
**Comments/conditions:** Owner confirmed approval before UAT execution. Record the formal approval artifact and any instructor conditions when available.

The approval status above reflects the project owner's confirmation that the instructor approved the plan. Attach the formal record if it becomes available; its absence does not change the reported approval status.
