# Week 18 Final Examination Portfolio

**Project:** Scholarship Requirement Tracker
**Student:** John Fernand C. Cabuyadao
**Examination date:** December 5, 2026 (assigned time not yet supplied)
**Current portfolio commit:** `f22496da0d1da97a6d8b15aa4d75615e62cb5a26`
**Status:** Defense materials prepared; live examination, individual viva, official upload, and final acceptance have not yet occurred.

This package consolidates the working solution, UAT evidence, and defense materials for the Week 18 E3 examination. The Week 17 portfolio remains the detailed source for scenario-level results. This Week 18 package points to those records, explains evidence boundaries, and provides a repeatable demonstration plan and defense guide. It does not present a future examination or upload as completed.

## Portfolio contents

| Section | Content | Status |
|---|---|---|
| 01–03 | Executive overview, requirements/workflow, architecture and decisions | Prepared |
| 04 | Evidence map and build traceability | Prepared; live exam evidence still to capture |
| 05 | Demonstration script and recovery fallback | Prepared; actual exam run pending |
| 06 | Security, deployment, and maintenance evaluation | Prepared with limits stated |
| 07 | Individual contribution and reflection | Draft based on student self-report; student should review reflection wording |
| 08 | Examination-day checklist | Prepared; final room/platform confirmation pending |
| 09 | Viva question bank | Prepared for practice |
| 11 | Presentation | Image-backed PowerPoint prepared; PowerPoint loaded all 13 slides after its repair prompt. Slide text is not editable; retain the PNGs as the reliable fallback. |

## Build and verification record

- Backend: `php artisan test` passed with 70 tests and 179 assertions after the storage-failure fix; PHPUnit uses SQLite in-memory.
- Flutter: Week 17 records show Flutter tests, static analysis, and release web build passed. A fresh CLI verification attempt on November 22 stalled before returning output, so this package does not claim a new pass.
- OpenAPI: 18 route operations are documented; Redocly lint passed with one non-fatal missing-license warning. Full authenticated field-level response-schema comparison remains incomplete.
- UAT: 28/28 scenarios have final recorded results: 16 browser scenarios and 12 API-only scenarios. Smaller physical-device widths and some browser-only adverse subcases remain unverified.
- Current browser automation was unavailable in this chat. Use the Week 17 genuine screenshots/API outputs as fallback evidence; capture any live exam run on the day if local access is available.

## Start commands

Follow the repository README and environment-specific instructions. From `backend/`, run `composer install`, configure the approved local `.env`, then `php artisan serve`. From `frontend/`, run `flutter pub get` and `flutter run -d edge`. Do not reset or reseed the isolated database on examination day. Confirm API and Flutter reach the expected local environment before signing in.

## Examination boundary

The prepared deck and scripts are presentation materials. Only the student can deliver the scheduled live demonstration, answer the viva in their own words, confirm the individual reflection, and complete official-platform upload verification. Production deployment is outside the approved prototype scope.
