# Security and Adverse Test Results

**Project:** Scholarship Requirement Tracker  
**Testing Period:** Week 15 - Testing and Hardening  
**Test Scope:** Authentication, authorization, input validation, document handling, and failure handling

## 1. Objective

The objective of these tests was to verify that the backend rejects unauthorized requests, validates submitted data, protects application documents and notifications, and handles selected service failures safely.

## 2. Security Test Results

| Test Scenario | Expected Result | Verification |
|---|---|---|
| Unauthenticated user updates application status | HTTP 401 Unauthorized | Automated feature test |
| Unassigned reviewer updates application status | HTTP 403 Forbidden | Automated feature test |
| Reassigned reviewer downloads an application document | HTTP 403 Forbidden | Automated feature test |
| Student accesses another student's notifications | Access denied | Automated feature test |
| Student attempts to upload to another student's application | HTTP 403 Forbidden | Automated feature test |
| Invalid authentication token accesses notifications | HTTP 401 Unauthorized | Automated feature test |
| Revoked authentication token accesses a protected endpoint | HTTP 401 Unauthorized | Automated feature test |

## 3. Input Validation and Workflow Tests

| Test Scenario | Expected Result | Verification |
|---|---|---|
| Invalid document file type is uploaded | HTTP 422 Unprocessable Entity | Automated feature test |
| Document exceeds its configured size limit | HTTP 422 Unprocessable Entity | Automated feature test |
| Invalid application status is submitted | HTTP 422 Unprocessable Entity | Automated feature test |
| Reviewer directly approves a submitted application | HTTP 409 Conflict | Automated feature test |
| Required application documents are missing | Submission is rejected | Automated feature test |

Rejected uploads are also checked to ensure that an application document record is not created.

## 4. Service Failure and Recovery Tests

### Document Storage Failure

**Test:** `test_upload_returns_service_unavailable_when_storage_fails`

- Storage failure is simulated using a mocked storage operation.
- Expected response: HTTP 503 Service Unavailable.
- The test verifies that the application handles the failed storage operation instead of treating the upload as successful.

This test verifies application-level failure handling. It does not simulate an actual outage of the storage infrastructure.

### Missing Document File

The document download tests also verify that missing files, empty file paths, and nonexistent document records return HTTP 404 Not Found.

## 5. Evidence Screenshots

Screenshots are stored in:

`screenshots/`

Available evidence:

| Screenshot | Description |
|---|---|
| `W15-15-unassigned-reviewer-authorization-failed.png` | Initial unauthorized reviewer test evidence |
| `W15-16-reviewer-authorization-fix-passed.png` | Reviewer authorization correction evidence |
| `W15-20-document-storage-failure-handled.png` | Document storage failure handling |
| `W15-24-invalid-token-notification-tests-passed.png` | Invalid token and notification access tests |

Additional test evidence is available in:

- `03-api-test-results/screenshots/W15-26-application-status-workflow-tests-passed.png`
- `03-api-test-results/screenshots/W15-27-full-backend-regression-54-passed.png`

## 6. Overall Regression Verification

The latest complete Laravel backend regression run passed:

| Metric | Result |
|---|---:|
| Tests passed | 54 |
| Assertions | 114 |
| Failed tests | 0 |
| Execution time | 2.88 seconds |

The security and adverse scenarios listed in this report are covered by the backend feature tests included in the regression suite.

## 7. Limitations

The tests provide automated application-level verification. They do not constitute a complete penetration test or prove protection against every possible attack.

The following activities are outside the evidence recorded here:

- External penetration testing.
- Production infrastructure outage testing.
- High-volume load and stress testing.
- Independent security audit.

## 8. Conclusion

The Week 15 backend tests verify important security and adverse scenarios involving authentication, role-based authorization, document access, input validation, and selected service failures.

The latest backend regression suite passed with 54 tests, 114 assertions, and zero failures. The results provide documented evidence of the tested security and reliability controls.
