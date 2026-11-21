# Executive Overview

## Project and problem

The Scholarship Requirement Tracker is an academic prototype for a bounded scholarship application process. Students need to see which programs accept applications, create a draft, understand required documents, upload them, and follow application status. Staff need a work queue and reviewer assignment. Reviewers need access to assigned applications and submitted documents.

## What the current build demonstrates

The committed build combines Flutter Web with a Laravel REST API, Laravel Sanctum authentication, a MariaDB-compatible relational model, and private local document storage. It implements role-specific student, staff, and reviewer screens; protected application and document operations; submission and correction resubmission; in-app notifications; reviewer assignment; and selected deadline/reminder endpoints.

The Week 17 UAT catalogue records 28 passing scenarios: 16 with browser evidence and 12 validated through API-only scenarios. The backend regression suite passed with 70 tests and 179 assertions after the storage-failure fix. The OpenAPI specification covers the current 18 API operations and passed parser lint with one missing-license warning.

## Recommendation

Retain the current Flutter Web + Laravel API + MariaDB architecture for the academic demonstration. It already implements the approved workflow and has end-to-end evidence. The recommendation is provisional and does not authorize production use.

## Limits that matter in the defense

The UI was checked at 950×814 and 502×814 browser window sizes; physical phones and smaller widths were not tested. Some authorization and validation adverse cases have API evidence but no separate browser demonstration. Full authenticated OpenAPI response-schema comparison, performance benchmarking, production deployment, encryption-at-rest verification, backup restoration, and continuous monitoring have not been demonstrated. State these boundaries clearly.
