# Flutter Web Workflow and Responsive UAT Checklist

## Source inspection baseline

The current Flutter source includes:
- `POST /api/login`
- `POST /api/logout`
- `GET /api/notifications`
- `GET /api/staff/applications`
- `GET /api/staff/reviewers`
- `GET /api/reviewer/applications`
- `POST /api/applications/{applicationId}/assign-reviewer`
- `PATCH /api/applications/{applicationId}/status`
- `GET /api/documents/{documentId}/download`
- `POST /api/applications/{applicationId}/documents`
- `POST /api/applications/{applicationId}/submit`

Login routes students, staff, and reviewers to role-specific dashboards. Browser UAT confirmed staff and reviewer login, reviewer assignment, assigned-document download, and permitted status transitions. Protected upload and submission calls were exercised through API UAT, and browser UAT covered draft creation and correction resubmission. UAT-17 storage failure passed through API UAT; its browser upload path was not separately run.

## Browser and viewport record

| Browser/version | OS | Viewport | Date | Build reference |
|---|---|---|---|---|
| Microsoft Edge 157.0.4341.60 (64-bit) | Windows 11 Home Single Language, version 10.0.26300 (build 26300), 64-bit; exact OS details were verified in the environment inventory on November 21, 2026, after the browser observation | 400 Ã— 662 px; Edge device emulation; student login screen | 21 Nov 2026 | Baseline `3fb56db6f33889f1cb530cf71282dc6768224d50`; Week 17 changes uncommitted |
| Microsoft Edge 157.0.4341.60 | Windows 11 | 950 × 814 and 502 × 814 window sizes; UAT-19 | 22 Nov 2026 | Week 17 working build |

The 400 Ã— 662 px observation confirms that the login screen was displayed at that viewport. It does not establish that the complete authenticated workflow is responsive.

## Checklist

| Check | Expected observation | Actual result | Status | Evidence |
|---|---|---|---|---|
| Login page initial load | Page renders without console/runtime error | Student login page was displayed during browser testing. Console/runtime error inspection was not recorded. | Partially observed | Existing login-screen observation; screenshot filename not recorded |
| Empty login submission | Required/invalid input feedback is understandable | Not tested | Not run | |
| Invalid credentials | Safe error shown; no crash | Not tested | Not run | |
| Valid student login | Student dashboard opens | Valid student login displayed the dashboard and authenticated API requests loaded the student's application data. | Pass | `../10-evidence-index/evidence/screenshots/W17-E03-01-dashboard.png` |
| Staff/reviewer login | Valid roles reach the matching dashboard and retain the authenticated session | Staff and reviewer reached their role dashboards. | Pass | `../10-evidence-index/evidence/screenshots/W17-UAT-24-staff-application-queue.png`; `../10-evidence-index/evidence/screenshots/W17-UAT-25-reviewer-assigned-application.png` |
| Staff work queue | Staff sees all applications and can select eligible reviewers | Staff queue loaded; reviewer assignment was visible and confirmed in isolated database state. Non-staff assignment denial returned 403 in API UAT-12. | Pass for queue/assignment; API denial passed | `../10-evidence-index/evidence/screenshots/W17-UAT-24-staff-application-queue.png`; `../10-evidence-index/evidence/screenshots/W17-UAT-24-reviewer-assignment-confirmed.png` |
| Reviewer work queue | Reviewer sees only active assignments and can inspect/download authorized documents | Assigned application and documents appeared; protected download succeeded. Unassigned-reviewer download denial returned 403 in API UAT-14. | Pass for assigned access; API denial passed | `../10-evidence-index/evidence/screenshots/W17-UAT-25-reviewer-assigned-application.png` |
| Reviewer status update | Permitted status transitions succeed; invalid/unassigned requests are rejected | `submitted` → `under_review` → `for_correction` succeeded and status history matched. Invalid transition returned 409 in API UAT-16; unassigned access returned 403 in UAT-14. | Browser pass; adverse API cases passed | `../10-evidence-index/evidence/screenshots/W17-UAT-26-submitted-to-under-review.png`; `../10-evidence-index/evidence/screenshots/W17-UAT-26-reviewer-for-correction-outcome.png` |
| Notifications load | Empty and populated states are understandable | Notification panel opened and displayed three notification records. Empty and error states were not tested. | Pass for populated state only | `../10-evidence-index/evidence/screenshots/W17-E04-01-notification-panel.png`; `../10-evidence-index/evidence/screenshots/W17-E04-02-notification-retest.png` |
| Document upload | Loading/success/failure feedback is visible | Successful required-document replacement was demonstrated during UAT-23. Loading and storage-failure states were not independently tested. | Partial; success observed | `../10-evidence-index/evidence/screenshots/W17-UAT-23-corrected-document-selected.png`; `../10-evidence-index/evidence/screenshots/W17-UAT-23-correction-documents-ready-to-resubmit.png` |
| Missing required documents | Submission is blocked with understandable feedback | API UAT-07 returned 422 and left the draft unchanged; browser-specific feedback was not separately demonstrated. | API pass; browser subcase not run | |
| Successful submission | Confirmation is visible and flow returns appropriately | UAT-27 created an open-program draft in browser; UAT-06 verified successful submission through API. Correction resubmission passed in browser UAT-23. | Pass across browser/API evidence | |
| Backend unavailable | Failure is shown without app crash; recovery after service returns | UAT-20 showed a safe error and Retry while API was stopped; after restart, Retry loaded programs. | Pass | `../10-evidence-index/evidence/screenshots/W17-UAT-20-backend-outage.png`; `../10-evidence-index/evidence/screenshots/W17-UAT-20-recovery.png` |
| Desktop layout | No unintended clipping/overflow | UAT-19 passed at 950 × 814; narrow-window check passed at 502 × 814. Physical desktop hardware dimensions are not separately characterized. | Pass at tested window sizes | UAT-19 screenshots in evidence index |
| Mobile layout | Controls remain usable; no unintended horizontal scrolling | Dashboard and program list at 502 × 814 window size passed; actual mobile devices and smaller widths were not tested. | Pass at tested width | |
| Keyboard/accessibility basics | Focus and controls can be used with keyboard where applicable | Not tested | Not run | |

## Evidence naming

Use names such as:
- `W17-UAT-01-login-desktop.png`
- `W17-UAT-02-login-mobile.png`
- `W17-UAT-03-invalid-login.png`
- `W17-UAT-04-upload-success.png`

Only use these names for screenshots actually captured. Record viewport size and tested build in the observation log. Do not treat proposed filenames as existing evidence.

## Current assessment

Student login, dashboard, notifications, correction resubmission, staff/reviewer queues, reviewer assignment, authorized document download, and permitted review status changes have browser observations recorded. API adverse authorization and validation checks passed, and UAT-20 recovery passed in browser. Browser-specific missing-document feedback, keyboard accessibility, and physical mobile-device coverage remain unverified.
