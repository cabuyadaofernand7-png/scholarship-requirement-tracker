# Week 15 – Document Upload API Test Results

## 1. Test Information
- Project: Scholarship Requirement Tracker
- Testing Area: Application Document Upload API
- Testing Tool: Laravel PHPUnit
- Test File: `ApplicationDocumentUploadTest.php`
- Test Status: PASSED

## 2. Test Execution

**Command:** `php artisan test --filter=ApplicationDocumentUploadTest`

**Actual Results:**
- Tests passed: 5
- Assertions: 12
- Failed tests: 0
- Execution time: 0.80 seconds

## 3. Test Coverage

- Student can upload a valid document.
- Invalid file types are rejected.
- Files exceeding the allowed size are rejected.
- Documents belonging to another scholarship program are rejected.
- Another student cannot upload documents to someone else's application.

## 4. Test Result

**Overall Result: PASSED**

All five document upload tests passed with 12 assertions. The results demonstrate that the tested file validation, scholarship program ownership, and student access restrictions work as expected.

## 5. Evidence

- `W15-11-document-upload-tests-passed.png`

## 6. Limitations

These tests cover the five upload scenarios listed above. They do not establish that malware scanning, all possible file formats, or every file upload security risk has been verified.

## Additional Test – Storage Failure

**Test:** Upload returns service unavailable when storage fails.

**Expected Result:** HTTP 503 Service Unavailable, with no incomplete document record saved.

**Actual Result:** HTTP 503 Service Unavailable.

**Test Result:** PASS

**Updated Upload Test Suite:** 6 passed, 15 assertions, 0 failures.

### Conclusion
The document upload process now handles storage failures safely. Existing file validation, ownership authorization, and successful upload behavior continue to pass.