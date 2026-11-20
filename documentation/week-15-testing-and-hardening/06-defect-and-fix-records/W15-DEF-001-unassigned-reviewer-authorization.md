# Defect Record - Unassigned Reviewer Authorization

**Defect ID:** W15-DEF-001  
**Category:** Security - Authorization  
**Severity:** High  
**Status:** Fixed and Verified

## 1. Description

An authenticated reviewer who was not assigned to an application was able to update its application status.

## 2. Expected Result

The API should return HTTP 403 Forbidden when an unassigned reviewer attempts to update an application.

## 3. Initial Actual Result

The API returned HTTP 200 OK, allowing the status update.

## 4. Root Cause

The controller checked the reviewer's role but did not verify their assignment to the specific application.

## 5. Fix Implemented

Added an assignment ownership check in `ApplicationStatusController.php`. Reviewers must have an active assignment with a `pending` or `in_progress` status before updating the application. Staff permissions remain unchanged.

## 6. Verification

**Command:** `php artisan test --filter=ApplicationStatusTest`

| Metric | Result |
|---|---:|
| Tests passed | 9 |
| Assertions | 20 |
| Failed tests | 0 |
| Latest duration | 1.12 seconds |

The tests verify that assigned reviewers can perform permitted status updates while unassigned reviewers receive HTTP 403 Forbidden.

The suite also verifies the reviewer status-transition requirement: a reviewer must move a submitted application to `under_review` before making a review decision.

## 7. Conclusion

The authorization weakness was corrected and verified through the latest application status test suite.

## 8. Evidence

- Test file: `backend/tests/Feature/ApplicationStatusTest.php`
- Screenshot: `W15-26-application-status-workflow-tests-passed.png`
- Screenshot folder: `03-api-test-results/screenshots`
