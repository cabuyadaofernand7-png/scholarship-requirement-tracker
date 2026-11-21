# Fix and Retest Register

| Finding ID | Root cause | Fix / code reference | Files changed | Retest command/scenario | Actual retest result | Evidence | Status |
|---|---|---|---|---|---|---|---|
| UAT-FND-001 | Notification bell had an empty `onPressed` callback (`onPressed: () {}`). | Added `showNotifications()` to open a notification bottom sheet and retrieve notification data using the existing `getNotifications()` API method. Connected the bell button to `showNotifications`. | `frontend/lib/main.dart`; `frontend/test/widget_test.dart` | Manual notification panel test; `flutter test`; `flutter analyze`; `flutter build web --release` | Manual retest displayed three notifications. Widget test passed. Static analysis reported no issues. Release web build completed successfully. |  `evidence/screenshots/W17-E04-01-notification-panel.png`; `evidence/screenshots/W17-E04-02-notification-retest.png`; `evidence/test-outputs/W17-E04-03-flutter-test.png`; `evidence/test-outputs/W17-E04-04-flutter-analyze.png`; `evidence/test-outputs/W17-E04-05-flutter-release-build.png`. | Fixed and retested |
| UAT-FND-002 | Native Windows file picker was outside the automation control surface, so the first selection attempt was not verified. | User-assisted file selection after restoring a verified student session; no code change required. | None | UAT-23: replace a requested document and resubmit | The replacement filename appeared in the application and database; submission succeeded, and status history recorded `for_correction` → `submitted`. | `evidence/screenshots/W17-UAT-23-corrected-document-selected.png`; `evidence/screenshots/W17-UAT-23-correction-documents-ready-to-resubmit.png`; `evidence/screenshots/W17-UAT-23-correction-resubmission-success.png`; `08-repository-and-maintenance/verification-20261121-role-dashboards/uat-state-check-20261122-correction-resubmission.json` | Closed by user-assisted retest |

| UAT-FND-003 | Flysystem directory-creation exceptions were not caught by the upload controller; the framework returned HTTP 500 with a local storage path. | Catch Flysystem filesystem exceptions, report them server-side, and return the existing generic HTTP 503 storage-unavailable message before database persistence. | `backend/app/Http/Controllers/Api/ApplicationDocumentController.php`; `backend/tests/Feature/ApplicationDocumentUploadTest.php` | `php artisan test --compact --filter=test_upload_returns_generic_service_unavailable_when_storage_throws`; repeat UAT-17 against controlled local storage outage | Focused feature test passed (1 test, 4 assertions). Controlled outage retest returned HTTP 503 with generic message; no document row was created, local path was not exposed, storage was restored, and temporary token/upload were removed. | `08-repository-and-maintenance/verification-20261121-role-dashboards/uat17-storage-failure-20261122.json`; `08-repository-and-maintenance/verification-20261121-role-dashboards/uat17-storage-failure-retest-20261122.json`; `10-evidence-index/evidence/test-outputs/W17-UAT-17-storage-failure-regression.txt` | Fixed and retested |

## Retest checklist

- [x] Reproduce and identify the original failure.
- [x] Identify root cause.
- [x] Make the correction.
- [x] Run the focused backend feature test for the storage exception path.
- [x] Run Flutter static analysis.
- [x] Run the production web build.
- [x] Capture and save genuine output and screenshots.
- [x] Update the evidence index.
- [x] Review staged/unstaged Git changes for secrets, local backups, and generated artifacts (22 Nov 2026; no commit/push).

## Correction-resubmission workflow implementation

- **Change:** Enabled student application resubmission from `for_correction` status.
- **Validation:** Required documents must have valid submitted records before resubmission is accepted.
- **Status history:** The previous application status and correction-resubmission reason are recorded.
- **Automated tests:** Successful correction resubmission and rejection when required documents are missing are covered by backend feature tests.
- **Regression result:** An earlier full backend suite passed with 62 tests and 145 assertions; the final post-fix suite passed with 70 tests and 179 assertions. See `08-repository-and-maintenance/verification-20261121-role-dashboards/backend-verification-after-storage-fix-20261122.txt`.
- **Browser retest:** UAT-23 passed after user-assisted file selection. Database state confirmed the corrected filename and status-history entry; see UAT-OBS-009.
