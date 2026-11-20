# Defect Record - Reassigned Reviewer Document Download

**Defect ID:** W15-DEF-004  
**Category:** Security - Authorization  
**Severity:** High  
**Status:** Fixed and Verified

## 1. Description

A reviewer whose assignment had been reassigned could still download an application's documents because the authorization check did not properly restrict access to active assignments.

## 2. Expected Result

A reviewer with a reassigned or otherwise inactive assignment must receive HTTP 403 Forbidden when attempting to download an application document.

## 3. Initial Actual Result

The regression test returned HTTP 200 OK instead of the expected HTTP 403 Forbidden.

## 4. Root Cause

The document download controller checked whether an assignment existed but did not verify that its status was active.

## 5. Fix Implemented

Updated `ApplicationDocumentDownloadController.php` to authorize document downloads only when the reviewer has an assignment with status `pending` or `in_progress`.

## 6. Verification

**Regression Test:** `test_reassigned_reviewer_cannot_download_document`

| Metric | Result |
|---|---:|
| Document download tests passed | 9 |
| Assertions | 9 |
| Failed tests | 0 |

The regression test confirmed that a reassigned reviewer is denied document access.

The subsequent full backend regression suite also passed:

- 54 tests passed
- 114 assertions
- 0 failures

## 7. Conclusion

The document download authorization weakness was corrected. Reviewers with reassigned or inactive assignments can no longer access application documents through this authorization check.

## 8. Evidence

- Test file: `backend/tests/Feature/DocumentDownloadTest.php`
- Full regression report: `03-api-test-results/full-backend-regression-test-results.md`
- Full regression screenshot: `W15-27-full-backend-regression-54-passed.png`
