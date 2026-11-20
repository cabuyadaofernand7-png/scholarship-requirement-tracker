# Defect Record - Reviewer Status Transition

**Defect ID:** W15-DEF-005  
**Category:** Functional - Application Workflow  
**Severity:** High  
**Status:** Fixed and Verified

## 1. Description

A reviewer could previously make a final application decision directly from the `submitted` status without first moving the application into the review stage.

## 2. Expected Result

A reviewer must first move a submitted application to `under_review` before making a review decision.

Permitted reviewer transitions include:

1. `submitted` to `under_review`
2. `under_review` to `incomplete`
3. `under_review` to `for_correction`
4. `under_review` to `approved`
5. `under_review` to `rejected`

## 3. Initial Actual Result

The previous workflow allowed a reviewer to approve a submitted application directly.

## 4. Root Cause

The application status controller validated the requested status but did not enforce the required transition sequence for reviewers.

## 5. Fix Implemented

Updated `ApplicationStatusController.php` with reviewer-specific transition rules.

Reviewers must move submitted applications to `under_review` before making a review decision. Staff permissions remain unchanged.

## 6. Verification

**Command:** `php artisan test --filter=ApplicationStatusTest`

| Test Scenario | Expected Result | Result |
|---|---|---|
| Reviewer moves submitted application to under_review | HTTP 200 | Passed |
| Reviewer directly approves submitted application | HTTP 409 | Passed |
| Reviewer approves application under review | HTTP 200 | Passed |

**Latest Application Status Test Results:**

- 9 tests passed
- 20 assertions
- 0 failures
- Duration: 1.12 seconds

The full backend regression suite also passed with 54 tests, 114 assertions, and zero failures.

## 7. Conclusion

The reviewer workflow now enforces the required review sequence. Reviewers cannot make a final decision before moving an application into `under_review`.

## 8. Evidence

- Test file: `backend/tests/Feature/ApplicationStatusTest.php`
- Test results: `03-api-test-results/application-status-test-results.md`
- Screenshot: `W15-26-application-status-workflow-tests-passed.png`
- Full regression screenshot: `W15-27-full-backend-regression-54-passed.png`
