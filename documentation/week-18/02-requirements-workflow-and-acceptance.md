# Requirements Workflow and Acceptance

## Roles

| Role | Main capability | Boundary |
|---|---|---|
| Student | Browse currently open programs, view required documents, create one draft per program, manage own documents, submit or resubmit after correction, view own notifications | Cannot view another student's applications or operate staff/reviewer functions |
| Staff | View application queue, list reviewers, assign a reviewer, run the deadline-check endpoint | Must be authenticated and have the staff role |
| Reviewer | View active assignments, inspect application/document metadata, download allowed documents, update permitted review status | Can access only assigned active work |
| Unauthenticated visitor | Register or log in | Protected endpoints reject the request |

## Demonstration workflow

1. Student signs in and sees their dashboard and application counts.
2. Student opens New Application and reviews currently accepting programs and document requirements.
3. Student creates a draft. The API prevents a second application for the same student/program.
4. Student opens the draft, uploads required sample files, and submits when required documents are valid.
5. If staff assigns the application, the assigned reviewer can inspect and download its documents.
6. Reviewer moves the application through permitted status transitions and can request correction.
7. Student replaces a requested document and resubmits; status history records the correction transition.

## Acceptance evidence

- UAT-27 browser evidence: open synthetic program, review four requirements, create a draft, and see the refreshed dashboard.
- UAT-28 browser evidence: already-applied state is shown and a duplicate application is not offered.
- UAT-23 browser evidence: user-assisted sample-file selection, corrected document display, and successful correction resubmission.
- UAT-24 to UAT-26 browser evidence: staff queue and assignment, reviewer assigned queue, authorized document access, and allowed transitions.
- UAT-05 to UAT-18 API evidence covers validation, missing/complete submission, ownership and role denials, notifications, status conflict, download authorization, reminders, and storage failure.

Detailed outcomes are in the Week 17 [scenario catalogue](../week-17/02-uat-scenarios-and-acceptance/uat-scenarios.md) and [observation log](../week-17/03-uat-observations-and-findings/uat-observation-log.md).
